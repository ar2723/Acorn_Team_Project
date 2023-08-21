package com.acorn.soso.cafe.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.acorn.soso.cafe.dto.CafeDto;



@Repository
public class CafeDaoImpl implements CafeDao{
	
	@Autowired
	private SqlSession session;
	
	@Override
	public List<CafeDto> getList(CafeDto dto) {
		
		return session.selectList("cafe.getList", dto);
	}

	@Override
	public int getCount(CafeDto dto) {
		
		return session.selectOne("cafe.getCount", dto);
	}

	@Override
	public void insert(CafeDto dto) {
		session.insert("cafe.insert", dto);
	}

	@Override
	public CafeDto getData(int comu_num) {
		
		return session.selectOne("cafe.getData", comu_num);
	}

	@Override
	public CafeDto getData(CafeDto dto) {
		
		return session.selectOne("cafe.getData2", dto);
	}

	@Override
	public void addViewCount(int comu_num) {
		session.update("cafe.addViewCount", comu_num);
	}

	@Override
	public void delete(int comu_num) {
		session.delete("cafe.delete", comu_num);
	}

	@Override
	public void update(CafeDto dto) {
		session.update("cafe.update", dto);
	}

}
