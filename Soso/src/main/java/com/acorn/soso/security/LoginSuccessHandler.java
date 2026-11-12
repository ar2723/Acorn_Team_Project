package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

/**
 * 로그인 성공 처리. 기존 결과 화면(users/login.jsp)을 그대로 사용한다.
 */
@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		// Spring Security 가 세션 고정 공격 방지를 위해 이미 세션 ID 를 바꿨다.
		request.getSession().setAttribute(LegacySession.LOGIN_ID, authentication.getName());

		String url = LegacySession.safeRedirectUrl(request);
		request.setAttribute("url", url);
		request.setAttribute("encodedUrl", LegacySession.encode(url));
		request.getRequestDispatcher("/WEB-INF/views/users/login.jsp").forward(request, response);
	}
}
