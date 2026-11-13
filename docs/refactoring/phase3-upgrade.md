# Phase 3 — 플랫폼 업그레이드 (Spring Boot 2.7 → 3.5 → 4.1)

Spring 공식 권장 경로대로 두 단계로 나눈다. 단계마다 테스트와 배포까지 확인한다.

| 단계 | 대상 | 상태 |
|---|---|---|
| 3-1 | Spring Boot **3.5.16**, Java **21**, Jakarta EE 10 (javax → jakarta) | 완료 |
| 3-2 | Spring Boot **4.1.x**, Spring Framework 7, Security 7, Jackson 3 | 예정 |

## 왜

- Spring Boot 2.7은 2023년 11월에 오픈소스 지원이 끝났고, 이 프로젝트는 그중에서도 **SNAPSHOT** 버전을 쓰고 있었다.
- 내장 Tomcat 9, Spring 5.3, Security 5.7 모두 이후 보안 패치를 받지 못한다.
- 관리가 끝난 라이브러리(`log4jdbc-log4j2` 2014년, `json-simple` 2012년)와 알려진 취약점이 있는 라이브러리(`commons-io 2.4`, CVE-2021-29425)가 섞여 있었다.

## 3-1 변경 내용

### 의존성

| 항목 | 이전 | 이후 |
|---|---|---|
| Spring Boot | 2.7.8-SNAPSHOT | 3.5.16 |
| Java | 11 | 21 (Temurin) |
| 내장 Tomcat | 9 | 10.1 |
| MyBatis starter | 2.3.1 | 3.0.5 |
| Oracle JDBC | ojdbc8 | ojdbc11 |
| JSTL | `javax.servlet:jstl` | Jakarta JSTL API + Glassfish 구현 |
| Flyway | 8.5 | Boot 관리 버전 + `flyway-database-oracle` (Flyway 10부터 DB별 모듈 분리) |
| commons-io | 2.4 | 2.22.0 |
| log4jdbc-log4j2 | 1.16 | **제거** (Oracle 기본 드라이버 사용) |
| json-simple | 1.1.1 | **제거** (Jackson 으로 대체) |
| Spring 스냅샷/마일스톤 저장소 | 사용 | 제거 |

### 코드

- `javax.servlet` → `jakarta.servlet` (38개 파일)
- `NaverController`: json-simple 대신 Jackson `JsonNode`, 쓰지 않던 `javax.swing.JOptionPane` import 제거
- `SecurityConfig`
  - `mvcMatchers`/`antMatchers` → `requestMatchers`
  - **FORWARD/INCLUDE/ERROR 디스패치 허용**: Security 6부터 컨트롤러가 JSP 로 forward 하는 내부 요청도 인가 대상이 된다.
    허용하지 않으면 비로그인 사용자가 공개 페이지를 열어도 JSP forward 단계에서 막힌다.
  - **CSRF 토큰 처리기를 `CsrfTokenRequestAttributeHandler`로 지정**: Security 6 기본값은 토큰을 XOR 마스킹해서 비교한다.
    `csrf.js`는 쿠키 값을 그대로 보내므로 기본값이면 모든 POST 가 403 이 된다.
- 운영/로컬 프로필의 datasource 를 log4jdbc 에서 `oracle.jdbc.OracleDriver`로 변경. 로그에 SQL 결과 행이 모두 찍히던 문제(운영 로그 28MB)도 같이 해결.

### 동작 변화

- Spring 6 부터 주소 끝 `/`는 MVC 핸들러와 매칭되지 않는다(trailing slash matching 기본 해제).
  `/support/support_inquire_inquireStatus/` 같은 우회 시도는 이제 403 이 아니라 404 가 된다. `AccessRulesTest` 기대값 수정.

### 검증

| 검증 | 결과 |
|---|---|
| 단위/통합 테스트 | 32개 통과 (기대값 1개 수정: 위 trailing slash) |
| JSP 렌더링 | 실제 앱을 띄워 비로그인 16개, 로그인 16개 화면 확인. Jasper(JSP 컴파일) 오류 0건. 옛 JSTL URI(`http://java.sun.com/jsp/jstl/*`, 94개 JSP)가 Jakarta JSTL 3.0 에서 그대로 동작함 |
| 브라우저(headless Chrome) | 로그인 폼 토큰, 폼 제출 로그인, jQuery/fetch/XHR POST, 동적 폼, `data-post` 로그아웃 통과. multipart `_csrf`는 curl 로 확인(Tomcat 10.1) |

### 발견한 기존 버그 (업그레이드와 무관)

- `support_faq_menuBar.jsp`의 카테고리 링크에 `category` 파라미터가 없어 클릭하면 500(Oracle 이 타입 없는 null 거부).
  다만 이 파일은 어디에서도 include 되지 않는 미사용 조각이라 실제 화면 영향은 없다. Phase 2 정리 대상.

### 배포 전제

- 서버 Java 를 21 로 올려야 한다(서버는 Java 11). Ubuntu 20.04 기본 저장소에는 21 이 없어 Adoptium(Temurin) 저장소를 사용한다.
- GitHub Actions `setup-java` 를 21 로 변경.

## 운영 장애: FAQ 등록 후 FAQ 화면 전체 500 (2026-11-12, 3-1 배포 직후)

**증상**: 관리자가 FAQ 를 등록한 뒤 고객센터 FAQ 화면이 모두 500.

**원인**: 업그레이드와 무관한 기존 결함이 V1 스키마에서 드러났다.
1. 등록 폼의 기본 옵션 `<option selected>분류</option>`에 `value`가 없어서, 분류를 고르지 않으면 글자 `'분류'`가 그대로 전송됐다.
2. V1 은 `FAQ_TB.CATEGORY`를 VARCHAR2 로 만들었기 때문에 저장은 성공했다.
3. 카테고리별 개수 쿼리 `WHERE category = ?`(숫자 바인딩)에서 Oracle 이 모든 행을 숫자로 변환하다 `'분류'`에서 실패했다(ORA-01722).
   이 행이 남아 있는 동안 FAQ 화면은 계속 500 이었다.

로컬 재현이 처음에 안 된 이유: 테스트 등록 때 `category=1`을 직접 넣었기 때문. 운영 로그의 ORA-01722 로 원인을 특정했다.

**조치**
| 위치 | 내용 |
|---|---|
| Flyway `V3__faq_category_number.sql` | `CATEGORY`를 NUMBER(1) + `CHECK (0~3)`. 숫자가 아닌 기존 값은 기타(0)로 이관 |
| `FaqServiceImpl` | 등록/수정 시 분류가 0~3 이 아니면 `InvalidRequestException`(400, 경고 화면) |
| `support_faq_insertform.jsp` | 기본 옵션 `value="" disabled`, `select required` |
| `FaqCategoryTest` | 분류 누락/잘못된 값 거부, DB 제약, 정상 등록 후 개수·목록 |

V3 는 운영과 같은 상황(`'분류'` 행이 있는 V2 DB)을 로컬에 만들어 적용해 보고, 행이 0 으로 바뀌고 FAQ 화면이 200 으로 돌아오는 것을 확인했다.

**같이 발견한 것**: FAQ 수정 화면(`support_faq_updateform.jsp`) 파일이 없다. FAQ 수정 기능은 원래부터 동작하지 않는다. Phase 2 에서 처리.

## 운영 결함: 리다이렉트 Location 이 http:// 로 나감 (2026-11-13)

**증상**: `https://bookmate.p-e.kr/` 응답이 `302 Location: http://bookmate.p-e.kr/main`. nginx 가 다시 https 로 301 을 보내서
화면은 열리지만, 모든 리다이렉트(로그인 화면 이동, 로그인 후 복귀 포함)가 http 를 한 번 거친다.

처음에는 "`/`가 로그인 화면으로 간다"고 판단했으나 잘못 본 것이다. 리다이렉트를 따라가면 `/main`(200)에 정상 도착한다.

**원인**: nginx 가 https 로 받아 앱(127.0.0.1:9000)에는 http 로 넘긴다. 앱은 원래 scheme 을 모르기 때문에 Tomcat 이
`sendRedirect`를 절대 주소(`http://...`)로 만든다.

**1차 조치(효과 없음)**: `server.tomcat.use-relative-redirects=true`. 로컬 테스트는 통과했지만 운영은 그대로였다.
서버에서 `curl -sI http://127.0.0.1:9000/`로 앱 응답을 직접 보면 상대 경로가 나왔다. 그런데 nginx 를 거치면 절대 주소였다.
nginx 설정에는 `proxy_redirect`가 없다. 실제 원인은 Tomcat 이었다. `Request.getSupportsRelativeRedirects()`는
HTTP/1.0 요청이면 `false`를 돌려주고, nginx 는 `proxy_http_version` 기본값이 1.0 이다. 로컬 테스트는 HTTP/1.1 이라 이 차이를 못 잡았다.

**최종 조치**: nginx 가 이미 `X-Forwarded-Proto $scheme`, `X-Forwarded-For`, `Host`를 보내므로 앱이 이 헤더를 읽게 했다.
| 위치 | 내용 |
|---|---|
| `application.properties` | `server.forward-headers-strategy=native`(Tomcat `RemoteIpValve`, 127.0.0.1 등 내부 프록시만 신뢰). 절대 주소도 `https://`로 만든다. `use-relative-redirects`는 HTTP/1.1 직접 요청용으로 유지 |
| `HomeController` | `redirect:main` → `redirect:/main`. 상대 리다이렉트에서는 값이 그대로 나가므로 현재 경로와 무관하게 고정 |
| `RedirectLocationHttpTest` | 실제 서버 대상. HTTP/1.1 이면 상대 경로, nginx 와 같은 HTTP/1.0 + `X-Forwarded-Proto: https` 요청이면 `https://` 절대 주소. 설정을 끄면 운영과 같은 `http://`가 나와 실패하는 것을 확인 |

**참고**
- nginx 에 `proxy_http_version 1.1;`을 추가하면 상대 경로로 나간다. 앱 설정만으로 해결되어 nginx 는 바꾸지 않았다.
- `curl -I`(HEAD) `/`는 로그인 화면으로 간다. `PUBLIC_PAGES`가 GET 만 허용하기 때문이며 브라우저(GET)는 영향이 없다.
  처음에 "`/`가 로그인 화면으로 간다"고 본 것도 이 때문으로 보인다. 공개 화면에 HEAD 를 허용할지는 별도 판단.

## 3-2 예정 (Boot 4.1)

- `spring-boot-starter-web` → `spring-boot-starter-webmvc` 등 모듈화된 스타터
- Jackson 3 (`tools.jackson` 패키지) 전환
- Security 7, Testcontainers 2.0, MyBatis starter 4.1.0
- 테스트 어노테이션 패키지 이동(`@AutoConfigureMockMvc`, `TestRestTemplate`)
