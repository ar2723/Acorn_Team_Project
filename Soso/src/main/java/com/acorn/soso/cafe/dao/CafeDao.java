package com.acorn.soso.cafe.dao;

import java.util.List;

import com.acorn.soso.cafe.dto.CafeDto;



public interface CafeDao {
	//글목록
	public List<CafeDto> getList(CafeDto dto);
	//글의 갯수
	public int getCount(CafeDto dto);
	//글 추가
	public void insert(CafeDto dto);
	//글정보 얻어오기
	public CafeDto getData(int comu_num);
	//키워드를 활용한 글정보 얻어오기 (키워드에 부합하는 글중에서 이전글, 다음글의 글번호도 얻어올수 있도록)
	public CafeDto getData(CafeDto dto);
	//조회수 증가 시키기
	public void addViewCount(int comu_num);
	//글 삭제
	public void delete(int comu_num);
	//글 수정
	public void update(CafeDto dto);
}



