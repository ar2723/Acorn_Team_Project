package com.acorn.soso.security;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrlPattern;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import com.acorn.soso.support.OracleIntegrationTest;
import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

/** 회원정보·비밀번호 수정, 탈퇴 전 비밀번호 재확인 */
@AutoConfigureMockMvc
class PasswordReauthTest extends OracleIntegrationTest {

	@Autowired MockMvc mvc;
	@Autowired UsersDao usersDao;
	@Autowired PasswordEncoder passwordEncoder;

	MockHttpSession session;

	@BeforeEach
	void setUp() {
		usersDao.insert(UsersDto.builder()
				.id("reader").pwd(passwordEncoder.encode("pw1234!")).email("reader@example.com").name("독자")
				.build());
		session = new MockHttpSession();
		session.setAttribute(LegacySession.LOGIN_ID, "reader");
	}

	@Test
	void isSuccessParameterNoLongerBypassesReauth() throws Exception {
		mvc.perform(get("/users/updateform").param("isSuccess", "true").session(session).with(user("reader")))
				.andExpect(redirectedUrlPattern("/users/pwd_authform?url=*"));
	}

	@Test
	void actualChangeRequestsAlsoNeedReauth() throws Exception {
		mvc.perform(post("/users/pwd_update").with(csrf()).param("newPwd", "hacked").session(session).with(user("reader")))
				.andExpect(status().is3xxRedirection());
		mvc.perform(post("/users/delete").with(csrf()).session(session).with(user("reader")))
				.andExpect(status().is3xxRedirection());
	}

	@Test
	void wrongPasswordDoesNotGrantReauth() throws Exception {
		mvc.perform(post("/users/pwd_auth").with(csrf()).param("pwd", "wrong").param("url", "/users/updateform")
				.session(session).with(user("reader")));

		mvc.perform(get("/users/updateform").session(session).with(user("reader")))
				.andExpect(status().is3xxRedirection());
	}

	@Test
	void correctPasswordGrantsReauth() throws Exception {
		mvc.perform(post("/users/pwd_auth").with(csrf()).param("pwd", "pw1234!").param("url", "/users/updateform")
				.session(session).with(user("reader")));

		mvc.perform(get("/users/updateform").session(session).with(user("reader")))
				.andExpect(status().isOk())
				.andExpect(view().name("users/updateform"));
	}
}
