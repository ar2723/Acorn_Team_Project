package com.acorn.soso.group_managing.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.acorn.soso.group_managing.dto.GroupMemberInfoDto;
import com.acorn.soso.group_managing.service.GroupManagingService;
import com.acorn.soso.group_managing.service.GroupMemberInfoService;

@Controller
public class GroupMemberInfoController {
	
	@Autowired
	GroupManagingService service;
	
	@Autowired
	private GroupMemberInfoService groupMemberInfoService;
	
	@GetMapping("/group_managing/memberInfo")
	public String group_memberInfo(int num, int group_num, HttpServletRequest request) {
		service.getMemberData(num, request);
		request.setAttribute("group_num", group_num);
		return "group_managing/memberInfo";
	}
	
	@GetMapping("/group_managing/info/writing_list")
	public String group_memberWriting_list(GroupMemberInfoDto dto, Model model, HttpSession session) {
		groupMemberInfoService.getGroupMemberWritingList(dto, model);
		return "group_managing/info/writing_list";
	}
	
	@GetMapping("/group_managing/info/comment_list")
	public String group_memberComment_list(GroupMemberInfoDto dto, Model model, HttpSession session) {
		groupMemberInfoService.getGroupMemberCommentList(dto, model);
		return "group_managing/info/comment_list";
	}
}
