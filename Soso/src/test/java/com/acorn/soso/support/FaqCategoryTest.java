package com.acorn.soso.support;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

import com.acorn.soso.support.dao.FaqDao;

/**
 * 운영 장애 재발 방지:
 *   FAQ 등록 폼에서 분류를 고르지 않으면 '분류' 라는 글자가 저장됐고,
 *   이후 카테고리별 개수 쿼리(숫자 비교)가 ORA-01722 로 실패해 FAQ 화면 전체가 500 이 됐다.
 */
@AutoConfigureMockMvc
class FaqCategoryTest extends OracleIntegrationTest {

	@Autowired MockMvc mvc;
	@Autowired FaqDao faqDao;
	@Autowired JdbcTemplate jdbc;

	@Test
	void registeringWithoutCategoryIsRejected() throws Exception {
		for (String category : new String[] { null, "", "분류", "4", "1 or 1=1" }) {
			var request = multipart("/support/support_faq_insert")
					.param("question", "질문").param("answer", "<p>답변</p>")
					.with(csrf()).with(user("admin").roles("ADMIN"));
			if (category != null) {
				request.param("category", category);
			}
			mvc.perform(request)
					.andExpect(status().isBadRequest())
					.andExpect(forwardedUrl("/WEB-INF/views/error/info.jsp"));
		}
		assertThat(faqCount()).isZero();
	}

	@Test
	void databaseRejectsNonNumericCategory() {
		assertThatThrownBy(() -> jdbc.update(
				"INSERT INTO faq_tb (faq_num, category, question, answer) VALUES (faq_seq.NEXTVAL, '분류', 'q', 'a')"))
				.isInstanceOf(DataAccessException.class);
		assertThatThrownBy(() -> jdbc.update(
				"INSERT INTO faq_tb (faq_num, category, question, answer) VALUES (faq_seq.NEXTVAL, 7, 'q', 'a')"))
				.isInstanceOf(DataAccessException.class);
	}

	@Test
	void registeredFaqIsCountedAndListed() throws Exception {
		mvc.perform(multipart("/support/support_faq_insert")
						.param("category", "2").param("question", "모임 신청은?").param("answer", "<p>이렇게</p>")
						.with(csrf()).with(user("admin").roles("ADMIN")))
				.andExpect(status().isOk())
				.andExpect(forwardedUrl("/WEB-INF/views/support/support_faq_insert.jsp"));

		assertThat(faqDao.getFAQCount(2)).isEqualTo(1);
		assertThat(faqDao.getFAQCount(1)).isZero();
		mvc.perform(get("/support/support_faq")).andExpect(status().isOk());
		mvc.perform(get("/support/support_faq_request").param("category", "2")).andExpect(status().isOk());
	}

	private int faqCount() {
		return jdbc.queryForObject("SELECT COUNT(*) FROM faq_tb", Integer.class);
	}
}
