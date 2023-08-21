package com.acorn.soso.cafe.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.acorn.soso.cafe.dto.CafeCommentDto;
import com.acorn.soso.cafe.dto.CafeDto;
import com.acorn.soso.cafe.service.CafeService;



@Controller
public class CafeController {
	@Autowired
	private CafeService service;
	
	
	//댓글 수정 요청처리 (JSON 을 응답하도록 한다)
	@PostMapping("/cafe/comment_update")
	@ResponseBody
	public Map<String, Object> commentUpdate(CafeCommentDto dto){
		service.updateComment(dto);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("isSuccess", true);
		// {"isSuccess":true} 형식의 JSON 문자열이 응답되도록 한다. 
		return map;
	}
	
	//댓글 삭제 요청 처리
	@GetMapping("/cafe/comment_delete")
	@ResponseBody
	public Map<String, Object> commentDelete(HttpServletRequest request) {
		service.deleteComment(request);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("isSuccess", true);
		// {"isSuccess":true} 형식의 JSON 문자열이 응답되도록 한다. 
		return map;
	}	
	
	//댓글 더보기 요청 처리
	@GetMapping("/cafe/ajax_comment_list")
	public String commentList(HttpServletRequest request) {
		
		//테스트를 위해 시간 지연 시키기
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		service.moreCommentList(request);
		
		return "cafe/ajax_comment_list";
	}
	
	//새로운 댓글 저장 요청 처리
	@PostMapping("/cafe/comment_insert")
	public String commentInsert(HttpServletRequest request, int comu_num) {
		//새로운 댓글을 저장하는 로직을 수행한다.
		service.saveComment(request);
		//comu_num 은 원글의 글번호이기 때문에 원글 자세히 보기로 다시 리다일렉트 이동된다.
		return "redirect:/cafe/detail?comu_num="+comu_num;
	}	
	
	@GetMapping("/cafe/list")
	public String list(HttpServletRequest request, int num, Model model) {
		//서비스에 HttpServletRequest 객체를 전달해서 응답에 필요한 데이타가 담기도록 하고 
		service.getList(request, model, num);
		//group_num 이라는 파라미터 변수 맵핑
		request.setAttribute("num", num);
		//view page 로 forward 이동해서 응답하기 
		return "cafe/list";
	}
	
	@GetMapping("/cafe/insertform")
	public String insertform(HttpServletRequest request,int num, Model model) {
		request.setAttribute("num", num);
		return "cafe/insertform";
	}
	
	@PostMapping("/cafe/insert")
	public String insert(CafeDto dto, HttpSession session,HttpServletRequest request) {
		//글 작성자는 세션에서 얻어낸다.
		String writer=(String)session.getAttribute("id");
		int groupNum = dto.getGroup_num();
		//dto 는 글의 제목과 내용만 있으므로 글작성자는 직접 넣어준다.
		dto.setWriter(writer);
		//서비스를 이용해서 새글을 저장한다. 
		request.setAttribute("group_num", groupNum);
		service.saveContent(dto);
		return "cafe/insert";
	}
	
	@GetMapping("/cafe/detail")
	public String detail(HttpServletRequest request, int comu_num, Model model) {
		//서비스에 HttpServletRequest 객체를 전달해서 응답에 필요한 데이타가 담기도록 하고
		service.getDetail(request, model);
		request.setAttribute("comu_num", comu_num);//서비스에서 받아와야한다 수정예정
		//view page 로 forward 이동해서 응답
		return "cafe/detail";
	}
	@GetMapping("/cafe/delete")
	public String delete(int comu_num, int group_num, HttpServletRequest request) {
		//서비스에 삭제할 글번호와 HttpServletRequest 객체를 전달해서 해당글을 삭제 시키고 
		service.deleteContent(comu_num, request);
		//글 목록 보기로 리다일렉트 이동 시킨다.
		return "redirect:/cafe/list?num="+group_num+"";
	}
	
	@GetMapping("/cafe/updateform")
	public String updateForm(HttpServletRequest request,int comu_num,int group_num) {
		service.getData(request);
		request.setAttribute("group_num", group_num);
		return "cafe/updateform";
	}
	
	@PostMapping("/cafe/update")
	public String update(CafeDto dto,HttpServletRequest request) {
		request.setAttribute("comu_num", dto.getComu_num());
		request.setAttribute("group_num", dto.getGroup_num());
		service.updateContent(dto);
		return "cafe/update";
	}	
}
