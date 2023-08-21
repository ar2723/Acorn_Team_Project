package com.acorn.soso.test.dto;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Alias("bookDto")
public class BookDto {
	private int group_num; // 소모임의 그룹넘
	private String title; // 책의 제목
	private String link; //책의 링크
	private String image; //책의 이미지
	private String author; //책의 저자
	private String discount; //책의 가격?
	private String publisher; //책의 출판사
	private String pubdate; //책의 출간일
	private String isbn; //책의 isbn(책의 고유 바코드)
	private String description; //책의 설명

}
