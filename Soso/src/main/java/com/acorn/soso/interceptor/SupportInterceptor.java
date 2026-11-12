package com.acorn.soso.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;


//admin 계정으로 로그인 했을때 support 페이지 기능 활성화 할 인터셉터
@Component
public class SupportInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) 
	throws Exception{
		//세션 객체의 참조값을 얻어와서 
	    // 관리자 여부는 아이디가 아니라 역할(ROLE_ADMIN)로 판단한다.
	    boolean isAdmin = request.isUserInRole("ADMIN");
	    request.setAttribute("isAdmin", isAdmin);
	  //admin 계정이라면 흐름 이어가기
	return true;
	}

}
