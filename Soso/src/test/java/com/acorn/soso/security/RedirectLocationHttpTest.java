package com.acorn.soso.security;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import com.acorn.soso.support.OracleIntegrationTest;

/**
 * 리다이렉트 Location 이 상대 경로인지 실제 Tomcat 에서 확인한다.
 * 운영은 nginx(https) 뒤에서 http 로 받기 때문에, 절대 주소로 보내면 http:// 로 바뀐다.
 * (MockMvc 는 Tomcat 을 거치지 않아서 이 설정을 검증할 수 없다.)
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class RedirectLocationHttpTest extends OracleIntegrationTest {

	@LocalServerPort
	int port;

	private final HttpClient client = HttpClient.newBuilder()
			.followRedirects(HttpClient.Redirect.NEVER)
			.build();

	@Test
	void rootRedirectsToMainWithRelativeLocation() throws Exception {
		HttpResponse<Void> response = get("/");
		assertThat(response.statusCode()).isEqualTo(302);
		assertThat(location(response)).isEqualTo("/main");
	}

	@Test
	void loginRedirectIsRelative() throws Exception {
		HttpResponse<Void> response = get("/users/info");
		assertThat(response.statusCode()).isEqualTo(302);
		assertThat(location(response)).startsWith("/users/loginform?url=");
	}

	private HttpResponse<Void> get(String path) throws Exception {
		HttpRequest request = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build();
		return client.send(request, HttpResponse.BodyHandlers.discarding());
	}

	private String location(HttpResponse<Void> response) {
		return response.headers().firstValue("Location").orElseThrow();
	}
}
