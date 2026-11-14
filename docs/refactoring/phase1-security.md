# Phase 1 — Spring Security 도입과 권한

Phase 1은 두 단계로 나눈다.

| 단계 | 내용 | 상태 |
|---|---|---|
| 1-1 | Security 로그인, 역할(ROLE), URL 인가, 비밀번호 재확인 우회 수정, 열려 있던 엔드포인트 제거 | 완료 |
| 1-2 | CSRF 활성화, 상태 변경 GET 요청 19개를 POST로 전환 | 완료 |

## 1-1 이전 상태

| 영역 | 문제 |
|---|---|
| 로그인 | 컨트롤러가 직접 BCrypt를 검사하고 세션에 `id`를 넣음. 세션 고정 방어가 없음 |
| 의존성 | BCrypt 인코더 하나 때문에 `spring-security-web 4.0.0`(2015년)을 사용 |
| 인가 | 인터셉터가 `/users/*`, `/group_managing/*`, `/support/support_inquire`만 보호. 나머지는 각 메서드가 세션 값을 직접 확인 |
| 관리자 | `id.equals("admin")` 하드코딩 |
| 비밀번호 재확인 | `PwdAuthInterceptor`가 `?isSuccess=true` 파라미터만 보고 통과. 실제 수정·탈퇴 요청에는 아예 적용되지 않음 |
| 미사용 엔드포인트 | `/group/delete` 등 초기 스캐폴딩이 로그인 없이 열려 있었음. 비로그인 GET 한 번으로 남의 모임 삭제 가능 |
| 전체 문의 내역 | 관리자용 `support_inquire_inquireStatus`를 누구나 열람 가능 |

## 결정

**기본은 로그인 필요(deny by default).** 공개 페이지만 `SecurityConfig.PUBLIC_PAGES`에 명시한다.
새 기능을 추가하면서 깜빡해도 열려 있는 쪽이 아니라 막혀 있는 쪽으로 실수하게 된다.

**경로 매칭은 `mvcMatchers`.** `antMatchers("/a")`는 `/a/`와 매칭되지 않지만 Spring MVC는 `/a/`도 같은 핸들러로 보낸다.
ADMIN 규칙을 `antMatchers`로 쓰면 끝에 `/`만 붙여서 우회할 수 있다(`AccessRulesTest`에서 검증).

**레거시 세션 브리지.** 기존 코드는 `session.getAttribute("id")`를 Java 52곳, JSP 17곳에서 쓴다.
한 번에 바꾸면 위험하므로 로그인 성공 시 세션에 같은 키를 함께 넣는다(`LegacySession`).
Phase 2에서 서비스 계층을 정리하면서 `@AuthenticationPrincipal`로 하나씩 바꾸고 브리지를 제거한다.

**기존 화면 유지.** 로그인 폼 필드(`id`, `pwd`, `url`)와 결과 화면(`users/login.jsp`의 sweetalert)을 그대로 쓴다.
로그인 후 돌아갈 `url`은 같은 사이트 경로만 허용한다(open redirect 방지). 이 값은 `<script>` 안에 출력되므로 따옴표, 꺾쇠 같은 문자도 거부한다.

**역할은 DB에.** Flyway `V2__add_user_role.sql`로 `USERS_TB.ROLE`(USER/ADMIN)을 추가하고, 기존 `admin` 계정은 ADMIN으로 옮겼다.
어드민 프로젝트도 같은 역할을 사용한다.

## URL 규칙 요약

| 구분 | 경로 |
|---|---|
| 공개 (GET) | 메인, 소모임 목록/상세/FAQ 보기, 커뮤니티 읽기, 고객센터 읽기, 로그인·회원가입·계정 찾기 폼, 업로드 이미지 |
| 공개 (모든 메서드) | 회원가입, 아이디/닉네임 중복 확인, 계정 찾기, 리뷰 목록 Ajax, 네이버 로그인(보류 중인 레거시) |
| ADMIN | 공지/FAQ 작성·수정·삭제, 전체 문의 내역, 문의 답변 |
| 로그인 필요 | 그 외 전부 |
| 로그인 + 비밀번호 재확인(10분) | 회원정보 수정, 비밀번호 변경, 탈퇴 |

소모임 단위의 권한(모임장만 승인·추방·수정·삭제)은 기존 `GroupManagingController`의 소유자 검사를 유지한다.
Phase 2에서 서비스 계층으로 옮긴다.

## 함께 고친 것

- `NotDeleteException`이 가리키던 `error/info.jsp`가 없어서 경고 대신 에러가 나던 문제. 화면을 만들고 403에서도 같이 사용한다.
- 비밀번호 변경과 탈퇴 후 Security 인증까지 확실히 끊도록 `request.logout()` 호출.

## 테스트

| 테스트 | 검증 |
|---|---|
| `LoginTest` | 로그인 성공 시 세션 브리지, 실패, 없는 아이디, open redirect 차단, DB 역할 반영, 로그아웃 |
| `AccessRulesTest` | 공개 페이지, 로그인 폼으로 이동(원래 주소 유지), 상태 변경 요청의 로그인 필요, ADMIN 전용과 `/` 우회 차단 |
| `PasswordReauthTest` | `?isSuccess=true` 우회 차단, 실제 변경 요청에도 재확인 적용, 틀린/맞는 비밀번호 |
| `GroupDeleteSecurityTest` | Phase 0의 KNOWN_BUG를 뒤집음. 비로그인은 로그인 폼, 로그인 사용자는 404, 모임은 그대로 |

## 1-2 CSRF

### 방식

| 항목 | 결정 |
|---|---|
| 토큰 저장 | `CookieCsrfTokenRepository.withHttpOnlyFalse()`. 토큰을 `XSRF-TOKEN` 쿠키로 내려준다 |
| 화면 적용 | `resources/js/csrf.js` 하나를 모든 페이지 `<head>`(86개)에서 로드한다. 기존 화면 코드는 거의 고치지 않는다 |
| Ajax | `XMLHttpRequest`(jQuery)와 `fetch`(gura_util.js)를 감싸서 같은 사이트 POST 요청에 `X-XSRF-TOKEN` 헤더를 붙인다 |
| 폼 | `method="post"` 폼에 `_csrf` hidden input을 넣는다. Ajax로 나중에 그려지는 폼은 MutationObserver로 처리한다. `form.submit()`처럼 submit 이벤트가 없는 제출도 동작한다 |
| 상태 변경 링크 | `<a data-post href>` 또는 `postTo(url)`로 POST 전송. `onclick="return confirm()"`에서 취소하면 보내지 않는다 |
| 실패 화면 | CSRF 실패(오래 열어둔 페이지 등)는 "권한 없음"이 아니라 "새로고침 후 다시 시도" 안내 |

모든 화면 코드에 `<sec:csrfInput/>`을 넣는 방법도 있지만, 폼 38개와 Ajax 54곳을 하나씩 고쳐야 하고 빠뜨리기 쉽다.
이 방식은 공통 스크립트 하나와 `<head>` 한 줄로 끝나고, 나중에 화면을 새로 만들어도 따로 신경 쓸 필요가 없다.

### 겪은 문제: 토큰 쿠키가 내려가지 않음

Spring Security 5.x는 토큰 저장소를 `LazyCsrfTokenRepository`로 감싸서, 서버 코드가 토큰을 읽을 때만 쿠키를 굽는다.
JSP는 토큰을 직접 읽지 않으니 쿠키가 아예 생기지 않았고, 이대로였다면 브라우저의 모든 POST가 403이 됐을 것이다.
`CsrfCookieFilter`가 CSRF 필터 바로 뒤에서 토큰을 한 번 읽어 쿠키가 항상 내려가게 했다.

MockMvc의 `csrf()`는 토큰 저장소를 테스트용으로 바꿔 끼우기 때문에 이 문제를 잡지 못한다.
쿠키 왕복은 실제 HTTP 서버를 띄우는 `CsrfCookieHttpTest`로 검증한다.

### GET에서 POST로 바꾼 엔드포인트 (19개)

| 영역 | 엔드포인트 |
|---|---|
| 회원 | 로그아웃, 탈퇴 |
| 소모임 | FAQ 삭제, 답변 삭제, 리뷰 삭제, 리뷰 작성/수정, 찜, 가입 신청 취소 |
| 소모임 관리 | 가입 승인, 거절, 추방, 탈퇴, 모임 삭제 |
| 커뮤니티 | 글 삭제 |
| 고객센터 | 공지 삭제, FAQ 삭제, 문의 삭제 |
| 책 목록 | 책 삭제 |

회원 탈퇴는 비밀번호 재확인 후 `pwd_auth.jsp`가 `postTo()`로 POST를 보낸다. 이 화면이 받는 `url`도 로그인과 같은 규칙으로 검증한다.

### 검증

- `CsrfTest`(MockMvc): 토큰 없음/위조 토큰 거부, GET 로그아웃 무효, 상태 변경 엔드포인트의 GET 거부(405)
- `CsrfCookieHttpTest`(실제 서버): 쿠키 발급과 HttpOnly 아님, 헤더 방식과 파라미터 방식 통과, 쿠키와 다른 토큰 거부
- headless Chrome 수동 검증: 로그인 폼 hidden input, 폼 제출 로그인, jQuery/fetch/XHR POST, 동적 폼, `data-post` 로그아웃. multipart 폼의 `_csrf`는 curl로 확인

## 남은 것

- 네이버 로그인(`/users/socialaccess`)은 세션에 `id`만 넣어서 Security 인증이 되지 않는다. 기능 자체를 다시 설계할 때 OAuth2 Client로 교체한다.
- ~~`UsersServiceImpl`이 `new BCryptPasswordEncoder()`를 직접 생성~~ → `PasswordEncoder` 빈 주입으로 교체 완료(2026-11-14). `isSamePwd`의 `BCrypt.checkpw`도 `matches`로 바꿔, 해시가 아닌 값(소셜 회원의 빈 비밀번호)이 오면 예외 대신 `false`를 돌려준다.
- **리소스 단위 권한 누락**: `/test/bookUpdate`, `/test/bookDelete`(모임 책 목록 수정)에 모임장 검사가 없어서 로그인한 사용자 누구나 다른 모임의 책 목록을 바꿀 수 있다. Phase 2에서 소유자 검사를 서비스 계층으로 모을 때 함께 처리한다.
- `test/test.jsp`는 EUC-KR 인코딩의 테스트 페이지라 csrf.js 적용에서 뺐다(폼 없음). Phase 2에서 `test/` 화면 정리 시 삭제 검토.
