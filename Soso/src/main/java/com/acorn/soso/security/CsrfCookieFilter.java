package com.acorn.soso.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * CSRF 토큰 쿠키(XSRF-TOKEN)가 항상 내려가게 한다.
 *
 * Spring Security 5.x 는 토큰 저장소를 지연(lazy) 방식으로 감싸서, 서버 코드가 토큰을 읽을 때만 쿠키를 굽는다.
 * JSP 화면은 토큰을 직접 읽지 않고 csrf.js 가 쿠키에서 읽어가므로, 여기서 한 번 읽어 쿠키를 만들어 둔다.
 */
public class CsrfCookieFilter extends OncePerRequestFilter {

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws ServletException, IOException {
		CsrfToken token = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
		if (token != null) {
			token.getToken();
		}
		chain.doFilter(request, response);
	}
}
