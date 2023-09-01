package com.acorn.soso.group.service;

import java.io.File;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import com.acorn.soso.exception.DontEqualException;
import com.acorn.soso.exception.NotDeleteException;
import com.acorn.soso.group.dao.GroupDao;
import com.acorn.soso.group.dao.GroupFAQDao;
import com.acorn.soso.group.dao.GroupJoinDao;
import com.acorn.soso.group.dao.GroupReviewDao;
import com.acorn.soso.group.dao.JjimDao;
import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group.dto.GroupFAQDto;
import com.acorn.soso.group.dto.GroupJoinDto;
import com.acorn.soso.group.dto.GroupReviewDto;
import com.acorn.soso.group.dto.JjimDto;
import com.acorn.soso.group_managing.dao.GroupManagingDao;
import com.acorn.soso.test.dao.BookDao;
import com.acorn.soso.test.dto.BookDto;


@Service
public class GroupServiceImpl implements GroupService{
	
	@Value("${file.location}")
	private String fileLocation;
	
	@Autowired
	private GroupDao dao;
	
	@Autowired
	private GroupReviewDao reviewdao;
	
	@Autowired
	private GroupJoinDao joindao;
	
	@Autowired
	private JjimDao jjimdao;

	@Autowired
	private GroupFAQDao groupfaqdao;	
	
	//그룹의 데이터를 얻어오기 위한 Autowired
	@Autowired
	private GroupManagingDao managingdao;
	
	@Autowired
	private BookDao bookdao;
	
	@Override
	public void getList(HttpServletRequest request, Model model) {
		//한 페이지에 몇개씩 표시할 것인지
		final int PAGE_ROW_COUNT=8;
		//하단 페이지를 몇개씩 표시할 것인지
		final int PAGE_DISPLAY_COUNT=5;
	      
		//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
		int pageNum=1;
		//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
		String strPageNum = request.getParameter("pageNum");
		//만일 페이지 번호가 파라미터로 넘어 온다면
		if(strPageNum != null){
			//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
			pageNum=Integer.parseInt(strPageNum);
		}
	      
		//보여줄 페이지의 시작 ROWNUM
		int startRowNum = 1 + (pageNum-1) * PAGE_ROW_COUNT;
		//보여줄 페이지의 끝 ROWNUM
		int endRowNum = pageNum * PAGE_ROW_COUNT;
	      
		int genre = Integer.parseInt(request.getParameter("genre"));
		String keyword=request.getParameter("keyword");
		String condition=request.getParameter("condition");
		if(keyword==null) {
			keyword="";
		   	condition="";
		}
		String encodedK=URLEncoder.encode(keyword);
	    GroupDto dto = new GroupDto();
	    dto.setStartRowNum(startRowNum);
	    dto.setEndRowNum(endRowNum);
	      
	      

		if(!keyword.equals("")) {
			if(condition.equals("name_caption")) {
		    	dto.setName(keyword);
		    	dto.setCaption(keyword);
		    	}else if(condition.equals("name")) {
		    		dto.setName(keyword);
		    	}else if(condition.equals("writer")) {
		    		dto.setManager_id(keyword);
		    	}
		    }
	      

	      List<GroupDto> list = dao.getList(dto);
	      	//전체글의 갯수
			int totalRow=dao.getCount(dto);
			
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

	      	      
	      //request 영역에 담아주기
	      model.addAttribute("list", list);   //소모임 list
	      model.addAttribute("keyword", keyword);
	      model.addAttribute("encodedK", encodedK);
	      model.addAttribute("condition", condition);
	      model.addAttribute("pageNum", pageNum);
	      model.addAttribute("startPageNum", startPageNum);
	      model.addAttribute("endPageNum", endPageNum);
	      model.addAttribute("totalPageCount", totalPageCount);
	      model.addAttribute("totalRow", totalRow);
	      model.addAttribute("genre", genre);
	}
	
	@Override
    public void getGroupsByGenre(HttpServletRequest request, Model model) {
        final int PAGE_ROW_COUNT = 8;
        final int PAGE_DISPLAY_COUNT = 5;

        int pageNum = 1;
        String strPageNum = request.getParameter("pageNum");
        if (strPageNum != null) {
            pageNum = Integer.parseInt(strPageNum);
        }

        int genre = Integer.parseInt(request.getParameter("genre"));
        String keyword=request.getParameter("keyword");
		String condition=request.getParameter("condition");
		if(keyword==null) {
			keyword="";
		   	condition="";
		}
        String encodedK = URLEncoder.encode(keyword);

        GroupDto dto = new GroupDto();
        dto.setStartRowNum((pageNum - 1) * PAGE_ROW_COUNT + 1);
        dto.setEndRowNum(pageNum * PAGE_ROW_COUNT);

        if (!keyword.equals("")) {
            if (condition.equals("name_caption")) {
                dto.setName(keyword);
                dto.setCaption(keyword);
            } else if (condition.equals("name")) {
                dto.setName(keyword);
            } else if (condition.equals("writer")) {
                dto.setManager_id(keyword);
            }
        }

        List<GroupDto> list = dao.getGroupsByGenreAndSearch(genre, dto);

        int totalRow = dao.getCount(dto);

        int startPageNum = 1 + ((pageNum - 1) / PAGE_DISPLAY_COUNT) * PAGE_DISPLAY_COUNT;
        int endPageNum = startPageNum + PAGE_DISPLAY_COUNT - 1;

        int totalPageCount = (int) Math.ceil(totalRow / (double) PAGE_ROW_COUNT);
        if (endPageNum > totalPageCount) {
            endPageNum = totalPageCount;
        }

        model.addAttribute("list", list);
        model.addAttribute("keyword", keyword);
        model.addAttribute("encodedK", encodedK);
        model.addAttribute("condition", condition);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("startPageNum", startPageNum);
        model.addAttribute("endPageNum", endPageNum);
        model.addAttribute("totalPageCount", totalPageCount);
        model.addAttribute("totalRow", totalRow);
        model.addAttribute("genre", genre);
    }

	@Override
	public void saveImage(GroupDto dto, HttpServletRequest request) {
		
		//title이 같으면 exception발생시키기
		//getNum이 아직 부여되지 않아서 없음ㅇㅇ
		//getData를 하나 더 만들어야겠다
		//resultDto가 null이면 500발생한다(신규추가가 안됨)
		GroupDto resultDto = dao.getData(dto.getName());
		if(resultDto != null) {
			String title = resultDto.getName();
			if(title.equals(dto.getName())) {
				throw new DontEqualException("같은 소모임이 이미 존재합니다.");
			}
		}
		
		//업로드된 파일의 정보를 가지고 있는 MultipartFile 객체의 참조값을 얻어오기
		MultipartFile image = dto.getImage();
		//원본 파일명 -> 저장할 파일 이름 만들기위해서 사용됨
		String orgFileName = image.getOriginalFilename();
		//파일 크기 -> 다운로드가 없으므로, 여기서는 필요 없다.
  		long fileSize = image.getSize();
	      
	      // webapp/upload 폴더 까지의 실제 경로(서버의 파일 시스템 상에서의 경로)
	      String realPath = fileLocation;
	      //db 에 저장할 저장할 파일의 상세 경로
	      String filePath = realPath + File.separator;
	      //디렉토리를 만들 파일 객체 생성
	      File upload = new File(filePath);
	      if(!upload.exists()) {
	         //만약 디렉토리가 존재하지X
	         upload.mkdir();//폴더 생성
	      }
	      //저장할 파일의 이름을 구성한다. -> 우리가 직접 구성해줘야한다.
	      String saveFileName = System.currentTimeMillis() + orgFileName;
	      
	      try {
	         //upload 폴더에 파일을 저장한다.
	         image.transferTo(new File(filePath + saveFileName));
	         System.out.println();   //임시 출력
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      
	      //dto 에 업로드된 파일의 정보를 담는다.
	      //-> parameer 로 넘어온 dto 에는 caption, image 가 들어 있었다.
	      //-> 추가할 것 : writer(id), imagePath 만 추가로 담아주면 된다.
	      //-> num, regdate : db 에 추가하면서 자동으로 들어감
	      String id = (String)request.getSession().getAttribute("id");
	      dto.setManager_id(id);
	      dto.setImg_path("/group/images/" + saveFileName);
	      
	      //MovieDao 를 이용해서 DB 에 저장하기
	      dao.insert(dto);	
	      
	}

	@Override
	public void getDetail(HttpServletRequest request, Model model) {
		int num = Integer.parseInt(request.getParameter("num")); 
	    //조회수 올리기
		dao.addViewCount(num);
		LocalDateTime now = LocalDateTime.now();
	}
	
	//소모임 개설	
	@Override
	public void insert(GroupDto dto, HttpServletRequest request, HttpSession session) {
		//업로드된 파일의 정보를 가지고 있는 MultipartFile 객체의 참조값을 얻어오기
		MultipartFile image = dto.getImage();
		//원본 파일명 -> 저장할 파일 이름 만들기위해서 사용됨
		String orgFileName = image.getOriginalFilename();
		// webapp/upload 폴더 까지의 실제 경로(서버의 파일 시스템 상에서의 경로)
		String realPath = fileLocation;
		//db 에 저장할 저장할 파일의 상세 경로
		String filePath = realPath + File.separator;
		//디렉토리를 만들 파일 객체 생성
		File upload = new File(filePath);
		if(!upload.exists()) {
			//만약 디렉토리가 존재하지X
			upload.mkdir();//폴더 생성
		}
		//저장할 파일의 이름을 구성한다. -> 우리가 직접 구성해줘야한다.
		String saveFileName = System.currentTimeMillis() + orgFileName;
	      
		try {
			//기존 파일이 존재하면 삭제
			File existingFile = new File(filePath + saveFileName);
			if(existingFile.exists()) {
				existingFile.delete();
			}
			//upload 폴더에 파일을 저장한다.
			image.transferTo(new File(filePath + saveFileName));
			System.out.println();   //임시 출력
		}catch(Exception e) {
	         e.printStackTrace();
		}
		dto.setImg_path("/group/images/" + saveFileName);
		String manager_id = (String)session.getAttribute("id");
		
		dto.setManager_id(manager_id);
		
		//group_num의 시퀀스 값을 얻어낸다.
		int num = dao.groupNumSeq();
		//dto에 넣어줌
		dto.setNum(num);
		
		dao.insert(dto);

	}

	@Override
	public void update(GroupDto dto, HttpServletRequest request) {
		 GroupDto resultDto = dao.getData(dto.getNum());
		 if(resultDto != null) {
			 String title = resultDto.getName();
			 if(title.equals(dto.getName())) {
			 throw new DontEqualException("같은 소모임이 이미 존재합니다.");
			 }
		 }
		
		 //업로드된 파일의 정보를 가지고 있는 MultipartFile 객체의 참조값을 얻어오기
	      MultipartFile image = dto.getImage();
	      //원본 파일명 -> 저장할 파일 이름 만들기위해서 사용됨
	      String orgFileName = image.getOriginalFilename();
	      // webapp/upload 폴더 까지의 실제 경로(서버의 파일 시스템 상에서의 경로)
	      String realPath = fileLocation;
	      //db 에 저장할 저장할 파일의 상세 경로
	      String filePath = realPath + File.separator;
	      //디렉토리를 만들 파일 객체 생성
	      File upload = new File(filePath);
	      if(!upload.exists()) {
	         //만약 디렉토리가 존재하지X
	         upload.mkdir();//폴더 생성
	      }
	      //저장할 파일의 이름을 구성한다. -> 우리가 직접 구성해줘야한다.
	      String saveFileName = System.currentTimeMillis() + orgFileName;
	      
	      try {
	    	 //기존 파일이 존재하면 삭제
	    	 File existingFile = new File(filePath + saveFileName);
	    	 if(existingFile.exists()) {
	    		 existingFile.delete();
	    	 }
	         //upload 폴더에 파일을 저장한다.
	         image.transferTo(new File(filePath + saveFileName));
	         System.out.println();   //임시 출력
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      
	      //dto 에 업로드된 파일의 정보를 담는다.
	      //-> parameter 로 넘어온 dto 에는 caption, image 가 들어 있었다.
	      //-> 추가할 것 : imagePath 만 추가로 담아주면 된다.
	      //-> num, title, caption : db 에 추가하면서 자동으로 들어감
	      //imagePath 만 저장해주면 됨
	     dto.setImg_path("/group/images/" + saveFileName);
		dao.update(dto);
	}

	@Override
	public void delete(int num) {
		dao.delete(num);
	}

	@Override
	public void saveReview(GroupReviewDto dto, HttpSession session) {
		//dto를 통해 가져온 값은 rate, content, group_num 이다.
		//writer, review_num만 채워주면 된다.
		//session 영역의 id를 가져온다.
		String writer = (String)session.getAttribute("id");
		dto.setWriter(writer);
		
		//seq-> 가져와서 세팅
		int seq = reviewdao.getSequence();
		dto.setReview_num(seq);
		
		//동일작성 아이디검토
		GroupReviewDto resultDto = reviewdao.getEqual(dto);
		//만약 존재한다면
		if(resultDto != null) {
			//exception으로 던지
			throw new DontEqualException("한번만 리뷰 작성할 수 있습니다.");
		}else {
			//null이면 넣는다.
			reviewdao.insert(dto);	
		}
		
	}

	@Override
	public void deleteReview(HttpServletRequest request) {
		String strNum = request.getParameter("num");
		int num = Integer.parseInt(strNum);
		GroupReviewDto dto = reviewdao.getData(num);
		String id = (String)request.getSession().getAttribute("id");
		
		//관리자 삭제를 위해 일단 주석처리
//		if(!dto.getWriter().equals(id)) {
//			throw new NotDeleteException("타인의 리뷰는 삭제할 수 없습니다.");
//		}
		reviewdao.delete(num);
	}

	@Override
	public void updateReview(GroupReviewDto dto) {
		reviewdao.update(dto);
	}

	@Override
	public void moreReview(HttpServletRequest request) {
		//로그인된 아이디
		String id =(String)request.getSession().getAttribute("id");
		//ajax 요청 파라미터로 넘어오는 댓글의 페이지 번호를 읽어낸다.
		int pageNum=Integer.parseInt(request.getParameter("pageNum"));
		//ajax요청 파라미터로 넘어오는 원글의 글 번호를 읽어낸다.
		int num = Integer.parseInt(request.getParameter("num"));
		
	     /*
        	[ 댓글 페이징 처리에 관련된 로직 ]
	     */
	     //한 페이지에 몇개씩 표시할 것인지
	     final int PAGE_ROW_COUNT=10;
	
	     //보여줄 페이지의 시작 ROWNUM
	     int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	     //보여줄 페이지의 끝 ROWNUM
	     int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	     //원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
	     GroupReviewDto reviewDto=new GroupReviewDto();
//	     reviewDto.setRef_group(num);
	     //1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서  
	     reviewDto.setStartRowNum(startRowNum);
	     reviewDto.setEndRowNum(endRowNum);
	
	     //pageNum에 해당하는 댓글 목록만 select 되도록 한다. 
	     List<GroupReviewDto> commentList=reviewdao.getList(reviewDto);
	     //원글의 글번호를 이용해서 댓글 전체의 갯수를 얻어낸다.
	     int totalRow=reviewdao.getCount(num);
	     //댓글 전체 페이지의 갯수
	     int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	
	     //view page 에 필요한 값 request 에 담아주기
	     request.setAttribute("commentList", commentList);
	     request.setAttribute("num", num); //원글의 글번호
	     request.setAttribute("pageNum", pageNum); //댓글의 페이지 번호
	}

	@Override
	public void avgRate(String title) {
		reviewdao.getAvg(title);
		
	}

	@Override
	public void getRanking(HttpServletRequest request , Model model) {

	      GroupDto dto = new GroupDto();
	      
	      //movieDao 객체를 이용해서 회원 목록을 얻어온다.
	      //ranking version
	      List<GroupDto> list = dao.getRanking(dto);
      
	      //request 영역에 담아주기
	      request.setAttribute("list", list);   //movie list
		
	}
	//num을 가져와서 리뷰 리스트를 불러온 다음에 model에 담아서 돌려주기
	@Override
	public void reviewList(HttpServletRequest request, Model model) {
		//request를 통해서 num을 가져온다.
		int num = Integer.parseInt(request.getParameter("num"));
		//revieDto를 이용해서리스트에 담은 다음
		List<GroupReviewDto> list = reviewdao.reviewList(num);
		//request에 담아주기
		model.addAttribute("commentList", list);
	}
	
	//소모임 가입을 위한 join
	@Override
	public void joinGroup(HttpServletRequest request) {
		//request를 통해서 num을 가져온다.(num은 소모임의 번호이다)
		int group_Num = Integer.parseInt(request.getParameter("num"));
		//session 영역에 있는 id를 가져온다.
		String id =(String)request.getSession().getAttribute("id");
		String intro = request.getParameter("intro");
		//DTO를하나 만들어서 form에 담겨온 데이터를 담아온다.
		GroupJoinDto dto = new GroupJoinDto();
		dto.setGroup_Num(group_Num);
		dto.setUser_Id(id);
		dto.setIntro(intro);
		
		//num을 이용해서 가입시키기
		joindao.insert(dto);
		
	}

	//getData로 찜여부 확인하
	@Override
	public void knowjjim(HttpServletRequest request) {
		//num을 통해 groupNum을 알아낸다.
		int group_Num = Integer.parseInt(request.getParameter("num"));
		//session 영역에 있는 id를 알아낸다.
		String user_Id =(String)request.getSession().getAttribute("id");
		//새로운 dto를 만들어서 방금 알아낸 데이터를 담는다.
		JjimDto dto = new JjimDto();
		dto.setGroup_Num(group_Num);
		dto.setUser_Id(user_Id);
		//만들어낸 dto를 가지고 getData작업을 시행하고 resultDto에 담는다.
		JjimDto resultDto = jjimdao.getData(dto);
		
		//request영역에 jjim이라는 이름으로 resultDto를 담는다.
		request.setAttribute("jjim", resultDto);
	}

	@Override
	public boolean jjim(HttpServletRequest request) {
		//num을 통해 groupNum을 알아낸다.
		int group_Num = Integer.parseInt(request.getParameter("num"));
		//session 영역에 있는 id를 알아낸다.
		String user_Id =(String)request.getSession().getAttribute("id");
		//새로운 dto를 만들어서 방금 알아낸 데이터를 담는다.
		JjimDto dto = new JjimDto();
		dto.setUser_Id(user_Id);
		dto.setGroup_Num(group_Num);
		//만들어낸 dto를 가지고 getData작업을 시행하고 resultDto에 담는다.
		JjimDto resultDto = jjimdao.getData(dto);
		//분기로 처리한다.
		if(resultDto == null) {//만약 resultDto가 null이면
			//jjim을 해주고
			jjimdao.insert(dto);
			return true;
		}else {
			//jjim을 해제해주고
			jjimdao.delete(dto);
			return false;
		}
	}

	@Override
	public int jjimCount(HttpServletRequest request) {
		//num을 통해 groupNum을 알아낸다.
		int groupNum = Integer.parseInt(request.getParameter("num"));
		int jjimCount = jjimdao.jjimCount(groupNum);
		return jjimCount;
	}

	@Override
	public void getJjimList(HttpServletRequest request) {
		//session 영역에 있는 id값으로
		String memId =(String)request.getSession().getAttribute("id");
		//memId로 얻어낸 groupDto의 list를 알아낸 다음에
		List<GroupDto> list = jjimdao.jjimList(memId);
        //request 영역에 담아주기
        request.setAttribute("list", list);
	
	}

	@Override
	public void knowJoin(HttpServletRequest request) {
		//num을 통해 groupNum을 알아낸다.
		int num = Integer.parseInt(request.getParameter("num"));
		//session 영역에 있는 id를 알아낸다.
		String id =(String)request.getSession().getAttribute("id");
		//새로운 dto를 만들어서 방금 알아낸 데이터를 담는다.
		GroupJoinDto dto = new GroupJoinDto();
		dto.setGroup_Num(num);
		dto.setUser_Id(id);
		//만들어낸 dto를 가지고 getData작업을 시행하고 resultDto에 담는다.
		//int joinNum의 초기값 설정
		int joinNum = joindao.getIsJoin(dto);
		if(joinNum == 1 || joinNum == 2 || joinNum == 3) {
			//request영역에 jjim이라는 이름으로 resultDto를 담는다.
			request.setAttribute("knowJoin", joinNum);
		}else if(joinNum == -1) {
			request.setAttribute("knowJoin", -1);
		}
		
	}

	@Override
	public boolean cancleJoin(HttpServletRequest request) {
		//num을 통해 groupNum을 알아낸다.
		int num = Integer.parseInt(request.getParameter("num"));
		//session 영역에 있는 id를 알아낸다.
		String id =(String)request.getSession().getAttribute("id");
		//새로운 dto를 만들어서 방금 알아낸 데이터를 담는다.
		GroupJoinDto dto = new GroupJoinDto();
		dto.setGroup_Num(num);
		dto.setUser_Id(id);
		joindao.cancleJoin(dto);		
		return true;
	}
	
	@Override
 	public void getData(HttpServletRequest request) {
 		int num =Integer.parseInt(request.getParameter("num"));
 		GroupDto dto=dao.getData(num);
 		request.setAttribute("dto", dto);
 		
	}
	
	@Override
	public void groupFAQInsert(GroupFAQDto dto) {		
		//dao를 통해 db에 값 집어넣기
		groupfaqdao.insert(dto);
	}
	
	//소모임 FAQ의 getList
	@Override
	public void groupFAQGetList(HttpServletRequest request, Model model) {
		//한 페이지에 몇개씩 표시할 것인지
		final int PAGE_ROW_COUNT=5;
		//하단 페이지를 몇개씩 표시할 것인지
		final int PAGE_DISPLAY_COUNT=10;
		
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
					
		//request영역에 담긴 num 값으로 group_num을 알아낸다.
		int group_num = Integer.parseInt(request.getParameter("num"));
		
		//GroupFAQDto 객체에 startRowNum 과 endRowNum 을 담는다.
		GroupFAQDto dto = new GroupFAQDto();
		dto.setStartRowNum(startRowNum);
		dto.setEndRowNum(endRowNum);
		dto.setGroup_num(group_num);
	
		//글 목록 얻어오기 
		List<GroupFAQDto> list= groupfaqdao.getList(dto);
		//전체글의 갯수
		int totalRow = groupfaqdao.getCount(dto);
		
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
		model.addAttribute("list", list);
		model.addAttribute("totalRow", totalRow);

	}

	//나중에 ajax로 처리할때 필요한 getData
	@Override
	public void groupFAQGetData(HttpServletRequest request, Model model) {
		//자세히 보여줄 글번호를 읽어온다. 
		int num=Integer.parseInt(request.getParameter("num"));
		// GroupFAQDto에 담아주기
		GroupFAQDto dto=new GroupFAQDto();
		//자세히 보여줄 글번호를 넣어준다. 
		dto.setNum(num);
		
		//글하나의 정보를 얻어온다.
		GroupFAQDto resultDto=groupfaqdao.getData(num);
		
		//Model 에 글 하나의 정보 담기
		model.addAttribute("dto", resultDto);
		
	}

	@Override
	public void updateGroupFAQ(HttpServletRequest request, GroupFAQDto dto) {
		//수정할 글 번호를 읽어온다.
		int num=Integer.parseInt(request.getParameter("num"));
		//번호를 넣어준다. 
		dto.setNum(num);		
		//글하나의 정보를 얻어온다.
		GroupFAQDto resultDto=groupfaqdao.getData(num);
		//id를 가져온다.
		String id =(String)request.getSession().getAttribute("id");
		//가져온 값을 토대로 id검증을 한다.
		if(resultDto.getQ_writer().equals(id)) {
			groupfaqdao.update(dto);
		}else {
			throw new DontEqualException("다른 사람의 글은 수정할 수 없습니다.");
		}
	}

	@Override
	public void deleteGroupFAQ(HttpServletRequest request, int num) {
		//글하나의 정보를 얻어온다.
		GroupFAQDto dto = groupfaqdao.getData(num);
		//id를 가져온다.
		String id =(String)request.getSession().getAttribute("id");
		//가져온 값을 토대로 id검증을 한다.(일단 관리자 삭제 위해 주석처리)
//		if(dto.getQ_writer().equals(id)) {
//			throw new DontEqualException("다른 사람의 글은 삭제할 수 없습니다.");
//		}
		groupfaqdao.delete(num);
	}
	
	//소모임 문의 답변하기
	@Override
	public void groupAnswerInsert(GroupFAQDto dto) {
		int group_num = dto.getGroup_num();
		//dto.getGroup_num으로 소모임의 번호를 알아낸다.
		GroupDto groupDto = managingdao.getGroupData(group_num);
		//얻어온 정보로 소모임 관리자의 id를 알아낸다
		String manager=groupDto.getManager_id();
		if(dto.getA_writer().equals(manager)) {
			//만약 manager_id가 a_writer와 같으
			//dao를 통해 db에 집어넣기
			groupfaqdao.answer(dto);
		}else {
			throw new DontEqualException("소모임 관리자만 작성할 수 있습니다.");
		}
	}
	
	//소모임 문의 답변 수정하기
	@Override
	public void groupAnswerUpdate(HttpServletRequest request, GroupFAQDto dto) {
		//수정할 글 번호를 읽어온다.
		int num=Integer.parseInt(request.getParameter("num"));
		//번호를 넣어준다. 
		dto.setNum(num);		
		//글하나의 정보를 얻어온다.
		GroupFAQDto resultDto=groupfaqdao.getData(num);
		//id를 가져온다.
		String id =(String)request.getSession().getAttribute("id");
		//가져온 값을 토대로 id검증을 한다.
		if(resultDto.getQ_writer().equals(id)) {
			groupfaqdao.answerUpdate(dto);
		}else {
			throw new DontEqualException("다른 사람의 글은 수정할 수 없습니다.");
		}
		
	}

	@Override
	public void groupAnswerDelete(HttpServletRequest request, int num) {
		//글하나의 정보를 얻어온다.
		GroupFAQDto dto = groupfaqdao.getData(num);
		//id를 가져온다.
		String id =(String)request.getSession().getAttribute("id");
		//가져온 값을 토대로 id검증을 한다.
		if(dto.getA_writer().equals(id)) {
			groupfaqdao.answerDelete(num);
		}else {
			throw new DontEqualException("다른 사람의 글은 삭제할 수 없습니다.");
		}
		
	}
	

	@Override
	public void getViewList(HttpServletRequest request, Model model) {
		//한 페이지에 몇개씩 표시할 것인지
		final int PAGE_ROW_COUNT=8;
		//하단 페이지를 몇개씩 표시할 것인지
		final int PAGE_DISPLAY_COUNT=5;
			      
		//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
		int pageNum=1;
		//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
		String strPageNum = request.getParameter("pageNum");
		//만일 페이지 번호가 파라미터로 넘어 온다면
		 if(strPageNum != null){
			//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
			pageNum=Integer.parseInt(strPageNum);
		}
			      
		//보여줄 페이지의 시작 ROWNUM
		int startRowNum = 1 + (pageNum-1) * PAGE_ROW_COUNT;
		//보여줄 페이지의 끝 ROWNUM
		int endRowNum = pageNum * PAGE_ROW_COUNT;
			      
				
		String keyword=request.getParameter("keyword");
		String condition=request.getParameter("condition");
		if(keyword==null) {
			keyword="";
			condition="";
		}
		String encodedK=URLEncoder.encode(keyword);
		GroupDto dto = new GroupDto();
		dto.setStartRowNum(startRowNum);
		dto.setEndRowNum(endRowNum);
			      
			      

				if(!keyword.equals("")) {
					if(condition.equals("name_caption")) {
				    	dto.setName(keyword);
				    	dto.setCaption(keyword);
				    	}else if(condition.equals("name")) {
				    		dto.setName(keyword);
				    	}else if(condition.equals("writer")) {
				    		dto.setManager_id(keyword);
				    	}
				    }
			      

			      List<GroupDto> viewList = dao.getViewList(dto);
			      	//전체글의 갯수
					int totalRow=dao.getCount(dto);
					
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

			      	      
			      //request 영역에 담아주기
			      model.addAttribute("viewList", viewList);   //소모임 조회수  list
			      model.addAttribute("keyword", keyword);
			      model.addAttribute("encodedK", encodedK);
			      model.addAttribute("condition", condition);
			      model.addAttribute("pageNum", pageNum);
			      model.addAttribute("startPageNum", startPageNum);
			      model.addAttribute("endPageNum", endPageNum);
			      model.addAttribute("totalPageCount", totalPageCount);
			      model.addAttribute("totalRow", totalRow);

		
	}

}