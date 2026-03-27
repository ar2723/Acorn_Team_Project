package com.acorn.soso.book.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;

import com.acorn.soso.book.dto.BookDto;

public interface BookService {

	//책의 정보를 불러오기 위한 서비스
	public void getBookList(Model model, HttpServletRequest request);
	
	//책을 임시로 DB에 저장
	public void saveBook(@RequestBody List<BookDto> bookList);
	
	//책 리스트 불러오기
	public void bookList(int group_num, Model model);
	
	//책 삭제하기
	public void bookDelete(String isbn, int group_num);
}
