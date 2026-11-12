package com.acorn.soso.support.service;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.acorn.soso.support.dto.NoticeDto;

public interface NoticeService {
	//공지 목록 얻어오기
	public void getList(HttpServletRequest request, Model model);
	//공지 목록2 얻어오기(고객센터 메인페이지에 쓰일)
	public void getList2(HttpServletRequest request, Model model);
	//공지 수정하기 위한 정보 불러오기
	public NoticeDto getData(int notice_num, Model model);
	//공지 등록
	public void saveNotice(NoticeDto dto);
	//공지 수정
	public void updateNotice(NoticeDto dto);
	//공지 삭제
	public void deleteNotice(int notice_num, Model model);
}
