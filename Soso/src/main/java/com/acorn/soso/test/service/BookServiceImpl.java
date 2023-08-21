package com.acorn.soso.test.service;


import java.net.URI;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.acorn.soso.test.dao.BookDao;
import com.acorn.soso.test.dto.BookDto;
import com.acorn.soso.test.dto.NaverResultDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class BookServiceImpl implements BookService{
	
	@Autowired
	private BookDao bookDao;

	@Override
	public void getBookList(Model model, HttpServletRequest request) {
		

	// 네이버 검색 API 요청
	String clientId = "QfLQRna6uXVSACAEdvdd"; 		
    String clientSecret = "Vzssuh8MKt";
    
    //parameter로 가져온 파라메터를 읽어온
    String text = request.getParameter("search");
    
    //처음 검색했을때 초기값
    int pageNum = 1;
    
    
    //String apiURL = "https://openapi.naver.com/v1/search/blog?query=" + text;    // JSON 결과
    URI uri = UriComponentsBuilder
    		  .fromUriString("https://openapi.naver.com")//기본 주소
    		  .path("/v1/search/book.json")//경로
    		  .queryParam("query", text)//어떤 쿼리를 사용할 것인가
    		  .queryParam("display", 10)//결과는 얼마나 보여줄 것인가
    		  .queryParam("start", pageNum) //출력을 시작할 페이지 넘
    		  .queryParam("sort", "sim")
    		  .encode() // 인코딩하고
    		  .build() //조립한다
    		  .toUri(); //Uri로 가공한다.
 
    		  
    // Spring 요청 제공 클래스 
    //네이버 API를 요청하기 위해 클라이언트 ID, 비밀번호를 headerd에 담을 필요가 있다.
    RequestEntity<Void> req = RequestEntity
    						 .get(uri)	// 방금만든 uri를 불러와서
    						 .header("X-Naver-Client-Id", clientId) //클라이언트 아이디와 
    						 .header("X-Naver-Client-Secret", clientSecret) //클라이언트 비밀번호를 불러오고
    						 .build();//빌드
    
    // Spring 제공 restTemplate
    // 네이버 서버에 보낼 요청 템플릿을 만들고, 받아올 준비를 한다.
    RestTemplate restTemplate = new RestTemplate();
    ResponseEntity<String> resp = restTemplate.exchange(req, String.class);
    
    // JSON 파싱 (Json 문자열을 객체로 만듦, 문서화)
    ObjectMapper om = new ObjectMapper();
    List<BookDto> dto = new ArrayList<BookDto>();
    NaverResultDto naverDto = null;
    
    try {
    	//네이버로 요청을 보내서 받아온 것을 naverDto에 담는다.
    	naverDto = om.readValue(resp.getBody(), NaverResultDto.class);
	} catch (JsonMappingException e) {
		e.printStackTrace();
	} catch (JsonProcessingException e) {
		e.printStackTrace();
	}
    
    List<BookDto> books = naverDto.getItems();	// books를 list.html에 출력 -> model 선언
    model.addAttribute("books", books);
}

	//책을 저장해보
	@Override
	public void saveBook(BookDto dto) {
		bookDao.saveBook(dto);		
	}
}
