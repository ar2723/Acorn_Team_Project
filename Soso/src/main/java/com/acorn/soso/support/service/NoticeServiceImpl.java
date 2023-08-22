package com.acorn.soso.support.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.acorn.soso.support.dao.NoticeDao;
import com.acorn.soso.support.dto.NoticeDto;

@Service
public class NoticeServiceImpl implements NoticeService {
	@Autowired
	private NoticeDao noticeDao;

	@Override
	public void getList(HttpServletRequest request, Model model) {
		//한 페이지에 몇개씩 표시할 것인지
		final int PAGE_ROW_COUNT=5;
		//하단 페이지를 몇개씩 표시할 것인지
		final int PAGE_DISPLAY_COUNT=5;
		
		//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
		int pageNum=1;
		//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
		String strPageNum=request.getParameter("pageNum");
		//만일 페이지 번호가 파라미터로 넘어 온다면
		if(strPageNum != null){
			//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
			pageNum=Integer.parseInt(strPageNum);
		}
		
		//보여줄 페이지의 시작 ROWNUM
		int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
		//보여줄 페이지의 끝 ROWNUM
		int endRowNum=pageNum*PAGE_ROW_COUNT;
			
		//NoticeDto 객체에 startRowNum 과 endRowNum 을 담는다.
		NoticeDto dto=new NoticeDto();
		dto.setStartRowNum(startRowNum);
		dto.setEndRowNum(endRowNum);

		//공지사항 목록 얻어오기 
		List<NoticeDto> notice_list=noticeDao.getList(dto);
		//전체질문의 갯수
		int totalRow=noticeDao.getCount(dto);
		
		//하단 시작 페이지 번호 
		int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
		//하단 끝 페이지 번호
		int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
		

		//전체 페이지의 갯수
		int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
		//끝 페이지 번호가 전체 페이지 갯수보다 크다면 잘못된 값이다.
		if(endPageNum > totalPageCount){
			endPageNum=totalPageCount; //보정해 준다.
		}
		//view page 에서 필요한 값을 Model 에 담아준다. 
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("startPageNum", startPageNum);
		model.addAttribute("endPageNum", endPageNum);
		model.addAttribute("totalPageCount", totalPageCount);
		model.addAttribute("notice_list", notice_list);
		model.addAttribute("totalRow", totalRow);
		
	}

	@Override
	public NoticeDto getData(int notice_num, Model model) {
		NoticeDto dto = noticeDao.getData(notice_num);
		model.addAttribute("dto", dto);
		return dto;
	}

	@Override
	public void saveNotice(NoticeDto dto) {
		noticeDao.insert(dto);
		
	}

	@Override
	public void updateNotice(NoticeDto dto) {
		noticeDao.update(dto);
		
	}

	@Override
	public void deleteNotice(int notice_num, Model model) {
		noticeDao.delete(notice_num);
	}

}
