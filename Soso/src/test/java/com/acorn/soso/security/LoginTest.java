package com.acorn.soso.security;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.authenticated;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.unauthenticated;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import com.acorn.soso.support.OracleIntegrationTest;
import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

@AutoConfigureMockMvc
class LoginTest extends OracleIntegrationTest {

	static final String LOGIN_RESULT_VIEW = "/WEB-INF/views/users/login.jsp";

	@Autowired MockMvc mvc;
	@Autowired UsersDao usersDao;
	@Autowired PasswordEncoder passwordEncoder;
	@Autowired JdbcTemplate jdbc;

	@BeforeEach
	void setUp() {
		usersDao.insert(UsersDto.builder()
				.id("reader").pwd(passwordEncoder.encode("pw1234!")).email("reader@example.com").name("독자")
				.build());
	}

	@Test
	void loginSucceedsAndBridgesLegacySessionId() throws Exception {
		MvcResult result = mvc.perform(post("/users/login")
						.param("id", "reader").param("pwd", "pw1234!").param("url", "/group/list?genre=-1"))
				.andExpect(authenticated().withUsername("reader").withRoles("USER"))
				.andExpect(forwardedUrl(LOGIN_RESULT_VIEW))
				.andExpect(request().attribute("url", "/group/list?genre=-1"))
				.andReturn();

		assertThat(result.getRequest().getSession().getAttribute("id")).isEqualTo("reader");
	}

	@Test
	void wrongPasswordFails() throws Exception {
		MvcResult result = mvc.perform(post("/users/login").param("id", "reader").param("pwd", "wrong"))
				.andExpect(unauthenticated())
				.andExpect(forwardedUrl(LOGIN_RESULT_VIEW))
				.andReturn();

		assertThat(result.getRequest().getSession().getAttribute("id")).isNull();
	}

	@Test
	void unknownUserFails() throws Exception {
		mvc.perform(post("/users/login").param("id", "nobody").param("pwd", "pw1234!"))
				.andExpect(unauthenticated());
	}

	@Test
	void redirectAfterLoginIsLimitedToSameSite() throws Exception {
		for (String evil : new String[] { "//evil.example.com", "https://evil.example.com", "/\";alert(1);//" }) {
			mvc.perform(post("/users/login").param("id", "reader").param("pwd", "pw1234!").param("url", evil))
					.andExpect(authenticated())
					.andExpect(request().attribute("url", "/"));
		}
	}

	@Test
	void adminRoleComesFromDatabase() throws Exception {
		jdbc.update("UPDATE users_tb SET role = 'ADMIN' WHERE user_id = 'reader'");

		mvc.perform(post("/users/login").param("id", "reader").param("pwd", "pw1234!"))
				.andExpect(authenticated().withRoles("ADMIN"));
	}

	@Test
	void logoutClearsAuthentication() throws Exception {
		MockHttpSession session = new MockHttpSession();
		session.setAttribute("id", "reader");

		MvcResult result = mvc.perform(get("/users/logout").session(session).with(user("reader")))
				.andExpect(unauthenticated())
				.andExpect(forwardedUrl("/WEB-INF/views/users/logout.jsp"))
				.andReturn();

		assertThat(session.isInvalid()).isTrue();
		assertThat(result.getRequest().getSession(false)).isNull();
	}
}
