package com.acorn.soso.support.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.acorn.soso.exception.DontEqualException;
import com.acorn.soso.support.dao.NoticeDao;
import com.acorn.soso.support.dto.FaqDto;
import com.acorn.soso.support.dto.InquireDto;
import com.acorn.soso.support.dto.NoticeDto;
import com.acorn.soso.support.service.FaqService;
import com.acorn.soso.support.service.InquireService;
import com.acorn.soso.support.service.NoticeService;
import com.acorn.soso.users.service.UsersService;

@Controller
public class SupportController {
	@Autowired
	private FaqService service;
	
	@Autowired
	private UsersService userService;
	
	@Autowired
	private InquireService inquireService;
	
	@Autowired
	private NoticeService noticeService;
	
	@GetMapping("/support/support_main")
	public String support_main(FaqDto dto, HttpServletRequest request, Model model) {
		noticeService.getList2(request, model);
		service.getList(dto, request, model);
		return "support/support_main";
	}
	
	@GetMapping("/support/support_faq")
	public String support_faq(FaqDto dto, HttpServletRequest request, Model model) {
		//서비스에 HttpServletRequest 객체를 전달해서 응답에 필요한 데이타가 담기도록 하고 
		service.getList(dto, request, model);
		return "support/support_faq";
	}
	@GetMapping("/support/support_faq_user")
	public String support_faq_user(FaqDto dto, HttpServletRequest request, Model model) {
		service.getListCategory(dto, request, model);
		return "support/support_faq_user";
	}
	@GetMapping("/support/support_faq_request")
	public String support_faq_request(FaqDto dto, HttpServletRequest request, Model model) {
		service.getListCategory(dto, request, model);
		return "support/support_faq_request";
	}
	@GetMapping("/support/support_faq_open")
	public String support_faq_open(FaqDto dto, HttpServletRequest request, Model model) {
		service.getListCategory(dto, request, model);
		return "support/support_faq_open";
	}
	@GetMapping("/support/support_faq_etc")
	public String support_faq_etc(FaqDto dto, HttpServletRequest request, Model model) {
		service.getListCategory(dto, request, model);
		return "support/support_faq_etc";
	}
	
	@GetMapping("/support/support_faq_insertform")
	public String support_faq_insertform() {
		
		return "support/support_faq_insertform";
	}
	//FAQ 수정폼
	@GetMapping("/support/support_faq_updateform")
	public String support_faq_updateform(int faq_num, Model model) {
		service.getData(faq_num, model);
		return "support/support_faq_updateform";
	}
	//FAQ 수정
	@PostMapping("/support/support_faq_update")
	public String support_faq_update(FaqDto dto) {
		service.updateFaq(dto);
		
		return "redirect:/support/support_faq";
	}
	//FAQ 삭제
	@GetMapping("/support/support_faq_delete")
	public String support_faq_delete(int faq_num, Model model) {
		
		FaqDto dto = service.getData(faq_num, model);
		
		service.deleteFaq(faq_num, model);
	
		return "redirect:/support/support_faq";
	}
	//공지사항 메인 화면
	@GetMapping("/support/support_notice")
	public String support_notice(HttpServletRequest request, Model model) {
		
		noticeService.getList(request, model);
		
		return "support/support_notice";
	}
	//공지사항 등록폼
	@GetMapping("/support/support_notice_insertform")
	public String support_notice_insertform() {
		return "support/support_notice_insertform";
	}
	//공지사항 등록
	@PostMapping("/support/support_notice_insert")
	public String insert(NoticeDto dto) {
		//서비스를 이용해서 질문을 저장
		noticeService.saveNotice(dto);
		return "support/support_notice_insert";
	}
	//공지사항 수정폼
	@GetMapping("/support/support_notice_updateform")
	public String support_notice_updateform(int notice_num, Model model) {
		noticeService.getData(notice_num, model);
		return "support/support_notice_updateform";
	}
	//공지사항 수정
	@PostMapping("/support/support_notice_update")
	public String support_notice_update(NoticeDto dto) {
		noticeService.updateNotice(dto);
		
		return "redirect:/support/support_notice";
	}
	//공지사항 삭제
	@GetMapping("/support/support_notice_delete")
	public String support_notice_delete(int notice_num, Model model) {
		
		NoticeDto dto = noticeService.getData(notice_num,model);
		
		noticeService.deleteNotice(notice_num,model);
	
		return "redirect:/support/support_notice";
	}
	//공지사항 디테일
	@GetMapping("/support/support_notice_detail")
	public String support_notice_detail(int notice_num, Model model) {
		noticeService.getData(notice_num, model);
		return "support/support_notice_detail";
	}
	
	@GetMapping("/support/support_inquire")
	public String support_inquire(HttpSession session, Model model) {
		userService.getInfo(session, model);
		return "support/support_inquire";
	}
	
	@PostMapping("/support/support_inquire_insert")
	public String support_inquire_insert(InquireDto dto) {
		inquireService.insert(dto);
		return "support/support_inquire_insert";
	}
	@PostMapping("/support/support_inquire_answer")
	public String support_inquire_answer(InquireDto dto, Model model) {
		inquireService.update(dto, model);
		return "support/support_inquire_answer";
	}
	@GetMapping("/support/support_inquire_MyInquire")
	public String support_inquire_MyInquire(HttpSession session, Model model) {
		inquireService.getList(session, model);
		return "support/support_inquire_MyInquire";
	}
	@GetMapping("/support/support_inquire_answerform")
	public String support_inquire_answerform(int cs_num,HttpSession session, Model model) {
		//userService.getInfo(session, model);
		inquireService.getData(cs_num, model);
		
		return "support/support_inquire_answerform";
	}
	@GetMapping("/support/support_inquire_inquireStatus")
	public String support_inquire_inquireStatus(HttpSession session, Model model) {
		inquireService.getList2(session, model);
		return "support/support_inquire_inquireStatus";
	}
	@GetMapping("/support/support_inquire_delete")
	public String support_inquire_delete(int cs_num, Model model, HttpSession session, HttpServletRequest request) {
		String id = (String)session.getAttribute("id");
		boolean isAdmin = request.isUserInRole("ADMIN");
		InquireDto dto = inquireService.getData(cs_num, model);
		if(isAdmin || (dto.getWriter() != null && dto.getWriter().equals(id))) {
			inquireService.delete(cs_num, model);
		} else{
			throw new DontEqualException("다른 사람의 문의 내역을 삭제할 수 없습니다!");
		}
		if(isAdmin){
			return "redirect:/support/support_inquire_inquireStatus";
		}else {
			return "redirect:/support/support_inquire_MyInquire";
		}
		
	}
	@PostMapping("/support/support_faq_insert")
	public String insert(FaqDto dto) {
		//서비스를 이용해서 질문을 저장
		service.saveFaq(dto);
		return "support/support_faq_insert";
	}
}