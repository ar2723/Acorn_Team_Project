package com.acorn.soso.security;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import com.acorn.soso.support.OracleIntegrationTest;

/** SecurityConfig 의 URL 규칙 */
@AutoConfigureMockMvc
class AccessRulesTest extends OracleIntegrationTest {

	static final String ADMIN_PAGE = "/support/support_inquire_inquireStatus";

	@Autowired MockMvc mvc;

	@Test
	void publicPagesAreOpenToAnonymous() throws Exception {
		mvc.perform(get("/group/list").param("genre", "-1")).andExpect(status().isOk());
		mvc.perform(get("/support/support_notice")).andExpect(status().isOk());
		mvc.perform(get("/users/loginform")).andExpect(status().isOk());
	}

	@Test
	void anonymousIsSentToLoginFormWithReturnUrl() throws Exception {
		mvc.perform(get("/group_managing/admin_main"))
				.andExpect(redirectedUrl("/users/loginform?url=%2Fgroup_managing%2Fadmin_main"));
		mvc.perform(get("/users/info"))
				.andExpect(redirectedUrl("/users/loginform?url=%2Fusers%2Finfo"));
	}

	@Test
	void stateChangingRequestsNeedLogin() throws Exception {
		// 예전에는 로그인 검사가 없어 세션 id 가 null 인 채로 가입 신청이 저장될 수 있었다.
		mvc.perform(post("/group/join").with(csrf()).param("num", "1").param("intro", "hi"))
				.andExpect(status().is3xxRedirection())
				.andExpect(redirectedUrl("/users/loginform?url=%2Fgroup%2Fjoin"));
		mvc.perform(post("/group/jjim").with(csrf()).param("num", "1"))
				.andExpect(status().is3xxRedirection());
	}

	@Test
	void adminPagesRejectNormalUsers() throws Exception {
		mvc.perform(get(ADMIN_PAGE).with(user("reader").roles("USER"))).andExpect(status().isForbidden());
		mvc.perform(get(ADMIN_PAGE + "/").with(user("reader").roles("USER"))).andExpect(status().isForbidden());
		mvc.perform(get("/support/support_notice_insertform").with(user("reader").roles("USER")))
				.andExpect(status().isForbidden());
	}

	@Test
	void adminPagesAllowAdmins() throws Exception {
		mvc.perform(get(ADMIN_PAGE).with(user("admin").roles("ADMIN"))).andExpect(status().isOk());
	}
}
