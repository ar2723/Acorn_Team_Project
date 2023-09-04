package com.acorn.soso.users.service;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

@Service
public class UsersServiceImpl implements UsersService{
	
	@Autowired
	private UsersDao dao;
	
	// application.properties 문서에 있는 파일의 저장위치 설정정보 읽어오기
	@Value("${file.location}")
	private String fileLocation;
	
	@Override
	public void addUser(UsersDto dto) {
		//비밀번호를 암호화해줄 객체를 생성
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		//암호화된 비밀번호 얻어내서
		String encodedPwd = encoder.encode(dto.getPwd());
		//UsersDto 객체에 담고
		dto.setPwd(encodedPwd);
		//UsersDao 객체를 이용해서 DB에 저장하기
		dao.insert(dto);
	}
	
	//아이디 중복체크
	@Override
	public boolean isExist(String id) {
		return dao.isExist(id) != 0;
	}
	
	//닉네임 중복체크
	@Override
	public boolean isExist2(String name) {
		return dao.isExist2(name) != 0;
	}
	
	//비밀번호 확인
	@Override
	public boolean isSamePwd(UsersDto dto) {
		//DB에 저장된 회원번호 얻어오기
		UsersDto resultdto = dao.getData(dto.getId());
		//DB에 저장된 암호화된 비밀번호
		String encodedPwd = resultdto.getPwd();
		//클라이언트가 입력한 비밀번호
		String inputPwd = dto.getPwd();
		//두 비밀번호가 일치하는지 확인
		boolean isValid = BCrypt.checkpw(inputPwd, encodedPwd);
		
		return isValid;
	}

	@Override
	public void loginprocess(UsersDto dto, HttpSession session) {
		String id = dto.getId();
		//id가 존재하며, pwd가 동일할 때만 true
		Boolean isValid = isExist(id) ? isSamePwd(dto) ? true : false : false;
		
		//만일 유효한 정보이면
		if(isValid) {
			//로그인 처리를 한다.
			session.setAttribute("id", dto.getId());
		}
	}

	@Override
	public void getInfo(HttpSession session, Model model) {
		//로그인 된 아이디를 읽어온다.
		String id = (String)session.getAttribute("id");
		UsersDto dto = dao.getData(id);
		//view 페이지에서 필요한 정보를 서비스 페이지에서 dto로 담아준다.
		model.addAttribute("dto", dto);
	}

	@Override
	public void updateUserPwd(HttpSession session, UsersDto dto, Model model) {
		//세션 영역에서 로그인된 아이디 읽어오기
		String id = (String)session.getAttribute("id");
		dto.setId(id); //id값을 담아서 메소드로 보냄

			//새로운 비밀번호를 암호화 한다.
			BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
			String encodedNewPwd = encoder.encode(dto.getNewPwd());
			//암호화된 비밀번호를 dto에 다시 넣어준다.
			dto.setNewPwd(encodedNewPwd);
			//dto에 로그인된 아이디도 넣어준다.
			dto.setId(id);
			//dao를 이용해서 DB에 수정반영한다.
			dao.updatePwd(dto);
			//로그아웃 처리
			session.removeAttribute("id");


		//로그인된 아이디도 담아준다.
		model.addAttribute("id", id);
	}

	@Override
	public Map<String, Object> saveProfileImage(HttpServletRequest request, MultipartFile mFile) {
		//업로드된 파일에 대한 정보를 MultipartFile 객체를 이용해서 얻어낼수 있다.   
	      
	      //원본 파일명
	      String orgFileName=mFile.getOriginalFilename();
	      
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
	         mFile.transferTo(new File(savePath));
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      
	      // json 문자열을 출력하기 위한 Map 객체 생성하고 정보 담기 
	      Map<String, Object> map=new HashMap<String, Object>();
	      map.put("imagePath", "/users/images/"+saveFileName);
	      
	      return map;
	}

	@Override
	public void updateUser(UsersDto dto, HttpSession session) {
		//로그인된 아이디 얻어오기
		String id = (String)session.getAttribute("id");
		//dto에 아이디도 담기
		dto.setId(id);
		//dao를 이용해서 수정반영
		dao.update(dto);
	}

	@Override
	public void deleteUser(HttpSession session, Model model) {
		//로그인된 아이디 얻어와서
		String id = (String)session.getAttribute("id");
		//헤당 정보를 DB에서 삭제하고
		dao.delete(id);
		//로그아웃 처리도 한다.
		session.removeAttribute("id");
		//ModelAndView 객체에 탈퇴한 회원의 아이디를 담아준다.
		model.addAttribute("id", id);
	}

	@Override
	public void pwdAuth(UsersDto dto, HttpSession session, Model model) {
		//세션 영역에서 로그인된 아이디 읽어오기
		String id = (String)session.getAttribute("id");
		dto.setId(id); //id값을 담아서 메소드로 보냄
		
		Boolean isValid = isSamePwd(dto);
		model.addAttribute("isSuccess",isValid);
	}
	
	//임시 비밀번호 발급 (비밀번호 찾기)
	@Override
	public void findUserPwd(UsersDto dto, Model model) {
		//입력받은 id의 정보를 resultDto에 담는다
		String id = dto.getId();
		UsersDto resultDto = dao.getData(id);
		
		boolean isValid = false;
		
		//입력한 아이디가 존재하는 아이디일때
		if(resultDto != null) {
			//입력한 이메일과 회원가입 시 입력한 이메일이 같을경우 유효한 이메일 
			isValid = dto.getEmail().equals(resultDto.getEmail());
		}
		
		if(isValid) {
			/*
			 * String type은 수정 할 때마다 새로운 객체를 생성하므로 메모리 낭비가 심하다.
			 * 메모리 낭비를 막기 위해 StringBuffer / StringBuiler를 사용한다.
			 * StringBuilder는 StringBuffer에 비해 높은 성능을 가지지만
			 * 멀티스레드 환경에서 불안정하므로 다수의 사용자가 있는 웹 특성을 고려하여 StringBuffer를 이용한다.
			 */
			StringBuffer password = new StringBuffer();
			
			//랜덤하게 9개의 문자열을 얻어낸다.
			for (int i = 0; i < 9; i++) {
	            int randomIndex = (int) (Math.random() * 3); // 0,1,2중 랜덤한 값
	            if(i<3) {randomIndex = i;} // 숫자,소문자,대문자를 한번씩은 갖도록 한다.
	            switch (randomIndex) {
	            	//randomIndex가 0일경우
	                case 0:
	                    char randomDigit = (char) (Math.random() * 10 + 48);
	                    password.append(randomDigit);
	                    break; //switch문을 벗어난다.
	                //randomIndex가 1일경우
	                case 1:
	                    char randomLower = (char) (Math.random() * 26 + 97);
	                    password.append(randomLower);
	                    break;
	                //randomIndex가 2일경우
	                case 2:
	                    char randomUpper = (char) (Math.random() * 26 + 65);
	                    password.append(randomUpper);
	                    break;
	            }
	        } //for
			
			// 랜덤하게 생성된 문자의 순서를 섞는다.
			// 섞지 않으면 처음 세자리는 숫자,소문자,대문자로 고정됨
	        for (int i = password.length() - 1; i > 0; i--) {
	            int j = (int) (Math.random() * (i + 1));
	            char temp = password.charAt(i);
	            password.setCharAt(i, password.charAt(j));
	            password.setCharAt(j, temp);
	        }
	        
	        String newPwd = password.toString(); //StringBuffer 를 String 으로 변환
			dto.setNewPwd(newPwd);
			
			BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

			//먼저 임시비밀번호를 모델에 담은 후
			model.addAttribute("tmpPwd",dto.getNewPwd());
			//암호화를 하고
			String encodedNewPwd = encoder.encode(dto.getNewPwd());
			dto.setNewPwd(encodedNewPwd);
			dto.setId(id);
			
			dao.updatePwd(dto); //DB에 저장한다.
		}
		
		model.addAttribute("isSuccess", isValid);
		model.addAttribute("id",id);
	}
	
	@Override
	public void findUserId(UsersDto dto, Model model) {
		//입력받은 email의 정보를 resultDto에 담는다
		String userName = dto.getName();
		UsersDto resultDto = dao.getId(userName);
		
		boolean isValid = false;
		
		//입력한 이름이 존재하는 이름일때
		if(resultDto != null) {
			//입력한 이메일과 회원가입 시 입력한 이메일이 같을경우 유효함
			isValid = dto.getEmail().equals(resultDto.getEmail());
		}
		String id = "";
		if(isValid) {
			id = resultDto.getId();
		}
		
		model.addAttribute("isSuccess", isValid);
		model.addAttribute("id", id);
	}
}
