package com.acorn.soso.book.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.acorn.soso.book.dto.BookDto;
import com.acorn.soso.book.service.BookService;

@Controller
public class BookController {
	
	@Autowired
	private BookService BookService;
	
	//받은 데이터를 json형태로 해서 받아낸다.
	@ResponseBody
	@RequestMapping("/test/addList")
	public BookDto addList(BookDto dto) {
		return dto;
	}
	
	@PostMapping("/test/bookUpdate")
	public ResponseEntity<String> saveBook(@RequestBody List<BookDto> bookList) {
	    try {
	        BookService.saveBook(bookList);
	        return ResponseEntity.ok("저장 성공!");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 실패");
	    }
	}

	//책을 검색하기 위한 컨트롤러
	@GetMapping("/test/booksearch")
	public String bookSearch() {		
		return "test/booksearch";
	}
	
	//책의 리스트를 얻기 위한 컨트롤러
	@GetMapping("/test/bookTest")
	public String bookList(Model model, HttpServletRequest request) {
		BookService.getBookList(model, request);
		return "test/bookTest";
	}
	
	//책 업데이트 폼 이동
	@GetMapping("/test/bookUpdateForm")
	public String bookUpdateForm(Model model, int group_num) {
		BookService.bookList(group_num, model);
		return "test/bookUpdateForm";
	}
	
	//책 삭제 기능(ajax로 삭제하기)
	@ResponseBody
	@PostMapping("/test/bookDelete")
	public boolean bookDelete(int group_num, String isbn) {
		BookService.bookDelete(isbn, group_num);
		return true;
	}
}
