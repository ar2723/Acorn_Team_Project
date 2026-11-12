package com.acorn.soso.security;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 레거시 코드와의 연결부.
 *
 * 기존 코드는 session.getAttribute("id") 로 로그인 사용자를 판단한다(Java 52곳, JSP 17곳).
 * 한 번에 바꾸지 않고, 로그인 성공 시 세션에 같은 키를 함께 넣어 기존 코드가 그대로 동작하게 한다.
 * Phase 2 에서 @AuthenticationPrincipal 로 하나씩 교체한 뒤 이 브리지를 제거한다.
 */
public final class LegacySession {

	/** 레거시 코드가 사용하는 로그인 아이디 세션 키 */
	public static final String LOGIN_ID = "id";

	/** 비밀번호 재확인에 성공한 시각(ms) */
	public static final String PWD_REAUTH_AT = "pwdReauthAt";

	private LegacySession() {
	}

	/**
	 * 로그인 후 이동할 주소. 같은 사이트 안의 경로만 허용한다(open redirect 방지).
	 */
	public static String safeRedirectUrl(HttpServletRequest request) {
		String url = request.getParameter("url");
		String home = request.getContextPath() + "/";
		if (url == null || url.isEmpty()) {
			return home;
		}
		boolean sameSitePath = url.startsWith("/") && !url.startsWith("//") && !url.startsWith("/\\");
		// login.jsp 가 이 값을 <script> 안에 그대로 출력하므로 스크립트를 깨는 문자는 거부한다.
		boolean noScriptBreak = url.chars().noneMatch(c -> c < 0x20 || "\"'<>\\`".indexOf(c) >= 0);
		return sameSitePath && noScriptBreak ? url : home;
	}

	public static String encode(String value) {
		return URLEncoder.encode(value, StandardCharsets.UTF_8);
	}
}
