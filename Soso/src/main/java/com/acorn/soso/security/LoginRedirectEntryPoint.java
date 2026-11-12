package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;

/**
 * 로그인이 필요한 요청을 로그인 폼으로 보낸다.
 * 기존 LoginInterceptor 와 같이 원래 주소를 url 파라미터로 넘겨서, 로그인 후 그 주소로 돌아간다.
 */
public class LoginRedirectEntryPoint implements AuthenticationEntryPoint {

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException authException) throws IOException {
		String target = request.getRequestURI();
		if (request.getQueryString() != null) {
			target += "?" + request.getQueryString();
		}
		response.sendRedirect(request.getContextPath() + "/users/loginform?url=" + LegacySession.encode(target));
	}
}
