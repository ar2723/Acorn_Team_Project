<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupfaq.css" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="stylesheet" href="${path }/resources/css/group_page.css" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="groupPage" name="current" />
	</jsp:include>
	
	<section class="sub-contents group_content_title">
		<div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-easing="ease-in-sine">${dto.name }</h3>
         </div>
		<div class="inner-wrap">
			<div class="group_meet_text">
			<ul>
				<li>${dto.meeting_loc }</li>
				<li>${dto.meeting_time }</li>
				<li>최대 ${dto.max_people }명</li>
				<li>신청 기한&nbsp; <fmt:parseDate value="${dto.deadline_dt}" var="deadline_dt" pattern="yyyy-MM-dd"></fmt:parseDate><fmt:formatDate value="${deadline_dt}" pattern="yyyy-MM-dd" /> 까지</li>
			</ul>
			</div>
		</div>
		
		<div class="inner-wrap">
			<div class="group_content">
				<div class="group_meet_img">
					<img src="${pageContext.request.contextPath}${dto.img_path}">
				</div>
				<div class="group_meet_contents">
					<p class="title">${dto.manager_comment }</p>
					<p class="text">${dto.caption }</p>

				</div> 
			</div>
		</div>
		<!-- 책 리스트 -->
		 <div class="group_content_book_bg">
		  <div class="inner-wrapper">
		  	<div class="group_content_book">
	            <h2 class="title black">이 모임에서는 이런 책들을 읽어요</h2>
				<div class="group_content_book_list">
					<ul>
						<li>
							<div class="group_content_book_img">
								<a href=""><img src="${path }/resources/images/sub/book_cover1.png"/></a>
							</div>
							<div class="group_content_book_text">
								<h5 class="">책 이름1</h5>
								<p class="">여기에 책 설명이 출력될 예정입니다.</p>
							</div>
						</li>
						<li>
							<div class="group_content_book_img">
								<a href=""><img src="${path }/resources/images/sub/book_cover2.png"/></a>
							</div>
							<div class="group_content_book_text">
								<h5 class="">책 이름1</h5>
								<p class="">여기에 책 설명이 출력될 예정입니다.</p>
							</div>
						</li>
					</ul>
				</div>
            </div>
		  </div>
		</div>


		<!-- 참석후기 -->
		<div class="group_review" >
			<div class="inner-wrap">
				<h2 class="title black">참여 후기</h2>
				<div class="d-flex flex-column mb-3">
				<!-- forEach를 사용해서 댓글 출력(나중에는 분기 써서 댓글이 없을 때는 다른 페이지 표시) -->
					<c:choose>
						<c:when test="${empty commentList}">
							<div class="card mx-1 my-1">
								<div class="card-body">
									<p class="card-text">아직 후기가 없어요</p>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="tmp" items="${commentList}" end="2">
								<div class="card mx-1 my-1">
									<div class="card-body">
										<p class="card-text">${tmp.content }</p>
										<p class="card-text">평점 : ${tmp.rate }</p>
										<p class="card-text">작성자 : ${tmp.writer }</p>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<c:forEach var="item" items="${list}">
					  <c:choose>
					    <c:when test="${item.user_id eq sessionScope.id}">
					    	<c:if test="${dto.deadline_dt lt nowDate}">
								<a href="${pageContext.request.contextPath}/group/comment/comment_insert_form?num=${dto.num}" id="reviewInsert">후기 작성하기</a>
								<div id="commentArea"></div>
							</c:if>
					    </c:when>
					  </c:choose>
					</c:forEach>
				</div>
			</div>
		</div>
		<div class="inner-wrap">
			<div id="faq">
				<h2 class="title black">문의하기</h2>
			</div>
			<div style="width : 100%;">
			<div id="Parse_Area"gt;lt;></div>
		</div>		
		</div>
		<!-- 플로팅 하단 고정 -->
		<div class="banner-inner-wrap">
			<div class="group_banner">
					<div class="group_check">
						<div class="group_check_title">${dto.name }</div>
					    <!-- 모임 가입 , 취소, 마감 버튼  -->
						<div class="group_join_btn">
						<c:set var="now" value="<%= new java.util.Date() %>" />
						<c:set var="nowDate"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
						<c:choose>
							<c:when test="${dto.deadline_dt lt nowDate}">
							<!-- 오늘 날짜와 비교해서 신청 마감 버튼으로 변경 -->
							<button type="button" class="disabled" disabled>신청 마감</button>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${knowJoin == -1 || empty knowJoin}">
										<button type="button" class="join">
											<a href="${pageContext.request.contextPath}/group/group_in?num=${dto.num }">가입하기</a>
										</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="cancle" id="cancleBtn" name="cancleBtn">신청 취소</button>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						</div>
						<div class="group_faq_btn">
							<button type="button" class="faq">
								<a href="#faq">문의하기</a>
							</button>
							
						</div>
						<%--<div class="group_com">
							<a href="${pageContext.request.contextPath}/group_managing/group_userdetail?num=${dto.num}">커뮤니티</a>
						</div> --%>
						<!-- 북마크 버튼 -->	
						<div class="group_bookmark">
							<c:choose>
								<c:when test="${empty jjim }">
									<div class="p-2 heart" id="fillHeart">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
										  <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
										</svg>
										<div id="jjimCount">${jjimCount }</div>
									</div>	
								</c:when>
								<c:otherwise>
									<div class="p-2 heart" id="emptyHeart">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
										  <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
										</svg>
										<div id="jjimCount">${jjimCount }</div>
									</div>
								</c:otherwise>
							</c:choose>
							<input type="hidden" name="jjimNum" id="jjimNum" value="${dto.num }" hidden />
							<button id="jjim" hidden>찜하기 버튼 테스트</button>
						</div>	
									
					</div>
			</div>
		</div>
	</section>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
		AOS.init();
		// heart 이모티콘을 클릭하면 button id="jjim"를 강제로 클릭하는 코드
		$(".heart").on("click", function() {
		  $("#jjim").click();
		});
		  
		//id가 jjim인 버튼을 눌렀을 때 ajax 요청하기
		$("#jjim").on("click", function(){
			var jjimNum = $("#jjimNum").val();
			//ajax로 요청한다.
			$.ajax({
			  // 요청 경로
			  url: "${pageContext.request.contextPath}/group/jjim",
			  // 요청 방식
			  method: "get",
			  // num이라는 파라미터를 request 영역에 담아둔다. 1은 테스트용 값
			  data: { "num": jjimNum },
			  success: function(data){
			  // 서버에서 반환된 응답 데이터를 이용하여 원하는 처리를 한다.
			  // data 여부에 따라 클라이언트에게 표시해준다.
			  if (data.isSuccess == true) {	
			    	// 찜 추가되었습니다.
					alert(jjimNum+"찜 추가되었습니다.");
					
			    	// div의 클래스를 'emptyHeart'에서 'heart'로 변경
					$(".heart").removeClass("emptyHeart").addClass("heart");
					
					// 하트의 모양을 채워지게 변경
					$(".heart").html(`
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
						    <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
						</svg>
					`);
					} else {
					
						// 찜 취소하셨습니다.
					alert(jjimNum+"찜 취소하셨습니다.");
					
					// 하트의 모양을 비워지게 변경
					$(".heart").html(`
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
						    <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
						</svg>
					`);
					}
				 // jjimCount 엘리먼트의 내용을 data.jjimCount로 변경
				 $("#jjimCount").text(data.jjimCount);
			      }
			    });
		  });
		  
		  //신청 취소 버튼 누르면 신청 취소가 되게 해주는 ajax
		  $(".cancle").on("click", function(){
			  var jjimNum = $("#jjimNum").val();
			  var $cancleBtn = $(this); // 클릭된 버튼을 참조
	
			  $.ajax({
				  url : "${pageContext.request.contextPath}/group/cancleJoin",
				  method : "get",
				  data : { "num" : jjimNum },
				  success: function(data){
					  // 신청 취소 버튼을 가입하기 버튼으로 변경
				      $cancleBtn.replaceWith(`
				        <button type="button" class="join">
				          <a href="${pageContext.request.contextPath}/group/group_in?num=${dto.num }">가입하기</a>
				        </button>
				      `);
					  alert("가입 신청을 취소하셨습니다.")
				  }
			  })
		  })
		  
		  //여기서부터 ajax faq
		  //작성글 클릭 시 writing_list 페이지 로딩
		  $("#faqList").click(function() {
			  $.ajax({
		            type : "GET", //전송방식을 지정한다 (POST,GET)
		            url : "${pageContext.request.contextPath}/group/faq/list?num=${dto.num }",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
		            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
		            error : function(){
		                console.log("통신실패");
		            },
		            success : function(Parse_data){
		                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
		                console.log("통신 데이터 값 : " + Parse_data);
		            }
		            
	        	});
				
				$(this).attr("class","nav-link active")
				$("#commentList").attr("class","nav-link");
			});
		  
		  //후기 작성하기 클릭 시 writing_list 페이지 로딩
		  $("#reviewInsert").click(function(event) {
			  event.preventDefault(); // 앵커의 기본 동작을 막습니다.
			  $.ajax({
		            type : "GET", //전송방식을 지정한다 (POST,GET)
		            url : "${pageContext.request.contextPath}/group/comment/comment_insert_form?num=${dto.num }",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
		            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
		            error : function(){
		                console.log("통신실패");
		            },
		            success : function(Parse_data){
		                $("#commentArea").html(Parse_data); //div에 받아온 값을 넣는다.
		                console.log("통신 데이터 값 : " + Parse_data);
		            }
		            
	        	});
			});
			
		  //화면 로딩 시 writing_list 페이지 로딩
		  $(document).ready(function() {
				$.ajax({
		            type : "GET", //전송방식을 지정한다 (POST,GET)
		            url : "${pageContext.request.contextPath}/group/faq/list?num=${dto.num }",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
		            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
		            error : function(){
		                console.log("통신실패");
		            },
		            success : function(Parse_data){
		                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
		            }
		            
	        	});
				
				$("#faqList").attr("class","nav-link active");
			});	  
	</script>

</body>
</html>