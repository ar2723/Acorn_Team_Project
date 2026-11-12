-- =====================================================================
-- V1: Baseline schema
--
-- 기존 table.sql 은 실제 매퍼와 테이블/컬럼명이 달라 사용할 수 없었기 때문에,
-- src/main/resources/mapper/**/*.xml 에서 사용하는 SQL 을 기준으로 역설계했다.
-- (복원 근거와 결정 사항은 docs/refactoring/phase0-schema.md 참고)
--
-- 원칙: V1 은 "레거시가 기대하는 구조"를 그대로 재현한다.
--   - FK / UNIQUE 등 무결성 제약은 원본에도 없었으므로 V1 에서는 추가하지 않는다.
--   - 개선 사항은 V2 이후 마이그레이션으로 분리한다.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 회원
-- ---------------------------------------------------------------------
CREATE TABLE USERS_TB (
    USER_ID                VARCHAR2(100) NOT NULL,
    PWD                    VARCHAR2(100) NOT NULL,
    EMAIL                  VARCHAR2(100),
    PROFILE                VARCHAR2(300),
    REGDATE                DATE,
    NAME                   VARCHAR2(50),
    SVC_USE_PCY_AGMT_YN    NUMBER(1) DEFAULT 0,
    PS_INFO_PROC_AGMT_YN   NUMBER(1) DEFAULT 0,
    MKT_INFO_RECV_AGMT_YN  NUMBER(1) DEFAULT 0,
    SOCIAL                 NUMBER(1) DEFAULT 0,
    CONSTRAINT PK_USERS_TB PRIMARY KEY (USER_ID)
);
COMMENT ON COLUMN USERS_TB.SOCIAL IS '0: 일반 가입, 1: 네이버 연동';

-- ---------------------------------------------------------------------
-- 소모임
-- ---------------------------------------------------------------------
CREATE TABLE GROUP_TB (
    NUM              NUMBER        NOT NULL,
    NAME             VARCHAR2(100),
    CAPTION          VARCHAR2(2000),
    IMG_PATH         VARCHAR2(300),
    REGDATE          DATE,
    ENDED_DT         DATE,
    DEADLINE_DT      DATE,
    START_DT         DATE,
    MANAGER_ID       VARCHAR2(100),
    MAX_PEOPLE       NUMBER,
    NOW_PEOPLE       NUMBER        DEFAULT 0,
    AVRG_RATE        NUMBER(3, 2)  DEFAULT 0,
    MEETING_LOC      VARCHAR2(200),
    MEETING_TIME     VARCHAR2(100),
    GENRE            NUMBER,
    ON_OFF           NUMBER(1),
    MANAGER_COMMENT  VARCHAR2(2000),
    VIEWCOUNT        NUMBER        DEFAULT 0,
    CONSTRAINT PK_GROUP_TB PRIMARY KEY (NUM)
);
CREATE SEQUENCE GROUP_SEQ;

-- 소모임 가입 신청/회원
CREATE TABLE GROUP_JOIN_TB (
    NUM         NUMBER        NOT NULL,
    GROUP_NUM   NUMBER,
    USER_ID     VARCHAR2(100),
    INTRO       VARCHAR2(1000),
    ISJOIN      NUMBER        NOT NULL,
    REQUEST_DT  DATE,
    JOIN_DT     DATE,
    KICK_DT     DATE,
    CONSTRAINT PK_GROUP_JOIN_TB PRIMARY KEY (NUM)
);
COMMENT ON COLUMN GROUP_JOIN_TB.ISJOIN IS '0: 승인(회원), 1: 대기, 2: 거절, 3: 탈퇴, 4: 추방';
CREATE SEQUENCE JOIN_SEQ;

-- 소모임 찜(북마크)
CREATE TABLE USER_BOOKMARK_TB (
    GROUP_NUM  NUMBER,
    USER_ID    VARCHAR2(100)
);

-- 소모임 리뷰
CREATE TABLE GROUP_REVIEW_TB (
    REVIEW_NUM  NUMBER         NOT NULL,
    GROUP_NUM   NUMBER,
    WRITER      VARCHAR2(100),
    CONTENT     VARCHAR2(2000),
    RATE        NUMBER,
    REGDATE     DATE,
    CONSTRAINT PK_GROUP_REVIEW_TB PRIMARY KEY (REVIEW_NUM),
    CONSTRAINT CK_GROUP_REVIEW_RATE CHECK (RATE BETWEEN 0 AND 5)
);
CREATE SEQUENCE REVIEW_SEQ;

-- 소모임 문의(Q&A)
CREATE TABLE GROUP_FAQ_TB (
    Q_NUM      NUMBER         NOT NULL,
    GROUP_NUM  NUMBER,
    Q_WRITER   VARCHAR2(100),
    Q_TITLE    VARCHAR2(200),
    Q_CONTENT  VARCHAR2(2000),
    Q_REGDATE  DATE,
    A_WRITER   VARCHAR2(100),
    A_ANSWER   CLOB,
    A_REGDATE  DATE,
    CONSTRAINT PK_GROUP_FAQ_TB PRIMARY KEY (Q_NUM)
);
CREATE SEQUENCE GROUP_FAQ_SEQ;

-- 소모임에서 함께 읽을 책 (네이버 책 검색 결과 저장)
CREATE TABLE BOOK_TB (
    GROUP_NUM    NUMBER,
    TITLE        VARCHAR2(500),
    LINK         VARCHAR2(500),
    IMAGE        VARCHAR2(500),
    ISBN         VARCHAR2(100),
    DESCRIPTION  CLOB
);

-- ---------------------------------------------------------------------
-- 소모임 커뮤니티 게시판
-- ---------------------------------------------------------------------
CREATE TABLE COMMUNITY_BOARD_TB (
    COMU_NUM   NUMBER         NOT NULL,
    GROUP_NUM  NUMBER,
    WRITER     VARCHAR2(100),
    TITLE      VARCHAR2(300),
    HEADER     NUMBER,
    CONTENT    CLOB,
    VIEWCOUNT  NUMBER         DEFAULT 0,
    REGDATE    DATE,
    CONSTRAINT PK_COMMUNITY_BOARD_TB PRIMARY KEY (COMU_NUM)
);
CREATE SEQUENCE COMU_SEQ;

CREATE TABLE COMU_COMMENT_TB (
    COMMENT_NUM    NUMBER         NOT NULL,
    COMU_NUM       NUMBER,
    USER_ID        VARCHAR2(100),
    CONTENT        VARCHAR2(1000),
    TARGET_ID      VARCHAR2(100),
    COMMENT_GROUP  NUMBER,
    DELETED        NUMBER(1)      DEFAULT 0,
    REGDATE        DATE,
    CONSTRAINT PK_COMU_COMMENT_TB PRIMARY KEY (COMMENT_NUM)
);
COMMENT ON COLUMN COMU_COMMENT_TB.DELETED IS '0: 정상, 1: 삭제됨';
-- 시퀀스명의 오타(COMENT)는 매퍼와 맞추기 위해 그대로 둔다.
CREATE SEQUENCE COMU_COMENT_SEQ;

-- ---------------------------------------------------------------------
-- 고객센터
-- ---------------------------------------------------------------------
CREATE TABLE NOTICE_TB (
    NOTICE_NUM  NUMBER         NOT NULL,
    CATEGORY    VARCHAR2(50),
    TITLE       VARCHAR2(300),
    CONTENT     CLOB,
    REGDATE     DATE,
    CONSTRAINT PK_NOTICE_TB PRIMARY KEY (NOTICE_NUM)
);
CREATE SEQUENCE NOTICE_SEQ;

CREATE TABLE FAQ_TB (
    FAQ_NUM   NUMBER         NOT NULL,
    CATEGORY  VARCHAR2(50),
    QUESTION  VARCHAR2(1000),
    ANSWER    CLOB,
    CONSTRAINT PK_FAQ_TB PRIMARY KEY (FAQ_NUM)
);
CREATE SEQUENCE FAQ_SEQ;

-- 1:1 문의
CREATE TABLE CS_TB (
    CS_NUM      NUMBER         NOT NULL,
    WRITER      VARCHAR2(100),
    CATEGORY    VARCHAR2(50),
    TITLE       VARCHAR2(300),
    CONTENT     CLOB,
    CONFIRM     NUMBER(1)      DEFAULT 0,
    USER_EMAIL  VARCHAR2(100),
    ANSWER      CLOB,
    REGDATE     DATE,
    CONSTRAINT PK_CS_TB PRIMARY KEY (CS_NUM)
);
CREATE SEQUENCE CS_SEQ;
