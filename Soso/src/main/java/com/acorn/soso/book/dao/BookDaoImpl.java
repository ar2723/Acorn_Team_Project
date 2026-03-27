package com.acorn.soso.book.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.acorn.soso.book.dto.BookDto;
@Repository
public class BookDaoImpl implements BookDao{

	@Autowired
	private SqlSession session;
	
	@Override
	public void saveBook(BookDto dto) {
		session.insert("book.saveBook", dto);
	}

	@Override
	public List<BookDto> bookList(int group_num) {
		return session.selectList("book.bookList", group_num);
	}

	@Override
	public void deleteBook(BookDto dto) {
		session.delete("book.bookDelete", dto);
	}
}
