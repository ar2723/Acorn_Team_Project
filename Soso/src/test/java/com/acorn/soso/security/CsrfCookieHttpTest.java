package com.acorn.soso.security;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import com.acorn.soso.support.OracleIntegrationTest;

/**
 * 실제 HTTP 서버에서 브라우저와 같은 흐름으로 CSRF 쿠키 왕복을 검증한다.
 * (MockMvc 의 csrf() 는 토큰 저장소를 테스트용으로 바꾸므로 쿠키 발급 자체를 확인하기 어렵다.)
 *
 * 로그인 요청에 없는 아이디를 쓰므로 CSRF 를 통과하면 "로그인 실패 화면(200)",
 * 통과하지 못하면 "403" 이 된다. DB 데이터가 필요 없다.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class CsrfCookieHttpTest extends OracleIntegrationTest {

	@Autowired
	TestRestTemplate http;

	@Test
	void pageHandsOutTokenCookieReadableByScript() {
		String setCookie = tokenSetCookieHeader();
		assertThat(setCookie).startsWith("XSRF-TOKEN=");
		assertThat(setCookie).doesNotContainIgnoringCase("HttpOnly");
	}

	@Test
	void postWithoutTokenIsForbidden() {
		ResponseEntity<String> response = postLogin(new HttpHeaders(), form());
		assertThat(response.getStatusCode()).isEqualTo(HttpStatus.FORBIDDEN);
	}

	@Test
	void tokenAsHeaderPassesCsrf() {
		String token = tokenValue();
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.COOKIE, "XSRF-TOKEN=" + token);
		headers.add("X-XSRF-TOKEN", token); // jQuery / fetch (csrf.js)

		assertThat(postLogin(headers, form()).getStatusCode()).isEqualTo(HttpStatus.OK);
	}

	@Test
	void tokenAsFormParameterPassesCsrf() {
		String token = tokenValue();
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.COOKIE, "XSRF-TOKEN=" + token);
		MultiValueMap<String, String> form = form();
		form.add("_csrf", token); // hidden input (csrf.js)

		assertThat(postLogin(headers, form).getStatusCode()).isEqualTo(HttpStatus.OK);
	}

	@Test
	void tokenMustMatchCookie() {
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.COOKIE, "XSRF-TOKEN=" + tokenValue());
		headers.add("X-XSRF-TOKEN", "forged-by-another-site");

		assertThat(postLogin(headers, form()).getStatusCode()).isEqualTo(HttpStatus.FORBIDDEN);
	}

	private String tokenSetCookieHeader() {
		List<String> cookies = http.getForEntity("/users/loginform", String.class)
				.getHeaders().get(HttpHeaders.SET_COOKIE);
		assertThat(cookies).isNotNull();
		return cookies.stream().filter(c -> c.startsWith("XSRF-TOKEN=")).findFirst().orElseThrow();
	}

	private String tokenValue() {
		String header = tokenSetCookieHeader();
		return header.substring("XSRF-TOKEN=".length(), header.indexOf(';'));
	}

	private MultiValueMap<String, String> form() {
		MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
		form.add("id", "nobody");
		form.add("pwd", "whatever");
		return form;
	}

	private ResponseEntity<String> postLogin(HttpHeaders headers, MultiValueMap<String, String> form) {
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		return http.postForEntity("/users/login", new HttpEntity<>(form, headers), String.class);
	}
}
