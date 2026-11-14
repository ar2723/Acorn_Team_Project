package com.acorn.soso.security;

import jakarta.servlet.DispatcherType;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;

/**
 * 인증/인가 설정.
 *
 * 원칙: 기본은 로그인 필요(deny by default). 공개 페이지만 명시적으로 허용한다.
 * 경로 매칭은 Spring MVC 와 같은 규칙(requestMatchers)을 쓴다. Spring 6 부터 "/path/" 같은 변형 경로는
 * MVC 핸들러에도 매칭되지 않으므로 규칙 우회가 불가능하다.
 *
 * CSRF: 토큰을 XSRF-TOKEN 쿠키로 내려주고, resources/js/csrf.js 가 폼과 Ajax 요청에 자동으로 붙인다.
 * 상태를 바꾸는 요청은 모두 POST 이므로 GET 링크로는 삭제·로그아웃 등을 일으킬 수 없다.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

	/** 로그인 없이 볼 수 있는 화면 (GET) */
	static final String[] PUBLIC_PAGES = {
			"/", "/main",
			// 소모임 둘러보기
			"/group/list", "/group/ajax_list", "/group/viewList", "/group/ajax_viewList",
			"/group/detail", "/group/group_page", "/group/faq/list", "/group/faq/paginglist",
			// 소모임 커뮤니티 읽기
			"/cafe/list", "/cafe/detail", "/cafe/ajax_comment_list",
			// 고객센터 읽기
			"/support/support_main", "/support/support_faq", "/support/support_faq_user",
			"/support/support_faq_request", "/support/support_faq_open", "/support/support_faq_etc",
			"/support/support_notice", "/support/support_notice_detail",
			// 회원가입, 계정 찾기
			"/users/loginform", "/users/signup_form", "/users/pwd_findform", "/users/id_findform",
			// 업로드 이미지
			"/users/images/**", "/group/images/**", "/editor/images/**",
	};

	/** 로그인 없이 호출할 수 있는 요청 (모든 메서드) */
	static final String[] PUBLIC_ACTIONS = {
			"/users/signup", "/users/idCheck", "/users/nameCheck", "/users/pwd_find", "/users/id_find",
			"/group/ajax_review_list",
			// 네이버 로그인은 보류 중인 레거시 기능이라 기존 동작을 유지한다.
			"/users/socialaccess", "/naver/**",
	};

	/** 사이트 관리자 전용 */
	static final String[] ADMIN_ONLY = {
			"/support/support_notice_insertform", "/support/support_notice_insert",
			"/support/support_notice_updateform", "/support/support_notice_update",
			"/support/support_notice_delete",
			"/support/support_faq_insertform", "/support/support_faq_insert",
			"/support/support_faq_updateform", "/support/support_faq_update",
			"/support/support_faq_delete",
			"/support/support_inquire_inquireStatus", "/support/support_inquire_answerform",
			"/support/support_inquire_answer",
	};

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http,
			LoginSuccessHandler successHandler, LoginFailureHandler failureHandler) throws Exception {
		http
			.csrf(csrf -> csrf
					.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
					// csrf.js 는 쿠키 값을 그대로 돌려보낸다. Security 6 기본(XOR 마스킹) 대신 원본 값을 비교한다.
					.csrfTokenRequestHandler(new CsrfTokenRequestAttributeHandler()))
			.addFilterAfter(new CsrfCookieFilter(), CsrfFilter.class)
			.authorizeHttpRequests(auth -> auth
					// 컨트롤러가 JSP 로 forward 하는 요청, 에러 페이지는 이미 인가된 요청의 내부 처리이다.
					.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
					.requestMatchers("/resources/**", "/error").permitAll()
					.requestMatchers(ADMIN_ONLY).hasRole("ADMIN")
					.requestMatchers(HttpMethod.GET, PUBLIC_PAGES).permitAll()
					// HEAD 는 GET 과 같은 핸들러가 본문 없이 응답한다. 막으면 모니터링·링크 미리보기에서 로그인 화면 리다이렉트 루프가 난다.
					.requestMatchers(HttpMethod.HEAD, PUBLIC_PAGES).permitAll()
					.requestMatchers(PUBLIC_ACTIONS).permitAll()
					.anyRequest().authenticated())
			.formLogin(form -> form
					.loginPage("/users/loginform")
					.loginProcessingUrl("/users/login")
					.usernameParameter("id")
					.passwordParameter("pwd")
					.successHandler(successHandler)
					.failureHandler(failureHandler)
					.permitAll())
			.logout(logout -> logout
					.logoutUrl("/users/logout")
					.logoutSuccessHandler((request, response, authentication) ->
							request.getRequestDispatcher("/WEB-INF/views/users/logout.jsp").forward(request, response))
					.invalidateHttpSession(true)
					.deleteCookies("JSESSIONID"))
			.exceptionHandling(ex -> ex
					.authenticationEntryPoint(new LoginRedirectEntryPoint())
					.accessDeniedHandler(new ForwardingAccessDeniedHandler()));
		return http.build();
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		// 기존 회원 비밀번호는 BCrypt 로 저장되어 있다.
		return new BCryptPasswordEncoder();
	}
}
