# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 소통 언어

사용자와의 모든 소통(답변, 설명, 질문, 진행 상황 안내, 커밋 메시지, PR 설명, 문서)은 **한글**로 작성한다. 코드 식별자, 명령어, 에러 원문은 그대로 둔다.

## 프로젝트

북메이트(Bookmate): 독서 소모임 웹 서비스. 2023년 부트캠프 팀 프로젝트였던 레거시를 포트폴리오용으로 단계별 현대화하는 중이다.
결정 기록과 단계별 상태는 `docs/refactoring/phase*.md`에 있다. 새 단계를 진행하면 같은 형식(왜 / 결정 / 검증 / 남은 것)으로 기록한다.

- `Soso/`: 메인 앱. Spring Boot 3.5 + Java 21, JSP(war 패키징), MyBatis, Oracle, Flyway, Spring Security 6
- `Soso_Admin/`: 어드민 앱. 초기 작업 중(사용자가 직접 작업 중인 미커밋 파일이 있음. 요청 없이 건드리거나 커밋에 포함하지 말 것)
- 저장소는 **public**이다. 시크릿은 환경변수로만 받는다(`.env.example` 참고).

## 명령어 (모두 `Soso/`에서 실행)

```bash
docker compose -f ../docker-compose.yml up -d              # 로컬 Oracle XE (최초 1~2분). 스키마는 앱 기동 시 Flyway 가 만든다
./mvnw spring-boot:run -Dspring-boot.run.profiles=local    # http://localhost:9000
./mvnw test                                                # Testcontainers 가 별도 Oracle 컨테이너를 띄움 (Docker 필요)
./mvnw test -Dtest=AccessRulesTest                         # 단일 테스트 클래스
./mvnw test -Dtest=LoginTest#methodName                    # 단일 메서드
./mvnw clean package -DskipTests                           # CI 와 같은 war 빌드
```

로컬 JDK 21은 `~/.jdks/jdk-21.0.13+9`에 있다. 린터는 따로 없다.

## 아키텍처

**레이어**: 기능별 패키지(`group`, `group_managing`, `cafe`, `support`, `users`, `users_info`, `book`) 아래 `controller / service / dao / dto`.
DAO는 `SqlSession`을 주입받아 문자열 ID로 매퍼를 호출한다(`session.selectList("group.getList", dto)`). 이 ID는 `resources/mapper/**.xml`의 `namespace` + `id`이고, 매퍼 인터페이스(@Mapper)는 쓰지 않는다.
컨트롤러는 `WEB-INF/views/**.jsp`로 forward 한다.

**스키마**: 기준은 Flyway 마이그레이션 `resources/db/migration/V*.sql`이다. `WEB-INF/table.sql`과 ERD는 실제와 달라서 참고하지 않는다.
스키마를 바꿀 때는 새 `V{n}__*.sql`을 추가하고, 기존 V 파일은 수정하지 않는다(운영에 이미 적용돼 있음). 테이블은 `*_TB` 형식이고 FK/UNIQUE 제약은 거의 없다.

**보안** (`security/SecurityConfig.java`)
- 기본은 로그인 필요(deny by default). 공개 경로는 `PUBLIC_PAGES`(GET), `PUBLIC_ACTIONS`, 관리자 경로는 `ADMIN_ONLY` 배열에 추가한다.
- 역할은 `USERS_TB.ROLE`(USER/ADMIN)에 저장한다.
- FORWARD/INCLUDE/ERROR 디스패치는 허용해 둔다. 없으면 공개 페이지도 JSP forward 단계에서 막힌다.
- **레거시 세션 브리지** `LegacySession`: 로그인 시 세션에 `id`를 같이 넣는다. 기존 코드 수십 곳이 `session.getAttribute("id")`에 의존하므로 브리지 없이 바꾸면 깨진다.
- 비밀번호 재확인(10분)은 `PwdAuthInterceptor`(`config/WebConfig.java`에서 경로 등록)가 맡는다. 모임 단위 권한(모임장 검사)은 아직 컨트롤러 안에 있다.

**CSRF**: 쿠키 방식(`XSRF-TOKEN`, HttpOnly 아님). 모든 JSP `<head>`에서 `resources/js/csrf.js`를 로드하고, 이 스크립트가 POST 폼과 jQuery/fetch/XHR 요청에 토큰을 자동으로 붙인다.
- 새 JSP에도 `csrf.js`를 로드해야 한다. 상태를 바꾸는 요청은 POST로만 받는다. 링크는 `<a data-post href>` 또는 `postTo(url)`를 쓴다.
- `CsrfTokenRequestAttributeHandler`(XOR 마스킹 끔)와 `CsrfCookieFilter`(쿠키 강제 발급)는 csrf.js 동작에 필수라서 빼면 모든 POST가 403이 된다.

**테스트**: 통합 테스트는 `OracleIntegrationTest`(싱글톤 Oracle 컨테이너 + Flyway + `@Transactional` 롤백)를 상속한다.
MockMvc의 `csrf()`는 실제 쿠키 왕복을 검증하지 못하므로 그 부분은 실제 서버를 띄우는 `CsrfCookieHttpTest`에서 검증한다.

**프로필**: `local`(docker-compose DB), `real`(운영). `away`/`home`은 예전 환경용 잔재다.

## 작업 방식

- 단계마다 테스트 통과와 실제 앱 기동 확인을 거친 뒤 단계별로 커밋한다.
- 알려진 레거시 결함은 바로 고치지 않고, 먼저 테스트로 현재 동작을 고정(characterization test)한 다음 기대값을 뒤집는다.
- 네이버 로그인(`naverLogin`, `/users/socialaccess`)은 Security 인증이 연결되지 않은 보류 레거시다.

## 배포

`master`에 push 하면 `.github/workflows/deplow.yml`이 실행된다. `-DskipTests`로 war를 빌드해 SSH로 서버에 복사하고, 서버의 `~/app/bookmate.env`(DB 계정 등)를 로드한 뒤 `--spring.profiles.active=real`로 `nohup` 실행한다.
운영 앱은 `127.0.0.1:9000`에 바인딩되고 nginx 뒤에 있다. master push는 곧 운영 배포이므로 사용자 확인 없이 하지 않는다.
