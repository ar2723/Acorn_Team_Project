package com.acorn.soso.book.dao;

import java.util.List;

import com.acorn.soso.book.dto.BookDto;

public interface BookDao {
	public void saveBook(BookDto dto);
	public List<BookDto> bookList(int group_num);
	public void deleteBook(BookDto dto);
}
