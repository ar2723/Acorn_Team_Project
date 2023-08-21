package com.acorn.soso.test.dto;

import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Alias("naverDto")
public class NaverResultDto {
	private String lastBuildDate;
	private int total;
	private int start;
	private int display;
	private List<BookDto> items;
}
