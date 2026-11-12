package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

/**
 * 로그인 실패 처리. users/login.jsp 가 실패 안내 후 로그인 폼으로 되돌려 보낸다.
 * 아이디가 없는지, 비밀번호가 틀렸는지는 구분해서 알려주지 않는다.
 */
@Component
public class LoginFailureHandler implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		String url = LegacySession.safeRedirectUrl(request);
		request.setAttribute("url", url);
		request.setAttribute("encodedUrl", LegacySession.encode(url));
		request.getRequestDispatcher("/WEB-INF/views/users/login.jsp").forward(request, response);
	}
}
