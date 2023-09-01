package com.acorn.soso.group.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group.dto.GroupFAQDto;
import com.acorn.soso.group.dto.GroupReviewDto;
import com.acorn.soso.group.service.GroupService;
import com.acorn.soso.group_managing.service.GroupManagingService;
import com.acorn.soso.test.dto.BookDto;
import com.acorn.soso.test.service.BookService;

@Controller
public class GroupController {

	@Value("${file.location}")
	private String fileLocation;
	
	@Autowired
	private GroupService service;
	
	@Autowired
	private GroupManagingService managingService;
	
	@Autowired
	private BookService BookService;
	
	
	//소모임의 문의 답변 delete(실제로는 update)
	@GetMapping("/group/answer/delete")
	public String groupAnswerDelete(HttpServletRequest request, int num, int group_num) {
		service.groupAnswerDelete(request, num);
		//param에 가져온 group_num으로 리다일렉트
		return "redirect:/group/group_page?num="+group_num;
	}
	
	//소모임의 문의 답변 update
	@PostMapping("/group/answer/update")
	public String groupAnswerUpdate(HttpServletRequest request, GroupFAQDto dto) {
		service.groupAnswerUpdate(request, dto);
		int num = dto.getGroup_num();
		return "redirect:/group/group_page?num="+num;
	}
	
	//소모임의 문의 답변 updateForm이동
	@GetMapping("/group/answer/updateform")
	public String groupAnswerUpdateForm(HttpServletRequest request, Model model) {
		//getData가져오기
		service.groupFAQGetData(request, model);
		
		return "group/answer/updateform";
	}
	
	//소모임 faq의 답변 insert
	@PostMapping("/group/answer/insert")
	public String groupAnswerInsert(HttpSession session, GroupFAQDto dto) {
		//session을 이용해서 id(관리자의 id)를 넣어준다. 지금은 누구나 답변을 달 수 있지만, 나중에는 소모임 관리자만 달 수 있도록 수정
		String a_writer=(String)session.getAttribute("id");
		dto.setA_writer(a_writer);
		//service를 통해 insert를 해준다.
		service.groupAnswerInsert(dto);
		int num = dto.getGroup_num();
		
		return "redirect:/group/group_page?num="+num;
	}
	
	//소모임 FAQ의 답변 INSERTFORM으로
	@GetMapping("/group/answer/insertform")
	public String groupAnswerInsertForm(HttpServletRequest request, Model model){
		
		//서비스를 통해 답변하려는 글의 정보를 insertform에 DTO라는 이름으로 전해준다.
		service.groupFAQGetData(request, model);
		return "group/answer/insertform";		
	}
	
	//소모임 FAQ의 Update
	@PostMapping("/group/faq/update")
	public String groupFaqUpdate(HttpServletRequest request, GroupFAQDto dto) {
		service.updateGroupFAQ(request, dto);
		int num = dto.getGroup_num();
		return "redirect:/group/group_page?num="+num;
	}
	
	//소모임 FAQ의 updateform
	@GetMapping("/group/faq/updateform")
	public String groupFaqUpdateForm(HttpServletRequest request, Model model) {
		service.groupFAQGetData(request, model);
		return "group/faq/updateform";
	}
	
	//소모임 FAQ문의 delete문
	@GetMapping("/group/faq/delete")
	public String groupFaqDelete(HttpServletRequest request, int num, int group_num) {
		service.deleteGroupFAQ(request, num);
		//여기에서 num은 게시글 번호이기 때문에 제대로 리다일렉트가 안 된다. 서비스에서 값을 담아온다;
		return "redirect:/group/group_page?num="+group_num;
	}	
	
	//소모임 FAQ문의 insert
	@PostMapping("/group/faq/insert")
	public String groupFaqInsert(HttpSession session, GroupFAQDto dto) {
		String writer=(String)session.getAttribute("id");
		//id 값만 넣어준다.
		dto.setQ_writer(writer);
		service.groupFAQInsert(dto);
		//dto에 담겨있는 group_num의 값으로 리다일렉트
		int num = dto.getGroup_num();
		return "redirect:/group/group_page?num="+num;
	}
	
	//소모임FAQ문의 insertform
	@GetMapping("/group/faq/insertform")
	public String groupFaqInsertForm(HttpServletRequest request, int num) {
		request.setAttribute("num", num);
		return "group/faq/insertform";
	}
	
	//소모임 FAQ 게시판 목록을 보기 위한 컨트롤러
	@GetMapping("/group/faq/paginglist")
	public String groupFaqPagingList(HttpServletRequest request, int num, Model model) {
		request.setAttribute("num", num);
		service.groupFAQGetList(request, model);
		//View 페이지에 소모임의 정보를 얻어온다(manager_id를 얻기 위함)
		managingService.getGroupData(num, request);
		return "group/faq/paginglist";
	}
	
	//소모임 FAQ 게시판 목록을 보기 위한 컨트롤러
	@GetMapping("/group/faq/list")
	public String groupFaqList(HttpServletRequest request, int num, Model model) {
		request.setAttribute("num", num);
		service.groupFAQGetList(request, model);
		//View 페이지에 소모임의 정보를 얻어온다(manager_id를 얻기 위함)
		managingService.getGroupData(num, request);
		return "group/faq/list";
	}
	
	//찜기능 목록 불러오기 위한 컨트롤러
	@GetMapping("/group/jjim_list")
	public String jjimList(HttpServletRequest request) {
		//찜 목록을 불러오기 위한 서비스
		service.getJjimList(request);
		//찜 리스트로 간다
		return "group/jjim_list";
	}

	//가입 신청 취소를 위한 컨트롤러
	@ResponseBody
	@GetMapping("/group/cancleJoin")
	public Map<String, Object> cancleJoin(HttpServletRequest request){
		boolean isSuccess = service.cancleJoin(request);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isSuccess", isSuccess);
		return map;
	}
	
	//찜기능을 위한 컨트롤러
	//ajax를 위해 responseBody를 해준다.
	@ResponseBody
	@GetMapping("/group/jjim")
	public Map<String, Object> jjim(HttpServletRequest request) {
		boolean isSuccess = service.jjim(request); // 서비스 메서드의 리턴 값을 받아옴
		int jjimCount = service.jjimCount(request);//서비스 메소드의 리턴 값을 받아옴
		//responseBody가 애초에 json문자열을 돌려주겠다는 거니 그걸 통보해야한다.
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isSuccess", isSuccess);
		map.put("jjimCount", jjimCount);
		return map;
	}
		
	//리뷰 수정 요청 처리(json)
	@RequestMapping("/group/review_update")
	@ResponseBody
	public Map<String, Object> reviewUpdate(GroupReviewDto dto){
		service.updateReview(dto);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isSuccess", true);
		return map;
	}
	
	//소모임 가입 신청
	@PostMapping("/group/join")
	//num값을 가져오기 위한 request
	//정보를 담기 위한 model
	public String join(HttpServletRequest request) {
		service.joinGroup(request);
		//num을 얻어와
		int num = Integer.parseInt(request.getParameter("num"));
		//insert하면 리다일렉트->나중에 호출한 곳으로 돌아가는 로직 구상
		return "redirect:/group/group_page?num="+num;
	}
	
	//group페이지 불러오면서 후기글 불러오기 위한 service 호출
	@GetMapping("/group/group_page")
	public String group_page(HttpServletRequest request, Model model) {
		service.getDetail(request, model);
		//request영역의 값으로 groupNum 가져오기 
		int num = Integer.parseInt(request.getParameter("num"));
		//groupManaging Service에서 정보 가져오기
		managingService.getGroupData(num, request);
		//소모임의 후기 글을 가져온다.
		service.reviewList(request, model);
		//소모임에 가입된 멤버 리스트를 가져온다.
		int group_num = Integer.parseInt(request.getParameter("num"));
		managingService.getMemberList(group_num, request);
		
		//로그인 여부를 토대로 서비스 실행 여부를 정한다.
		String id =(String)request.getSession().getAttribute("id");
		if(id != null) {
			//소모임의 찜 여부를 가져온다.
			service.knowjjim(request);
			//소모임의 가입 신청 여부를 가져온다.
			service.knowJoin(request);		
		}
		
		//책 DB에 저장을 바탕으로 책 리스트를 출력한다.
		List<BookDto> bookList = new ArrayList<BookDto>();
		BookService.bookList(group_num, model);
		
		model.addAttribute("jjimCount", service.jjimCount(request));
		return "group/group_page";

	}
	
	@GetMapping("/group/group_in")
	public String groupIn(HttpServletRequest request, int num) {
		request.setAttribute("num", num);
		return "group/group_in";
	}
	
	//리뷰 삭제
	@RequestMapping("/group/review_delete")
	@ResponseBody
	public Map<String, Object> reviewDelete(HttpServletRequest request){
		service.deleteReview(request);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isSuccess", true);
		return map;
	}
	//댓글 더보기
	@RequestMapping("/group/ajax_review_list")
	public String reviewList(HttpServletRequest request) {
		try {
			Thread.sleep(1000);
		}catch(InterruptedException e) {
			e.printStackTrace();
		}
		service.moreReview(request);
		return "group/ajax_review_list";
	}
	//새로운 댓글 저장 요청 처리
	@RequestMapping("group/comment/review_insert")
	public String reviewInsert(GroupReviewDto dto, HttpSession session) {
		//GroupReviewDtos는 필드값과 같은 파라미터를 알아서 가져온다.
		service.saveReview(dto, session);
		int num = dto.getGroup_num();
		return "redirect:/group/group_page?num="+num;
	}
	//코멘트 등록하기
	@GetMapping("/group/comment/comment_insert_form")
	public String commentInsertForm(HttpServletRequest request, int num) {
		request.setAttribute("num", num);
		return "group/comment/comment_insert_form";
	}
	
	//소모임 추가하기
	@PostMapping("/group/insert")
	public String insert(GroupDto dto, HttpServletRequest request, HttpSession session) {
		service.insert(dto, request, session);
		
		return "redirect:/group_managing/admin_main";
	}
	
	//delete
	@RequestMapping("/group/delete")
	public String delete(int num) {
		service.delete(num);
		return "redirect:/group/list";
	}
	//update
	@RequestMapping("/group/update")
	public String update(GroupDto dto, HttpServletRequest request) {
		service.update(dto, request);
		return "redirect:/group/list";
		
	}
	
	//updateform 이동
	@RequestMapping("/group/update_form")
	public String uploadform(HttpServletRequest request) {
		service.getData(request);
		return "group/update_form";
	}
	
	//detail 페이지
	@GetMapping("/group/detail")
	public String detail(HttpServletRequest request, Model model) {
		service.getDetail(request, model);		
		return "group/detail";

	}
	
	//사진 업로드 & DB 저장
	@RequestMapping(method = RequestMethod.POST, value = "/group/upload")
	public String upload(GroupDto dto, HttpServletRequest request) {
		service.saveImage(dto, request);
		return "redirect:/group/list";
	}
	
	//갤러리 form 페이지 이동
	@RequestMapping("/group/upload_form")
	public String upload_form() {
		return "group/upload_form";
	}


	//소모임 리스트 이동
	@GetMapping("/group/list")
	public String list(HttpServletRequest request, Model model) {
		String genreParam = request.getParameter("genre");
		int genre = Integer.parseInt(genreParam);
        if (genre == -1) {//가져온 값이 -1이면 전체 배열을 출력
            service.getList(request,model);
        } else {//아니면 가져온 숫자만큼의 배열을 출
        	service.getGroupsByGenre(request,model);
        }
        return "group/list";
	}
	
	//ajax로 리스트 페이지 불러오기
	@GetMapping("/group/ajax_list")
	public String listajax(HttpServletRequest request, Model model) {
		String genreParam = request.getParameter("genre");
		int genre = Integer.parseInt(genreParam);
        if (genre == -1) {//가져온 값이 -1이면 전체 배열을 출력
            service.getList(request, model);
        } else {//아니면 가져온 숫자만큼의 배열을 출
            service.getGroupsByGenre(request, model);
        }
        return "group/ajax_list";
	}
	
	//ajax로 리스트 페이지 불러오기
	@GetMapping("/group/ajax_viewList")
	public String viewlistajax(HttpServletRequest request, Model model) {

            service.getViewList(request, model);

        return "group/ajax_viewList";
	}
	
	//소모임 조회수 리스트 이동
	@GetMapping("/group/viewList")
	public String viewList(HttpServletRequest request, Model model) {

        	service.getViewList(request, model);
	
		return "group/viewList";
	}
	
	
	//랭킹 리스트 이동
	@RequestMapping("/ranking/list")
	public String Rankinglist(HttpServletRequest request, Model model) {
		service.getRanking(request, model );
		return "ranking/list";
	}
	
	//메인 페이지로 이동
	@RequestMapping("/")
	public String home(HttpServletRequest request, Model model) {
		service.getRanking(request, model);
		return "home";
	}
	
	
}