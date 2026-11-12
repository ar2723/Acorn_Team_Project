package com.acorn.soso.interceptor;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.acorn.soso.security.LegacySession;

@Component
public class PwdAuthInterceptor implements HandlerInterceptor {

	/** 비밀번호 재확인 후 이 시간 동안만 수정/탈퇴를 허용한다. */
	static final long REAUTH_VALID_MILLIS = 10 * 60 * 1000L;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		boolean isValid = false;
		
		// 예전에는 ?isSuccess=true 파라미터만 보고 통과시켜서 URL 조작으로 우회할 수 있었다.
		// 이제는 서버 세션에 기록된 재확인 시각으로 판단한다.
		HttpSession session = request.getSession(false);
		Object reauthAt = session == null ? null : session.getAttribute(LegacySession.PWD_REAUTH_AT);
		if (reauthAt instanceof Long) {
			isValid = System.currentTimeMillis() - (Long) reauthAt < REAUTH_VALID_MILLIS;
		}
		
		// 만일 비밀번호 인증을 하지 않았다면 인증 페이지로 리다이렉트 이동 시키고 false 를 리턴한다.
		if(!isValid) {
			// 원래 가려던 url 정보 읽어오기
			String url = request.getRequestURI();
			// GET 방식 전송 파라미터를 query 문자열로 읽어오기 ( a=xxx&b=xxx&c=xxx )
			String query = request.getQueryString();
			// 특수 문자는 인코딩을 해야한다.
			String encodedUrl = null;
			if (query == null) {// 전송 파라미터가 없다면
				encodedUrl = URLEncoder.encode(url);
			} else {
				// 원래 목적지가 /test/xxx.jsp 라고 가정하면 아래와 같은 형식의 문자열을 만든다.
				// "/test/xxx.jsp?a=xxx&b=xxx ..."
				encodedUrl = URLEncoder.encode(url + "?" + query);
			}

			// 인증을 하지 않았다면 /users/pwd_authform 페이지로 리다이렉트 이동 시킨다. (HttpServletResponse)
			String cPath = request.getContextPath();
			response.sendRedirect(cPath + "/users/pwd_authform?url=" + encodedUrl);
			return false;
		}

		// 인증을 했다면 흐름을 이어간다.
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		// TODO Auto-generated method stub

	}
}
