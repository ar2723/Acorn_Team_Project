package com.acorn.soso.support.service;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.acorn.soso.support.dao.InquireDao;
import com.acorn.soso.support.dto.InquireDto;

@Service
public class InquireServiceImpl implements InquireService{
	
	@Autowired
	private InquireDao dao;
	
	@Override
	public void insert(InquireDto dto) {
		dao.insert(dto);
	}

	@Override
	public void getList(HttpSession session, Model model) {
		String id = (String)session.getAttribute("id");
		List<InquireDto> list = dao.getList(id);
		model.addAttribute("list", list);
	}
	@Override
	public void getList2(HttpSession session, Model model) {
		String id = (String)session.getAttribute("id");
		List<InquireDto> list = dao.getList2(id);
		model.addAttribute("list2", list);
	}

	@Override
	public InquireDto getData(int cs_num, Model model) {
		InquireDto dto = dao.getData(cs_num);
		model.addAttribute("dto", dto);
		return dto;
	}

	@Override
	public void update(InquireDto dto, Model model) {
		dao.update(dto);
	}

	@Override
	public void delete(int cs_num, Model model) {
		dao.delete(cs_num);
	}

}
