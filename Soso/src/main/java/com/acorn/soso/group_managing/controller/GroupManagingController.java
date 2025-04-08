package com.acorn.soso.group_managing.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.acorn.soso.cafe.service.CafeService;
import com.acorn.soso.exception.DontEqualException;
import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group.service.GroupService;
import com.acorn.soso.group_managing.dao.GroupManagingDao;
import com.acorn.soso.group_managing.dto.GroupManagingDto;
import com.acorn.soso.group_managing.service.GroupManagingService;

@Controller
public class GroupManagingController {
	
	@Value("${file.location}")
	private String fileLocation;
	
	@Autowired
	GroupManagingService service;
	@Autowired
	private CafeService cafeService;
	@Autowired
	private GroupManagingService groupManagingService;
	
	@GetMapping("/group_managing/admin_main")
	public String admin_main(HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		service.getGroupList(manager_id, request);
		return "group_managing/admin_main";
	}
	
	@GetMapping("/group_managing/admin_main_finished")
	public String admin_main_finished(HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		service.getFinishedGroupList(manager_id, request);
		return "group_managing/admin_main_finished";
	}
	
	@GetMapping("/group_managing/admin_main_all")
	public String admin_main_all(HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		service.getAllGroupList(manager_id, request);
		return "group_managing/admin_main_all";
	}
	
	@GetMapping("/group_managing/joinApprove")
	public String joinApprove(int num, int group_num, String user_id, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(group_num, request);
		//get 요청 방식에서 파라미터 값 조정으로 다른 소모임에 대한 접근을 방지
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임 가입 신청자에 대해 접근할 수 없습니다!");
		}
		//현재 소모임의 정원이 다찼을 경우에 가입 승인을 거절
		if(dto.getNow_people() == dto.getMax_people()) {
			request.setAttribute("group_num", group_num);
			return "group_managing/joinApproveRejected";
		} else {
			service.joinApprove(num, group_num);
			request.setAttribute("group_num", group_num);
			return "group_managing/joinApprove";
		}
	}
	
	@GetMapping("/group_managing/user_main")
	public String user_main(HttpServletRequest request, HttpSession session) {
		String user_id = (String)session.getAttribute("id");
		service.getGroupList2(user_id, request);
		return "group_managing/user_main";
	}
	
	@GetMapping("/group_managing/user_main_finished")
	public String user_main_finished(HttpServletRequest request, HttpSession session) {
		String user_id = (String)session.getAttribute("id");
		service.getFinishedGroupList2(user_id, request);
		return "group_managing/user_main_finished";
	}
	
	@GetMapping("/group_managing/user_main_all")
	public String user_main_all(HttpServletRequest request, HttpSession session) {
		String user_id = (String)session.getAttribute("id");
		service.getAllGroupList2(user_id, request);
		return "group_managing/user_main_all";
	}
	
	@GetMapping("/group_managing/group_insertForm")
	public String group_insertForm() {
		return "group_managing/group_insertForm";
	}
	
	@GetMapping("/group_managing/group_updateForm")
	public String group_updateForm(int num, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(num, request);
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 정보를 불러올 수 없습니다!");
		}
		return "group_managing/group_updateForm";
	}
	
	//ajax 프로필 사진 업로드 요청처리
	@PostMapping("/group_managing/image_upload")
	@ResponseBody
	public Map<String, Object> ImageUpload(HttpServletRequest request, MultipartFile image){
		//서비스를 이용해서 이미지를 upload 폴더에 저장하고 리턴되는 Map을 리턴해서 json 문자열 응답하기
		return service.saveGroupImage(request, image);
	};
	
	@GetMapping(
			value = "/group/images/{imageName}",
			produces = {MediaType.IMAGE_GIF_VALUE,  MediaType.IMAGE_PNG_VALUE, 
					MediaType.IMAGE_JPEG_VALUE,}
	)
	@ResponseBody
	public byte[] groupImage(@PathVariable("imageName") String imageName) throws IOException {
		String absolutePath = fileLocation + File.separator + imageName;
		// 파일에서 읽어들일 InputStream
		InputStream is = new FileInputStream(absolutePath);
		// 이미지 데이터 (byte)를 읽어서 배열에 담아서 클라이언트에게 응답한다.
		return IOUtils.toByteArray(is);
	}	
	
	@PostMapping("/group_managing/group_update")
	public String group_update(GroupDto dto, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto data = service.getGroupData(dto.getNum(), request);
		if(!data.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 정보를 수정할 수 없습니다!");
		}
		service.updateGroupData(dto, request);
		return "redirect:/group_managing/admin_main";
	}
	
	@GetMapping("/group_managing/group_delete")
	public String group_delete(int num, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(num, request);
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 정보를 삭제할 수 없습니다!");
		} 
		service.deleteGroupData(num);
		return "redirect:/group_managing/admin_main";
	}
	
	// 소모임 관리 detail 페이지( 로그인된 user가 가입된 리스트에 관한 )
	// 해당 소모임에 가입된 user 리스트 불러오기
	@GetMapping("/group_managing/group_userdetail")
	public ModelAndView detail(ModelAndView mView, int num, GroupDto dto, HttpSession session, HttpServletRequest request, Model model) {
	    service.getDetail(mView, num);
	    String user_id = (String)session.getAttribute("id");
		dto.setUser_id(user_id);
	    mView.setViewName("group_managing/group_userdetail");
	    cafeService.getList(request, model, num);
        // 가입된 유저 리스트 가져와서 모델에 추가
	    int group_num = num;
        List<GroupManagingDto> mateList = groupManagingService.getMateList(group_num);
        request.setAttribute("mateList", mateList);
	    request.setAttribute("num", num);
	    return mView;
	}


	@GetMapping("/group_managing/applicantList")
	public String group_applicantList(int group_num, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(group_num, request);
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 가입자 정보를 불러올 수 없습니다!");
		}
		service.getApplicantList(group_num, request);
		request.setAttribute("dto", dto);
		request.setAttribute("group_num", group_num);
		return "group_managing/applicantList";
	}
	
	@GetMapping("/group_managing/memberList")
	public String group_memberList(int group_num, HttpServletRequest request) {
		service.getMemberList(group_num, request);
		GroupDto dto = service.getGroupData(group_num, request);
		request.setAttribute("dto", dto);
		request.setAttribute("group_num", group_num);
		return "group_managing/memberList";
	}
	
	@GetMapping("/group_managing/kickedMemberList")
	public String group_kickedMemberList(int group_num, HttpServletRequest request) {
		service.getKickedMemberList(group_num, request);
		GroupDto dto = service.getGroupData(group_num, request);
		request.setAttribute("dto", dto);
		request.setAttribute("group_num", group_num);
		return "group_managing/kickedMemberList";
	}
	
	@GetMapping("/group_managing/rejectedApplicantList")
	public String group_rejectedApplicantList(int group_num, HttpServletRequest request) {
		service.getRejectedApplicantList(group_num, request);
		GroupDto dto = service.getGroupData(group_num, request);
		request.setAttribute("dto", dto);
		request.setAttribute("group_num", group_num);
		return "group_managing/rejectedApplicantList";
	}
	
	@GetMapping("/group_managing/kick")
	public String kick(int num, int group_num, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(group_num, request);
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 가입자에 대해 접근할 수 없습니다!");
		}
		service.kick(num, group_num);
		return "redirect:/group_managing/memberList?group_num=" + group_num;
	}
	
	@GetMapping("/group_managing/reject")
	public String reject(int num, int group_num, HttpServletRequest request, HttpSession session) {
		String manager_id = (String)session.getAttribute("id");
		GroupDto dto = service.getGroupData(group_num, request);
		if(!dto.getManager_id().equals(manager_id)) {
			throw new DontEqualException("개설하지 않은 소모임의 가입 신청자에 대해 접근할 수 없습니다!");
		}
		service.reject(num);
		return "redirect:/group_managing/applicantList?group_num=" + group_num;
	}
	
	@GetMapping("/group_managing/group_userdropOut") 
	public String dropOut(GroupManagingDto dto, HttpSession session) {  
		String user_id = (String)session.getAttribute("id");
		dto.setUser_id(user_id);
		service.dropOut(dto);
		return "redirect:/group_managing/user_main";
	}
}
