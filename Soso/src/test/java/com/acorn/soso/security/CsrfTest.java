package com.acorn.soso.security;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.unauthenticated;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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

/**
 * CSRF 방어.
 * 토큰은 XSRF-TOKEN 쿠키로 내려가고, 브라우저에서는 resources/js/csrf.js 가 헤더/파라미터로 돌려보낸다.
 * 실제 쿠키 왕복은 CsrfCookieHttpTest 에서 검증한다.
 */
@AutoConfigureMockMvc
class CsrfTest extends OracleIntegrationTest {

	static final String ERROR_VIEW = "/WEB-INF/views/error/info.jsp";

	@Autowired MockMvc mvc;
	@Autowired UsersDao usersDao;
	@Autowired PasswordEncoder passwordEncoder;

	@BeforeEach
	void setUp() {
		usersDao.insert(UsersDto.builder()
				.id("reader").pwd(passwordEncoder.encode("pw1234!")).email("reader@example.com").name("독자")
				.build());
	}

	@Test
	void postWithoutTokenIsRejected() throws Exception {
		mvc.perform(post("/users/login").param("id", "reader").param("pwd", "pw1234!"))
				.andExpect(status().isForbidden())
				.andExpect(forwardedUrl(ERROR_VIEW))
				.andExpect(unauthenticated());
	}

	@Test
	void postWithWrongTokenIsRejected() throws Exception {
		mvc.perform(post("/users/login").with(csrf().useInvalidToken()).param("id", "reader").param("pwd", "pw1234!"))
				.andExpect(status().isForbidden());
	}

	@Test
	void logoutByGetLinkNoLongerWorks() throws Exception {
		MockHttpSession session = new MockHttpSession();
		mvc.perform(get("/users/logout").session(session).with(user("reader")));

		assertThat(session.isInvalid()).isFalse();
	}

	@Test
	void stateChangingEndpointsRejectGet() throws Exception {
		String[] postOnly = {
				"/group_managing/kick?num=1&group_num=1", "/group_managing/reject?num=1&group_num=1",
				"/group_managing/joinApprove?num=1&group_num=1", "/group_managing/group_delete?num=1",
				"/group_managing/group_userdropOut?group_num=1",
				"/group/faq/delete?num=1&group_num=1", "/group/answer/delete?num=1&group_num=1",
				"/group/review_delete?num=1&group_num=1", "/group/jjim?num=1", "/group/cancleJoin?num=1",
				"/cafe/delete?comu_num=1&group_num=1", "/support/support_inquire_delete?cs_num=1",
		};
		for (String url : postOnly) {
			mvc.perform(get(url).with(user("reader"))).andExpect(status().isMethodNotAllowed());
		}
	}
}
