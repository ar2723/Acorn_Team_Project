package com.acorn.soso.group_managing.service;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group_managing.dto.GroupManagingDto;

public interface GroupManagingService {
	public void getGroupList(String manager_id, HttpServletRequest request);
	public void getFinishedGroupList(String manager_id, HttpServletRequest request);
	public void getAllGroupList(String manager_id, HttpServletRequest request);
	public void getGroupList2(String user_id, HttpServletRequest request);
	public void getFinishedGroupList2(String user_id, HttpServletRequest request);
	public void getAllGroupList2(String user_id, HttpServletRequest request);
	public GroupDto getGroupData(int num, HttpServletRequest request);
	public Map<String, Object> saveGroupImage(HttpServletRequest request, MultipartFile image);
	public void updateGroupData(GroupDto dto, HttpServletRequest request);
	public void deleteGroupData(int num);
	public void getMemberList(int group_num, HttpServletRequest request);
	public void getMemberData(int num, HttpServletRequest request);
	public void getKickedMemberList(int group_num, HttpServletRequest request);
	public void getApplicantList(int group_num, HttpServletRequest request);
	public void getRejectedApplicantList(int group_num, HttpServletRequest request);
	public void joinApprove(int num, int group_num);
	public void getMemberCount(int num, HttpServletRequest request);
	public void kick(int num, int group_num);
	public void reject(int num);
	public void getDetail(ModelAndView mView, int num);
	public void dropOut(GroupManagingDto dto);
	public List<GroupManagingDto> getMateList(int num);
	
}
