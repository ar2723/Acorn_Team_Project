# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트

북메이트(Bookmate): 독서 소모임 웹 앱(2023년 팀 프로젝트). 지금은 단계(Phase)별로 리팩토링하고 있다. Spring Boot 앱은 `Soso/`에 있고, 저장소 루트에는 `docker-compose.yml`, `.env.example`, CI, `docs/refactoring/`만 있다.

**보안, 스키마, 플랫폼 코드를 바꾸기 전에 `docs/refactoring/phase*.md`를 먼저 읽는다.** 지금 구조가 왜 이렇게 되었는지, 알려진 레거시 버그, 다음 단계로 미룬 일(Phase 2: 서비스 계층 정리와 레거시 세션 브리지 제거, Phase 3-2: Boot 4.1)이 정리되어 있다. 문서와 커밋 메시지는 한국어로 쓰고, 커밋 제목은 `Phase N-M: ...` 또는 `fix: ...` 형식을 따른다.

- 저장소는 **public**이다. 시크릿은 환경변수로만 받는다(`.env.example` 참고).
- `Soso_Admin/`(어드민 앱)은 사용자가 로컬에서 작업 중이다. 요청 없이 건드리거나 커밋에 포함하지 않는다.
- 네이버 로그인(`naverLogin`, `/users/socialaccess`)은 Security 인증과 연결되지 않은 보류 레거시다.

## 응답 언어

사용자에게 보이는 글은 모두 한국어로 쓴다. 최종 답변뿐 아니라 작업 중간의 진행 상황 설명, 질문, 오류 보고도 마찬가지다. 코드, 명령어, 파일 경로, 로그 원문, 오류 메시지 원문, 클래스·설정 이름은 번역하지 않고 그대로 쓴다.

## 토큰 절약 지침

**읽기·탐색**
- 위치를 모르면 먼저 Grep/Glob으로 찾고, 파일은 필요한 범위만 읽는다(`offset`/`limit`). 이미 읽은 파일은 다시 읽지 않는다.
- 이 문서와 `docs/refactoring/phase*.md`에 정리된 내용은 코드를 다시 훑어서 확인하지 않는다.
- 서브에이전트는 요청받았을 때만 쓴다.

**명령 실행**
- 긴 출력은 필터해서 본다. Maven은 `Select-String 'Tests run:|FAIL|BUILD'`, 로그는 마지막 몇십 줄만 본다.
- 테스트는 고친 부분의 테스트 클래스만 먼저 돌리고(`-Dtest=...`), 전체 `./mvnw test`는 커밋이나 push 직전에 한 번만 돌린다.
- 같은 명령을 고치지 않은 채 반복 실행하지 않는다. 실패하면 원인을 먼저 본다.

**답변**
- 결론부터 짧게 쓴다. 이미 말한 내용을 다시 요약하지 않고, 하지 않을 선택지는 늘어놓지 않는다.

**환경 정보** (다시 찾지 않도록)
- `mvnw`에 `JAVA_HOME`이 없으면 `~/.jdks`의 JDK 21을 그 명령에만 지정한다. 예: `$env:JAVA_HOME="$HOME\.jdks\ms-21.0.13.0.2"`
- `gh`는 로그인되어 있다. PATH에 없으면 `C:\Program Files\GitHub CLI\gh.exe`로 실행한다. 배포 결과는 `gh run list --limit 5`, 실패 로그는 `gh run view <id> --log-failed`로 본다.

## 사용자와 역할 나누기

사용자는 3년차 주니어 개발자다. 기본 개념은 따로 설명하지 않는다. 판단의 이유와 놓치기 쉬운 부분은 설명한다. 사용자가 더 빠르고 싸게 할 수 있는 일은 직접 탐색하지 말고 정확한 명령이나 확인할 내용을 주고 요청한다.

- **사용자에게 요청할 일**
  - 브라우저 로그인, 승인 같은 대화형 작업
  - 화면이 어떻게 보이는지 확인
  - 운영 서버 확인: SSH로 `~/app/app.log` 일부, nginx 설정 등. 필요한 부분만 붙여 달라고 한다.
  - Docker Desktop, IDE 재시작 같은 로컬 환경 조작
  - 요구사항이나 의도가 모호할 때. 코드를 넓게 뒤지기 전에 짧게 묻는다.
- **직접 하는 일**: 코드 수정, 테스트 실행, git 작업, `gh`와 `curl`을 쓰는 읽기 전용 확인
- **요청하는 방법**: `! <명령>` 형태로 바로 실행할 수 있게 주고, 결과에서 무엇을 보면 되는지 한 줄로 알려준다.

## 명령어

Maven 명령은 모두 `Soso/`에서 실행한다(Windows에서는 `mvnw.cmd`).

```bash
docker compose up -d                                        # (저장소 루트) 로컬 Oracle XE, 포트 1521, 최초 기동 1~2분
./mvnw spring-boot:run -Dspring-boot.run.profiles=local     # 앱 실행, http://localhost:9000
./mvnw test                                                 # 전체 테스트, Docker 필요(Testcontainers)
./mvnw test -Dtest=LoginTest                                # 테스트 클래스 하나
./mvnw test -Dtest=LoginTest#methodName                     # 테스트 메서드 하나
./mvnw clean package -DskipTests                            # target/Soso-*.war 빌드(CI와 동일)
```

Java 21, Spring Boot 3.5.x. 환경변수(`.env.example` 참고): `DB_USERNAME`, `DB_PASSWORD`, `NAVER_*`. `local` 프로필은 DB 계정이 없으면 `bookmate/bookmate`를 쓰고, 업로드 폴더는 `FILE_LOCATION`으로 바꿀 수 있다.

## 구조

- **기술 스택**: Spring MVC + **JSP** 화면(`src/main/webapp/WEB-INF/views`, prefix/suffix는 `application.properties`), XML 매퍼를 쓰는 **MyBatis**, **Oracle**. 실행 가능한 WAR로 패키징한다.
- **기능별 패키지 계층** (`com.acorn.soso.<기능>`: `book`, `cafe`(소모임 커뮤니티), `group`, `group_managing`, `support`(공지/FAQ/문의), `users`, `users_info`): `controller → service(인터페이스 + Impl) → dao(인터페이스 + Impl) → SqlSession`. DAO는 `session.selectList("<namespace>.<id>", dto)` 형태로 호출하고, namespace는 `src/main/resources/mapper/**/*.xml`의 `<mapper namespace>`다. 타입 별칭은 `com.acorn.soso.**`에서 스캔한다(예: `faqDto`). 매퍼 하위 폴더를 새로 만들면 `mybatis.mapper-locations`에 추가해야 한다.
- **스키마**는 Flyway(`src/main/resources/db/migration`)가 관리한다. `V1__baseline_schema.sql`은 매퍼 SQL을 기준으로 역설계한 것이고, 이것이 기준이다. `WEB-INF/table.sql`은 오래된 파일이라 기준이 아니다. 기존 DB는 V1에서 baseline 처리되므로(`baseline-on-migrate`) 스키마 변경은 새 `V{n}__*.sql`로 추가하고, 이미 적용된 마이그레이션은 고치지 않는다. 테이블 이름은 `*_TB`.
- **보안** (`security/SecurityConfig`): 기본은 로그인 필요(deny by default). 공개 GET 화면, 공개 요청, 관리자 전용 URL을 배열(`PUBLIC_PAGES`, `PUBLIC_ACTIONS`, `ADMIN_ONLY`)에 명시한다. 새 공개 화면은 여기에 추가하지 않으면 로그인이 필요하다. 역할은 `USERS_TB.ROLE`(USER/ADMIN)에서 읽는다. 컨트롤러가 JSP로 forward 할 수 있도록 FORWARD/INCLUDE/ERROR 디스패치는 허용한다.
- **레거시 세션 브리지** (`LegacySession`): 레거시 코드는 로그인 사용자를 `session.getAttribute("id")`로 판단한다(Java, JSP 여러 곳). `LoginSuccessHandler`가 Spring Security 인증과 함께 이 값을 세션에 넣는다. Phase 2에서 `@AuthenticationPrincipal`로 바꿀 때까지 동작을 유지해야 한다. 로그인 후 이동할 `url`은 `LegacySession.safeRedirectUrl`을 통과해야 한다.
- **CSRF**: 토큰을 `XSRF-TOKEN` 쿠키로 내려주고(`CsrfCookieFilter`가 항상 굽도록 함), XOR 마스킹 없이 원본 값을 비교한다(`CsrfTokenRequestAttributeHandler`). 모든 페이지 `<head>`에서 로드하는 `resources/js/csrf.js`가 POST 폼, jQuery/XHR, `fetch`에 토큰을 자동으로 붙인다. 상태를 바꾸는 엔드포인트는 모두 POST여야 한다. JSP에서는 일반 링크 대신 `<a data-post href=...>` 또는 `postTo(url)`을 쓴다. 새 페이지도 `csrf.js`를 넣어야 한다. `CsrfCookieFilter`나 `CsrfTokenRequestAttributeHandler`를 빼면 모든 POST가 403이 된다.
- **인터셉터** (`config/WebConfig`): `PwdAuthInterceptor`는 회원정보·비밀번호 수정과 탈퇴에 비밀번호 재확인(10분 유효)을 요구한다. `SupportInterceptor`는 `/support/*`에서 `isAdmin`을 설정한다. 소모임 단위 권한(모임장만 가능한 작업) 검사는 아직 `GroupManagingController`에 있다.
- **업로드 파일**은 `${file.location}`(프로필마다 다름)에 저장한다. 프로필: `local`(docker), `real`(운영, nginx 뒤에서 127.0.0.1에만 바인딩), `home`/`away`(레거시).

## 테스트

통합 테스트는 `support/OracleIntegrationTest`를 상속한다. JVM당 Oracle XE Testcontainer 하나를 띄우고 Flyway를 적용하며, 각 테스트는 `@Transactional`이라 끝나면 롤백된다. MockMvc의 `csrf()`는 토큰 저장소를 테스트용으로 바꿔 끼우기 때문에, 실제 쿠키 왕복은 실제 서버를 띄우는 `CsrfCookieHttpTest`에서만 검증된다. 일부 테스트는 현재 레거시 동작을 일부러 고정하는 특성 테스트다. 기대값을 "고치기" 전에 Phase 문서를 확인한다.

**테스트 전담 에이전트 `test-runner`** (`.claude/agents/test-runner.md`). 테스트 실행은 직접 하지 말고 이 에이전트에 맡긴다.
- 코드 수정을 **커밋한 직후**: `local` 모드로 호출하고 커밋 범위를 넘긴다(예: `local, HEAD~1..HEAD`). 변경 경로에 맞는 테스트만 돌린다.
- master push 직전: `local` 모드 + "push 직전"이라고 알려 전체 테스트를 돌린다.
- master push 직후: `deploy` 모드로 호출해 워크플로 결과와 운영 스모크를 확인한다.
- 문서만 바뀐 커밋은 호출하지 않는다. 에이전트는 코드를 고치지 않으므로, 실패하면 보고를 보고 메인 대화에서 고친다.
- 테스트 매핑 표에 없는 패키지나 테스트를 새로 만들면 에이전트 파일의 표도 같이 갱신한다.

## 배포

`master`에 push 하면 `.github/workflows/deplow.yml`이 실행된다. `-DskipTests`로 WAR를 빌드해 SSH로 서버에 복사하고, 기존 `soso.war`를 백업한 뒤 `~/app/bookmate.env`를 읽고 9000 포트에서 `java -jar soso.war --spring.profiles.active=real`로 기동한다. CI에서 테스트를 돌리지 않으므로 master에 push 하기 전에 로컬에서 `./mvnw test`를 실행한다. master push는 곧 운영 배포이므로 사용자 확인 없이 하지 않는다.
