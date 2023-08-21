package com.acorn.soso.test.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.acorn.soso.test.dto.BookDto;
import com.acorn.soso.test.service.BookService;

@Controller
public class BookController {
	
	@Autowired
	private BookService service;
	
	//책을 임시로 저장하기 위한 컨트롤러
	@PostMapping("/test/saveBook")
	public String saveBook(BookDto dto) {
		//DB에 저장
		service.saveBook(dto);
		//임시로 소모임 리스트로 보내기
		return "list";
	}

	//책을 검색하기 위한 컨트롤러
	@GetMapping("/test/booksearch")
	public String bookSearch() {		
		return "test/booksearch";
	}
	
	//책의 리스트를 얻기 위한 컨트롤러
	@GetMapping("/test/bookTest")
	public String bookList(Model model, HttpServletRequest request) {
		service.getBookList(model, request);
		return "test/bookTest";
	}
}
