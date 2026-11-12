# Phase 0 — 스키마 기준 복원과 안전망

## 왜 했나

- `Soso/src/main/webapp/WEB-INF/table.sql`과 ERD가 실제 운영 DB, 그리고 매퍼 SQL과 서로 달랐다.
  그래서 "지금 코드가 어떤 스키마를 기대하는가"를 알 수 있는 기준이 없었다.
- 커밋 `8c6aa15`(기본 DB 매핑 수정)에서 테이블명을 `*_TB`로, `writer`를 `USER_ID`로,
  가입 테이블의 `num`을 `GROUP_NUM`으로 일괄 치환했다. 이때 바꾸면 안 되는 곳까지 같이 바뀌어
  일부 화면의 SQL이 실행되지 않았다.
- 테스트는 기본 생성된 `contextLoads` 하나뿐이었고, CI는 `-DskipTests`로 빌드하고 있었다.

## 결정

| 항목 | 결정 |
|---|---|
| 스키마 기준 | **현재 매퍼 SQL**을 기준으로 역설계해서 `db/migration/V1__baseline_schema.sql`을 만든다 |
| V1 범위 | 레거시가 기대하는 구조를 그대로 재현한다. FK, UNIQUE 같은 무결성 제약은 원본에도 없었으므로 넣지 않고 V2 이후로 미룬다 |
| 기존 DB | `spring.flyway.baseline-on-migrate=true`, `baseline-version=1`. 이미 테이블이 있는 DB에서는 V1을 실행하지 않고 기준점만 기록한다 |
| DB 종류 | Oracle 유지. 로컬과 테스트 모두 `gvenzl/oracle-xe:21-slim-faststart` |
| 시크릿 | DB 계정, 네이버 API 키를 코드와 properties에서 빼고 환경변수로 받는다 (`.env.example` 참고) |

## 매퍼 수정 내역 (잘못된 일괄 치환 되돌리기)

| 매퍼 | 문제 | 수정 |
|---|---|---|
| `JoinMapper` | PK 컬럼 `NUM` 자리에 `GROUP_NUM`이 들어가 INSERT 컬럼이 중복됨 | `NUM`으로 복원 |
| `GroupManagingMapper` | 가입 신청 행 번호(`num`) 조건과 정렬이 `group_num`으로 바뀜 | `num`으로 복원 |
| `GroupMapper.update` | 존재하지 않는 `title` 컬럼 | `name` |
| `GroupReviewMapper` | 예전 컬럼 `title`, `review`, `ref_group` 사용 | `review_num`, `content`, `group_num` |
| `UsersMapper` | `user_id`를 그대로 조회해서 `UsersDto.id`가 항상 null | `user_id AS id` |
| `UsersInfoMapper`, `CafeCommentMapper`, `GroupMemberInfoMapper` | `CS_TB.writer`까지 `USER_ID`로 바뀌었고, DTO의 `writer`와 매핑이 끊김 | `writer` 복원, 별칭 `AS writer` 추가 |

함께 고친 코드: `GroupServiceImpl.moreReview`에서 리뷰 목록 조회용 모임 번호를 넘기던 줄이
주석 처리되어 있어 "리뷰 더보기"가 항상 비어 있었다. `setGroup_num(num)`으로 되살렸다.

## 특성 테스트(characterization test)

리팩토링 전에 **현재 동작**을 고정해 두는 테스트다. 실제 Oracle 컨테이너에 Flyway를 적용한 뒤 실행한다.

| 테스트 | 고정하는 동작 |
|---|---|
| `SosoApplicationTests` | 컨텍스트가 뜨고 Flyway V1이 적용된다 |
| `UsersDaoTest` | 회원가입 후 아이디 중복 체크와 조회 |
| `GroupJoinFlowTest` | 모임장 자동 가입, 가입 신청(대기), 중복 신청 차단, 승인 후 회원 목록과 `now_people` 반영 |
| `GroupDeleteSecurityTest` | **알려진 결함**: 비로그인 `GET /group/delete?num=N`이 남의 모임을 삭제한다. Phase 1에서 기대값을 "거부"로 뒤집는다 |

테스트하면서 확인한 레거시 동작:
- 가입 상태 `ISJOIN`: 0 승인, 1 대기, 2 거절, 3 탈퇴, 4 추방. 이력이 없으면 DAO가 NPE를 잡아서 -1을 돌려준다.
- `group.getData`는 `now_people`을 조회하지 않는다.
- `/group/list`는 `genre` 파라미터가 없으면 500(`NumberFormatException`)이 난다.

## 로컬 실행

```bash
docker compose up -d                       # Oracle XE (최초 1~2분)
cd Soso
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
./mvnw test                                # Testcontainers가 별도 Oracle을 띄운다
```

## 남은 일 (다음 Phase로)

- 이력에 남아 있는 DB 비밀번호와 네이버 Client Secret 교체(아래 "운영 반영 전 체크" 참고)
- V2: `GROUP_JOIN_TB (GROUP_NUM, USER_ID)` UNIQUE, FK 추가, 가입 상태 enum화
- CI에서 테스트 실행 (`-DskipTests` 제거)
- Flyway 8.5(Boot 2.7 기본)는 Oracle 21을 공식 지원하지 않는다는 경고를 낸다. Phase 3에서 Boot 3.x로 올리면 해결된다

## 운영 반영 전 체크

`application-real.properties`는 이제 `DB_USERNAME`, `DB_PASSWORD` 환경변수가 필요하다.
master에 머지하기 전에 운영 서버에 환경변수(또는 `~/config/application-real.properties`)를 준비해야 배포가 깨지지 않는다.
네이버 로그인/검색도 `NAVER_*` 환경변수가 없으면 동작하지 않는다.

배포 스크립트(`.github/workflows/deplow.yml`)는 기동 직전에 서버의 `~/app/bookmate.env`를 읽는다.
서버에 아래 형식으로 만들어 두고 `chmod 600`으로 권한을 제한한다.

```
DB_USERNAME=...
DB_PASSWORD=...
```
