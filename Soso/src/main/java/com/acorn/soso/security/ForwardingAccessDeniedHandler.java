package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.CsrfException;

/** 권한이 없을 때 403 상태와 함께 공통 경고 화면(error/info.jsp)을 보여준다. */
public class ForwardingAccessDeniedHandler implements AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		// CSRF 토큰이 없거나 맞지 않는 경우(오래 열어둔 페이지, 다른 탭에서 로그아웃 등)는 따로 안내한다.
		String message = accessDeniedException instanceof CsrfException
				? "요청이 만료되었습니다. 페이지를 새로고침한 뒤 다시 시도해 주세요."
				: "접근 권한이 없습니다.";
		request.setAttribute("exception", new AccessDeniedException(message));
		request.getRequestDispatcher("/WEB-INF/views/error/info.jsp").forward(request, response);
	}
}
