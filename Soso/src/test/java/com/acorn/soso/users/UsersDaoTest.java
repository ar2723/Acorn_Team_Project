package com.acorn.soso.users;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acorn.soso.support.OracleIntegrationTest;
import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

/** 회원가입·조회 특성 테스트 */
class UsersDaoTest extends OracleIntegrationTest {

	@Autowired
	UsersDao usersDao;

	@Test
	void signUpThenFindById() {
		usersDao.insert(UsersDto.builder()
				.id("reader1").pwd("encoded-pwd").email("reader1@example.com").name("독자1").social(0)
				.build());

		assertThat(usersDao.isExist("reader1")).isEqualTo(1);
		assertThat(usersDao.isExist("nobody")).isZero();

		UsersDto found = usersDao.getData("reader1");
		assertThat(found.getId()).isEqualTo("reader1");
		assertThat(found.getEmail()).isEqualTo("reader1@example.com");
		assertThat(found.getPwd()).isEqualTo("encoded-pwd");
	}
}
