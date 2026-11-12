# Phase 1 — Spring Security 도입과 권한

Phase 1은 두 단계로 나눈다.

| 단계 | 내용 | 상태 |
|---|---|---|
| 1-1 | Security 로그인, 역할(ROLE), URL 인가, 비밀번호 재확인 우회 수정, 열려 있던 엔드포인트 제거 | 완료 |
| 1-2 | 공통 include와 Ajax 유틸에 CSRF 토큰 적용, 상태 변경 GET 요청을 POST로 전환, CSRF 활성화 | 예정 |

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

## 남은 것

- 1-2: CSRF. 지금은 `csrf.disable()` 상태이고, 로그아웃과 여러 삭제 요청이 GET이다.
- 네이버 로그인(`/users/socialaccess`)은 세션에 `id`만 넣어서 Security 인증이 되지 않는다. 기능 자체를 다시 설계할 때 OAuth2 Client로 교체한다.
- `UsersServiceImpl`이 아직 `new BCryptPasswordEncoder()`를 직접 생성한다. Phase 2에서 `PasswordEncoder` 빈으로 바꾼다.
