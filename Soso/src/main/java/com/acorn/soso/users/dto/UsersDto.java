package com.acorn.soso.users.dto;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Alias("usersDto")
public class UsersDto {
	//네이버에서 받아올 정보
	private String name;
	private String email;
	
	//사용자가 직접 지정 or 서버상에서 설정
	private String id;
	private String pwd;
	private String profile;
	private String regdate;
	private String newPwd;
	
	//이용약관
	private Integer SVC_USE_PCY_AGMT_YN;
	private Integer PS_INFO_PROC_AGMT_YN;
	private Integer MKT_INFO_RECV_AGMT_YN;

	//소셜 로그인 여부 0:북메이트, 1:통합회원, 2:네이버
	private int social;
}
