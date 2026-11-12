package com.acorn.soso.support.service;

import jakarta.servlet.http.HttpSession;

import org.springframework.ui.Model;

import com.acorn.soso.support.dto.InquireDto;

public interface InquireService {
	public void insert(InquireDto dto);
	public void getList(HttpSession session, Model model);
	public void getList2(HttpSession session, Model model);
	public InquireDto getData(int cs_num, Model model);
	public void update (InquireDto dto, Model model);
	public void delete(int cs_num, Model model);
}
