-- =====================================================================
-- V3: FAQ 분류(CATEGORY)를 숫자 컬럼으로
--
-- 문제: CATEGORY 가 VARCHAR2 인데 카테고리별 개수 쿼리는 숫자(0~3)로 비교한다.
--       등록 폼의 기본 옵션 "분류"에 value 가 없어서 분류를 고르지 않으면 '분류' 라는 글자가 저장되고,
--       그 뒤로는 Oracle 이 모든 행을 숫자로 바꾸다 실패해(ORA-01722) FAQ 화면 전체가 500 이 됐다.
-- 조치: 숫자 컬럼 + 0~3 CHECK 제약. 숫자가 아닌 기존 값은 기타(0)로 옮긴다.
--       (분류: 0 기타, 1 회원, 2 모임신청, 3 모임개설)
-- =====================================================================
ALTER TABLE FAQ_TB ADD (CATEGORY_NUM NUMBER(1));

UPDATE FAQ_TB
   SET CATEGORY_NUM = CASE WHEN TRIM(CATEGORY) IN ('0', '1', '2', '3') THEN TO_NUMBER(TRIM(CATEGORY)) ELSE 0 END;

ALTER TABLE FAQ_TB DROP COLUMN CATEGORY;

ALTER TABLE FAQ_TB RENAME COLUMN CATEGORY_NUM TO CATEGORY;

ALTER TABLE FAQ_TB MODIFY (CATEGORY DEFAULT 0 NOT NULL);

ALTER TABLE FAQ_TB ADD CONSTRAINT CK_FAQ_TB_CATEGORY CHECK (CATEGORY IN (0, 1, 2, 3));

COMMENT ON COLUMN FAQ_TB.CATEGORY IS '0: 기타, 1: 회원, 2: 모임신청, 3: 모임개설';
