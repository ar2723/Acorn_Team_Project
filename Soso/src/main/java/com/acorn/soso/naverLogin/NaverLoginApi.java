package com.acorn.soso.naverLogin;

import org.springframework.stereotype.Component;

import com.github.scribejava.core.builder.api.DefaultApi20;

@Component
public class NaverLoginApi extends DefaultApi20{
	protected NaverLoginApi(){
	}
	//싱글톤 패턴을 구현하기 위한 것
	private static class InstanceHolder{
		private static final NaverLoginApi INSTANCE = new NaverLoginApi();
	}
	public static NaverLoginApi instance(){
		return InstanceHolder.INSTANCE;
	}
	@Override
	public String getAccessTokenEndpoint() {
		return "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
	}
	@Override
	protected String getAuthorizationBaseUrl() {
		return "https://nid.naver.com/oauth2.0/authorize";
	}
}
