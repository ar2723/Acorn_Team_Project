package com.acorn.soso.test.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.acorn.soso.test.dto.BookDto;

public interface BookService {

	//책의 정보를 불러오기 위한 서비스
	public void getBookList(Model model, HttpServletRequest request);
	
	//책을 임시로 DB에 저장
	public void saveBook(BookDto dto);
}
