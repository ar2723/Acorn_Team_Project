-- =====================================================================
-- V2: 회원 역할(ROLE) 추가
--
-- 기존에는 관리자 여부를 코드에서 id == "admin" 으로 판단했다.
-- 역할을 DB 에 두고 Spring Security 의 권한(ROLE_USER / ROLE_ADMIN)으로 사용한다.
-- =====================================================================
ALTER TABLE USERS_TB ADD (ROLE VARCHAR2(20) DEFAULT 'USER' NOT NULL);

ALTER TABLE USERS_TB ADD CONSTRAINT CK_USERS_TB_ROLE CHECK (ROLE IN ('USER', 'ADMIN'));

-- 기존 관리자 계정 이관
UPDATE USERS_TB SET ROLE = 'ADMIN' WHERE USER_ID = 'admin';
