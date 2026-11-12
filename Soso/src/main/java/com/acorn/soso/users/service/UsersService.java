package com.acorn.soso.users.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.acorn.soso.users.dto.UsersDto;

public interface UsersService {
	public void addUser(UsersDto dto);
	public boolean isExist(String id); // id중복체크
	public boolean isExist2(String name); // 닉네임 중복체크
	public boolean isSamePwd(UsersDto dto); //동일한 비밀번호인지 체크
	public void getInfo(HttpSession session, Model model);
	public UsersDto getNaver(String email);
	public void updateUserPwd(HttpSession session, UsersDto dto, Model model);
	public Map<String, Object> saveProfileImage(HttpServletRequest request, MultipartFile mFile);
	public void updateUser(UsersDto dto, HttpSession session);
	public void deleteUser(HttpSession session, Model model);
	public void findUserPwd(UsersDto dto, Model model);
	public void findUserId(UsersDto dto, Model model); // id찾기
	public void pwdAuth(UsersDto dto, HttpSession session, Model model);
	public void updateSocial(String id);
}
