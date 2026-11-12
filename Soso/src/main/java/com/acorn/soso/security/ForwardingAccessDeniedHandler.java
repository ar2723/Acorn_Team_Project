package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

/** 권한이 없을 때 403 상태와 함께 공통 경고 화면(error/info.jsp)을 보여준다. */
public class ForwardingAccessDeniedHandler implements AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		request.setAttribute("exception", new AccessDeniedException("접근 권한이 없습니다."));
		request.getRequestDispatcher("/WEB-INF/views/error/info.jsp").forward(request, response);
	}
}
