package com.acorn.soso.group_managing.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group_managing.dao.GroupManagingDao;
import com.acorn.soso.group_managing.dto.GroupManagingDto;

@Service
public class GroupManagingServiceImpl implements GroupManagingService{
	
	@Value("${file.location}")
	private String fileLocation;
	
	@Autowired
	GroupManagingDao dao;
	@Autowired
	GroupManagingDao groupManagingdao;
	
	@Override
	public void getGroupList(String manager_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getGroupList(manager_id);
		request.setAttribute("list", list);
	}
	
	@Override
	public void getFinishedGroupList(String manager_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getFinishedGroupList(manager_id);
		request.setAttribute("list", list);
	}
	
	@Override
	public void getAllGroupList(String manager_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getAllGroupList(manager_id);
		request.setAttribute("list", list);
	}
	
	@Override
	public GroupDto getGroupData(int num, HttpServletRequest request) {
		GroupDto dto = dao.getGroupData(num);
		request.setAttribute("dto", dto);
		return dto;
	}
	
	@Override
	public Map<String, Object> saveGroupImage(HttpServletRequest request, MultipartFile image) {
		  //원본 파일명
	      String orgFileName=image.getOriginalFilename();
	      
	      //절대로 중복되지 않는 유일한 파일명을 구성한다.
	      String saveFileName=UUID.randomUUID().toString()+orgFileName;
	      // 파일을 저장할 폴더까지의 실제경로
	      String realPath=fileLocation;
	      // upload 폴더가 존재하지 않을경우 만들기 위한 File 객체 생성
	      File upload=new File(realPath);
	      if(!upload.exists()) {//만일 존재 하지 않으면
	         upload.mkdir(); //만들어준다.
	      }
	      try {
	         //파일을 저장할 전체 경로를 구성한다.  
	         String savePath=realPath+File.separator+saveFileName;
	         //임시폴더에 업로드된 파일을 원하는 파일을 저장할 경로에 전송한다.
	         image.transferTo(new File(savePath));
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      
	      // json 문자열을 출력하기 위한 Map 객체 생성하고 정보 담기 
	      Map<String, Object> map=new HashMap<String, Object>();
	      map.put("imagePath", "/group/images/"+saveFileName);
	      
	      return map;
	}
	
	@Override
	public void updateGroupData(GroupDto dto, HttpServletRequest request) {
		dao.updateGroupData(dto);
	}
	
	@Override
	public void deleteGroupData(int num) {
		dao.deleteGroupData(num);
	}
	
	//소모임 가입 신청자 리스트 불러오기
	@Override
	public void getApplicantList(int group_num, HttpServletRequest request) {
		List<GroupManagingDto> list = dao.getApplicantList(group_num);
		request.setAttribute("list", list);
	}
	
	@Override
	public void getRejectedApplicantList(int group_num, HttpServletRequest request) {
		List<GroupManagingDto> list = dao.getRejectedApplicantList(group_num);
		request.setAttribute("list", list);
	}	

	@Override
	public void joinApprove(int num, int group_num) {
		dao.joinApprove(num);
		int memberCount = dao.getMemberCount(group_num);
		GroupDto dto = new GroupDto();
		dto.setNum(group_num);
		dto.setNow_people(memberCount);
		dao.updateNowPeople(dto);
	}

	@Override
	public void getMemberList(int group_num, HttpServletRequest request) {
		List<GroupManagingDto> list = dao.getMemberList(group_num);
		request.setAttribute("list", list);
	}
	
	@Override
	public void getMemberData(int num, HttpServletRequest request) {
		GroupManagingDto dto = dao.getMemberData(num);
		request.setAttribute("dto", dto);
	}
	
	@Override
	public void getKickedMemberList(int group_num, HttpServletRequest request) {
		List<GroupManagingDto> list = dao.getKickedMemberList(group_num);
		request.setAttribute("list", list);
		
	}

	@Override
	public void getMemberCount(int num, HttpServletRequest request) {
		int memberCount = dao.getMemberCount(num);
		request.setAttribute("memberCount", memberCount);
	}

	@Override
	public void kick(int num, int group_num) {
		dao.kick(num);
		int memberCount = dao.getMemberCount(group_num);
		GroupDto dto = new GroupDto();
		dto.setNum(group_num);
		dto.setNow_people(memberCount);
		dao.updateNowPeople(dto);
	}

	@Override
	public void reject(int num) {
		dao.reject(num);
	}

	@Override
	public void dropOut(GroupManagingDto dto) {
		dao.dropOut(dto);
		int group_num = dto.getGroup_num();
		int memberCount = dao.getMemberCount(group_num);
		GroupDto groupDto = new GroupDto();
		groupDto.setNum(group_num);
		groupDto.setNow_people(memberCount);
		dao.updateNowPeople(groupDto);
	}

	@Override
	public void getGroupList2(String user_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getGroupList2(user_id);
		System.out.println(list.size());
		request.setAttribute("list", list);	
	}

	@Override
	public void getFinishedGroupList2(String user_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getFinishedGroupList2(user_id);
		request.setAttribute("list", list);
	}

	@Override
	public void getAllGroupList2(String user_id, HttpServletRequest request) {
		List<GroupDto> list = dao.getAllGroupList2(user_id);
		request.setAttribute("list", list);
	}
	
	@Override
	public void getDetail(ModelAndView mView, int num) {
		GroupDto dto = dao.getGroupData(num);
		mView.addObject("dto", dto);
	}

	@Override
	public List<GroupManagingDto> getMateList(int num) {
		return groupManagingdao.getMateList(num);
	}
	
}
