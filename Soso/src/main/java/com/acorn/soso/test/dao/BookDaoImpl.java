package com.acorn.soso.test.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.acorn.soso.test.dto.BookDto;
@Repository
public class BookDaoImpl implements BookDao{

	
	@Autowired
	private SqlSession session;
	
	@Override
	public void saveBook(BookDto dto) {
		session.insert("book.saveBook", dto);
	}
}
