package com.acorn.soso.support.service;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.acorn.soso.support.dto.FaqDto;

public interface FaqService {
	// 질문 목록 얻어오기
	public void getList(FaqDto dto, HttpServletRequest request, Model model);
	// 카테고리별 질문 목록 얻어오기
	public void getListCategory(FaqDto dto, HttpServletRequest request, Model model);
	// 질문 수정하기 위해 정보 불러오기
	public FaqDto getData(int faq_num, Model model);
	// 질문 등록
	public void saveFaq(FaqDto dto);
	// 질문 수정
	public void updateFaq(FaqDto dto);
	// 질문 삭제
	public void deleteFaq(int faq_num, Model model);
	// 키워드를 이용한 질문 정보 불러오기
	public void getData(FaqDto dto);
	
}
