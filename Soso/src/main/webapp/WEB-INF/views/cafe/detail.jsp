<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티  글쓰기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community_detail.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<section>
		<div class="inner-wrap">
		<%-- 만일 이전글(더 옛날글)의 글번호가 0 가 아니라면(이전글이 존재 한다면) --%>
		<c:if test="${cafeDto.prevNum ne 0}">
			<a href="${pageContext.request.contextPath}/cafe/detail?comu_num=${cafeDto.prevNum }&group_num=${cafeDto.group_num}&condition=${condition}&keyword=${encodedK}" 
				class="btn btn-outline-dark"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-left-fill" viewBox="0 0 16 16">
 			<path d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z"/>
			</svg>이전글</a>
		</c:if>
		<%-- 만일 다음글(더 최신글)의 글번호가 0 가 아니라면(다음글이 존재 한다면) --%>
		<c:if test="${cafeDto.nextNum ne 0 }">
			<a href="${pageContext.request.contextPath}/cafe/detail?comu_num=${cafeDto.nextNum }&group_num=${cafeDto.group_num}&condition=${condition}&keyword=${encodedK}" 
				class="btn btn-outline-dark">다음글<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-right-fill" viewBox="0 0 16 16">
  			<path d="m12.14 8.753-5.482 4.796c-.646.566-1.658.106-1.658-.753V3.204a1 1 0 0 1 1.659-.753l5.48 4.796a1 1 0 0 1 0 1.506z"/>
			</svg></a>
		</c:if>
		
		<%-- 만일 검색 키워드가 있다면 --%>
		<c:if test="${not empty keyword }">
			<p>
				<strong>${condition }</strong> 조건 
				<strong>${keyword }</strong> 검색어로 검색된 내용 자세히 보기
			</p>
		</c:if>
		</div>
		<!-- 게시글 영역 -->
		<div class="inner-wrap">
			<h3 class="title"></h3>
			<div class="sub_link">
				<li><a href="#">북메이트 커뮤니티</a></li>
				<li> > </li>
				<li><a href="#">글 보기</a></li>
			</div>
	     </div>
	     <div class="inner-wrap">
	     	<div class="contents">
				<div class="contents_title">${cafeDto.title }</div>
				<div class="sub_title">
					<div class="contents_num">${cafeDto.comu_num}</div>
					<div class="contents_viewCount">조회 ${cafeDto.viewCount}</div>
					<div class="contents_regdate">${cafeDto.regdate}</div>
					<div class="contents_writer">${cafeDto.writer}</div>
					<div class="contents_btn">
						<%-- 로그인된 아이디와 글의 작성자가 같으면 수정, 삭제 링크를 제공한다 --%>
						<c:if test="${sessionScope.id eq cafeDto.writer }">
							<div class="">
								<a class="contents_delete" href="updateform?comu_num=${cafeDto.comu_num}&group_num=${cafeDto.group_num}">수정</a>
							</div>
							<div class="">
								<a class="contents_update" href="javascript:" onclick="deleteConfirm()">삭제</a>
							</div>
							
						</c:if>
					</div>
				</div>
				<div class="contents_content">${cafeDto.content}</div>
	     	</div>
	     </div>
	     <div class="inner-wrap">
			<form class="comment-form insert-form" action="comment_insert" method="post">
				<input type="hidden" name="comu_num" value="${cafeDto.comu_num}"/>
				<input type="hidden" name="group_num" value="${cafeDto.group_num}"/>
				<input type="hidden" name="target_id" value="${cafeDto.writer}"/>
				<textarea name="content"></textarea>
				<button type="submit">등록</button>
			</form>
	     </div>
		<!-- 댓글 목록 -->
		<div class="inner-wrap">
			<div class="comments">
			<ul>
				<c:forEach var="tmp" items="${commentList }">
					<c:choose>
						<c:when test="${tmp.deleted eq 1}">
							<li>삭제된 댓글 입니다.</li>
						</c:when>
						<c:otherwise>
							<c:if test="${tmp.comment_num eq tmp.comment_group }">
								<li id="reli${tmp.comment_num }"></li>
							</c:if>
							<c:if test="${tmp.comment_num ne tmp.comment_group }">
								<li id="reli${tmp.comment_num }" style="padding-left:50px;"></li>
									<svg class="reply-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
			  							<path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
									</svg>
							</c:if>
									<dl>
										<dt>
											<c:if test="${ empty tmp.profile }">
												<svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
												  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
												  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
												</svg>
											</c:if>
											<c:if test="${not empty tmp.profile }">
												<img class="profile-image" src="${pageContext.request.contextPath}${tmp.profile }"/>
											</c:if>
											<span>${tmp.writer }</span>
											<c:if test="${tmp.comment_num ne tmp.comment_group }">
												@<i>${tmp.target_id }</i>
											</c:if>
											<span>${tmp.regdate }</span>
											<a data-num="${tmp.comment_num }" href="javascript:" class="reply-link">답글</a>
											<c:if test="${ (id ne null) and (tmp.writer eq id) }">
												<a data-num="${tmp.comment_num }" class="update-link" href="javascript:">수정</a>
												<a data-num="${tmp.comment_num }" class="delete-link" href="javascript:">삭제</a>
											</c:if>
										</dt>
										<dd>
											<pre id="pre${tmp.comment_num }">${tmp.content }</pre>						
										</dd>
									</dl>
									<!-- 대댓글 작성 폼 (가려져 있으나 클릭 이벤트를 통해 보이게 표시됨) -->
									<form id="reForm${tmp.comment_num }" class="animate__animated comment-form re-insert-form" action="comment_insert" method="post">
										<!-- 원글의 번호 -->
										<input type="hidden" name="comu_num" value="${cafeDto.comu_num }"/>
										<!-- 대댓글 등록 후 해당 게시글을 리다이렉트 할때 필요한 소모임 번호 -->
										<input type="hidden" name="group_num" value="${cafeDto.group_num }"/>
										<!-- 대댓글의 대상이 되는 댓글의 작성자 명 -->
										<input type="hidden" name="target_id" value="${tmp.writer }"/>
										<!-- 대댓글의 그룹번호는 대댓글을 작성하는 댓글의 그룹번호를 배정 -->
										<input type="hidden" name="comment_group" value="${tmp.comment_group }"/>
										<textarea name="content"></textarea>
										<button type="submit">등록</button>
									</form>
								<c:if test="${tmp.writer eq id }">
									<form id="updateForm${tmp.comment_num }" class="comment-form update-form" action="comment_update" method="post">
										<input type="hidden" name="comment_num" value="${tmp.comment_num }" />
										<textarea name="content">${tmp.content }</textarea>
										<button type="submit">수정</button>
									</form>
								</c:if>	
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</ul>
		 </div>		
		</div>
 		<div class="loader">
			<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
				  <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
			</svg>
		</div>		
	</section>
	<script src="${pageContext.request.contextPath}/resources/js/gura_util.js"></script>
	<script>
		function deleteConfirm(){
			const isDelete=confirm("이 글을 삭제 하겠습니까?");
			if(isDelete){
				location.href="delete?comu_num=${cafeDto.comu_num}&group_num=${cafeDto.group_num}";
			}
		}
	</script>
	<script>
		//클라이언트가 로그인 했는지 여부
		let isLogin=${ not empty id };
		document.querySelector(".insert-form")
			.addEventListener("submit", function(e){
				//만일 로그인 하지 않았으면 
				if(!isLogin){
					//폼 전송을 막고 
					e.preventDefault();
					//로그인 폼으로 이동 시킨다.
					location.href=
						"${pageContext.request.contextPath}/users/loginform?url=${pageContext.request.contextPath}/cafe/detail?comu_num=${cafeDto.comu_num}";
				}
			});
		
		//detail 페이지 로딩 시점에 만들어진 1 페이지에 해당하는 댓글에 이벤트 리스너 등록 하기 
		addUpdateFormListener(".update-form");
		addUpdateListener(".update-link");
		addDeleteListener(".delete-link");
		addReplyListener(".reply-link");
		
		//댓글의 현재 페이지 번호를 관리할 변수를 만들고 초기값 1 대입하기
		let currentPage = 1;
		//마지막 페이지는 totalPageCount 이다.  
		let lastPage = ${totalPageCount};
		//추가로 댓글을 요청하고 그 작업이 끝났는지 여부를 관리할 변수 
		let isLoading = false; //현재 로딩중인지 여부 
		
		//화면의 스크롤에 따라 추가 댓글을 로딩
		window.addEventListener("scroll", function(){
			//바닥 까지 스크롤 했는지 여부 
			const isBottom = 
				window.innerHeight + window.scrollY  >= document.body.offsetHeight;
			//현재 페이지가 마지막 페이지인지 여부 알아내기
			let isLast = currentPage == lastPage;
			
			//현재 바닥까지 스크롤 했고 로딩중이 아니고 현재 페이지가 마지막이 아니라면
			if(isBottom && !isLoading && !isLast){
				document.querySelector(".loader").style.display="block";
				
				isLoading=true;
				
				currentPage++;
				
				ajaxPromise("ajax_comment_list",
							"get",
							"pageNum="+currentPage+"&comu_num=${cafeDto.comu_num}")
				.then(function(response){
					//json 이 아닌 html 문자열을 응답받았기 때문에  return response.text() 해준다.
					return response.text();
				})
				.then(function(data){
					//data 는 html 형식의 문자열이다. 
					console.log(data);
					// beforebegin | afterbegin | beforeend | afterend
					document.querySelector(".comments ul")
						.insertAdjacentHTML("beforeend", data);
					//로딩이 끝났다고 표시한다.
					isLoading=false;
					
					//새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록 하기 
					addUpdateListener(".page-"+currentPage+" .update-link");
					addDeleteListener(".page-"+currentPage+" .delete-link");
					addReplyListener(".page-"+currentPage+" .reply-link");
					
					//새로 추가된 댓글 li 요소 안에 있는 댓글 수정폼에 이벤트 리스너 등록하기
					addUpdateFormListener(".page-"+currentPage+" .update-form");
					
					//로딩바 숨기기
					document.querySelector(".loader").style.display="none";
				});
			}
		});
		
		//인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수 
		function addUpdateListener(sel){
			//댓글 수정 링크의 참조값을 배열에 담아오기 
			// sel 은  ".page-xxx  .update-link" 형식의 내용이다 
			let updateLinks=document.querySelectorAll(sel);
			for(let i=0; i<updateLinks.length; i++){
				updateLinks[i].addEventListener("click", function(){
					//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
					const num=this.getAttribute("data-num"); //댓글의 글번호
					//숨겨진 댓글 수정폼을 보이도록 한다.
					document.querySelector("#updateForm"+num).style.display="block";
				});
			}
		}
		
		function addDeleteListener(sel){
			//댓글 삭제 링크의 참조값을 배열에 담아오기 
			let deleteLinks=document.querySelectorAll(sel);
			for(let i=0; i<deleteLinks.length; i++){
				deleteLinks[i].addEventListener("click", function(){
					//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
					const num = this.getAttribute("data-num"); //댓글의 글번호
					const isDelete=confirm("댓글을 삭제 하시겠습니까?");
					if(isDelete){
						// gura_util.js 에 있는 함수들 이용해서 ajax 요청
						ajaxPromise("comment_delete", 
									"post", 
									"comment_num="+num)
						.then(function(response){
							return response.json();
						})
						.then(function(data){
							//만일 삭제 성공이면 
							if(data.isSuccess){
								//댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
								document.querySelector("#reli"+num).innerText="삭제된 댓글입니다.";
							}
						});
					}
				});
			}
		}
		
		//댓글의 답글 버튼을 눌렀을 때 실행되는 함수
		function addReplyListener(sel){
			//댓글 링크의 참조값을 배열에 담아오기 
			let replyLinks=document.querySelectorAll(sel);
			//반복문 돌면서 모든 링크에 이벤트 리스너 함수 등록하기
			for(let i=0; i<replyLinks.length; i++){
				replyLinks[i].addEventListener("click", function(){
					if(!isLogin){
						const isMove=confirm("로그인이 필요 합니다. 로그인 페이지로 이동 하시겠습니까?");
						if(isMove){
							location.href=
								"${pageContext.request.contextPath}/users/loginform?url=${pageContext.request.contextPath}/cafe/detail?comu_num=${cafeDto.comu_num}";
						}
						return;
					}
					//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
					const num = this.getAttribute("data-num"); //댓글의 글번호
					const form=document.querySelector("#reForm"+num);
					
					//현재 문자열을 읽어온다 ( "답글" or "취소" )
					let current = this.innerText;
					
					if(current == "답글"){
						//번호를 이용해서 댓글의 댓글폼을 선택해서 보이게 한다. 
						form.style.display="block";
						form.classList.add("animate__flash");
						this.innerText="취소";	
						form.addEventListener("animationend", function(){
							form.classList.remove("animate__flash");
						}, {once:true});
					}else if(current == "취소"){
						form.classList.add("animate__fadeOut");
						this.innerText="답글";
						form.addEventListener("animationend", function(){
							form.classList.remove("animate__fadeOut");
							form.style.display="none";
						},{once:true});
					}
				});
			}
		}
		
		function addUpdateFormListener(sel){
			//댓글 수정 폼의 참조값을 배열에 담아오기
			let updateForms=document.querySelectorAll(sel);
			for(let i=0; i<updateForms.length; i++){
				//폼에 submit 이벤트가 일어 났을때 호출되는 함수 등록 
				updateForms[i].addEventListener("submit", function(e){
					//submit 이벤트가 일어난 form 의 참조값을 form 이라는 변수에 담기 
					const form=e.target;
					//폼 제출을 막은 다음 
					e.preventDefault();
					//이벤트가 일어난 폼을 ajax 전송하도록 한다.
					ajaxFormPromise(form)
					.then(function(response){
						return response.json();
					})
					.then(function(data){
						if(data.isSuccess){
							/*
								document.querySelector() 는 html 문서 전체에서 특정 요소의 
								참조값을 찾는 기능
								
								특정문서의 참조값.querySelector() 는 해당 문서 객체의 자손 요소 중에서
								특정 요소의 참조값을 찾는 기능
							*/
							const comment_num=form.querySelector("input[name=comment_num]").value;
							const content=form.querySelector("textarea[name=content]").value;
							//수정폼에 입력한 value 값을 pre 요소에도 출력하기 
							document.querySelector("#pre"+comment_num).innerText=content;
							form.style.display="none";
						}
					});
				});
			}
		}
	</script>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>







	





