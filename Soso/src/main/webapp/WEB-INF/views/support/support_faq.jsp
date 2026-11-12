<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주하는 질문</title>

<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_faq.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<!-- 상단 레이아웃 -->
    <main id="main-banner" class="main-banner-06">
        <div class="inner-wrap">
            <div class="title">
                <h2>고객센터</h2>
                <p>
			                    서비스 이용 중 불편 했던 점이나 궁금한 점을 <br />
			                    빠르고 친절하게 안내해 드리겠습니다.
                </p>
            </div>
            <div class="indicator">
                <div class="home circle">
                    <a href="/main" title="메인페이지가기"><img src="${path }/resources/images/sub/icon_home.svg" alt="홈버튼이미지"></a>
                </div>
                <div class="main-menu circle">BOOKMATE</div>

            </div>
        </div>
    </main>
	<!-- 메인 메뉴바 시작 -->
	<ul class="menu_bar">
		<li class="menu_home">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_main">고객센터</a>
		</li>
		<li class="menu_faq">
			<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_faq?">자주하는 질문</a>
		</li>
		<li class="menu_notice">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_notice">공지사항</a>
		</li>
		<!-- Admin 계정으로 로그인 했을때 문의하기를 누르면 바로 사용자 문의 접수내역으로 이동 되도록 -->
		<c:choose>
			<c:when test="${isAdmin }">
				<li class="menu_inquire">
					<a class="nav-link" id="inquire" href="${pageContext.request.contextPath }/support/support_inquire_inquire">문의하기</a>
				</li>
				<script>
					 // JavaScript 코드: 문의하기 링크 클릭 시 리다이렉트
			        document.querySelector("#inquire").addEventListener("click", function(e) {
			            e.preventDefault();
			            window.location.href = "${pageContext.request.contextPath}/support/support_inquire_inquireStatus";
			        });
				</script>
			</c:when>
			<c:otherwise>
				<li class="menu_inquire">
					<a class="nav-link" href="${pageContext.request.contextPath }/support/support_inquire">문의하기</a>
				</li>
			</c:otherwise>
		</c:choose>
	</ul>
	<!-- 메인 메뉴바 끝 -->
	<!-- 검색 창 시작 -->
	<div class="search">
		<form action="${pageContext.request.contextPath}/support/support_faq" class="search_form" method="get">
			<input type="text" value="${keyword}"name="keyword" class="search_main" placeholder="예) 회원가입, 모임신청, 로그인 등" />
			<input type="submit" class="search_cs"/>
		</form>
	</div>
	<!-- 검색 창 끝 -->
	<!-- FAQ 메뉴바 -->
		<div class="main_content">
			<div class="tab_section">
			<ul class="tab_menu">
				<li class="active">
					<a href="${pageContext.request.contextPath }/support/support_faq?">전체(${totalRow })</a>
				</li>
				<li class="">
					<a href="${pageContext.request.contextPath }/support/support_faq_user?category=1">회원(${categoryOneRow })</a>
				</li>
				<li class="">
					<a href="${pageContext.request.contextPath }/support/support_faq_request?category=2">모임신청(${categoryTwoRow })</a>
				</li>
				<li class="">
					<a href="${pageContext.request.contextPath }/support/support_faq_open?category=3">모임개설(${categoryThreeRow })</a>
				</li>
				<li class="">
					<a href="${pageContext.request.contextPath }/support/support_faq_etc?category=0">기타(${categoryZeroRow })</a>
				</li>
			</ul>
			<!-- FAQ 메인 컨텐츠  -->
			<h3 class="faq">전체(${totalRow})</h3>
			<div class="tab_content">
			<ul>
				<c:forEach var="tmp" items="${list }">
					<input type="hidden" name="faq_num" value="${tmp.faq_num }"/>
					<li class="dropbox">
					<button type="button" class="btn_more" data-faq-num="${tmp.faq_num}">답변</button>
						<div class="title_area">
							<div class="category">
								<c:choose>
									<c:when test="${tmp.category == 1}">회원</c:when>
									<c:when test="${tmp.category == 2}">모임신청</c:when>
									<c:when test="${tmp.category == 3}">모임개설</c:when>
									<c:when test="${tmp.category == 0}">기타</c:when>
								</c:choose>
							</div>
							<h5 class="detail">
								<a class="faq_question" href="">
				                    ${tmp.question}
				                </a>
							</h5>
						</div>
						<div class="detail_content" id="faq-answer-${tmp.faq_num}">
							<span style="line-height: 24px;">
								<pre>${tmp.answer }</pre>
							</span>
							<c:if test="${isAdmin }">
								<button type="submit" data-num="${tmp.faq_num}" class="admin_delbutton" id="delete-btn">삭제</button>
							</c:if>
						</div>
					</li>
				</c:forEach>
			</ul>
			</div>
			<!-- admin 관리 메뉴 -->
			<div class="admin_menu">
				<c:choose>
				    <c:when test="${isAdmin}">
				        <a href="${pageContext.request.contextPath }/support/support_faq_insertform" class="admin_button">FAQ 등록</a>
				    </c:when>
				    <c:otherwise>
				        <!-- 해당 부분은 admin이 아닐 때의 처리 -->
				    </c:otherwise>
				</c:choose>
			</div>
		</div>
		
	</div>
		<!-- 페이징  -->
		<div class="pagination_wrap">
			<nav class="pagination">
				<ul class="pagination_ul">
					<c:if test="${startPageNum ne 1 }">
						<li class="page-item">
							<a href="support_faq?pageNum=${startPageNum-1 }&condition=${condition}&keyword=${encodedK}">Prev</a>
						</li>
					</c:if>
					<c:forEach var="i" begin="${startPageNum }" end="${endPageNum }">
						<li class="page-item ${pageNum eq i ? 'active' : '' }">
							<a href="support_faq?pageNum=${i }&condition=${condition}&keyword=${encodedK}">${i }</a>
						</li>
					</c:forEach>
					<c:if test="${endPageNum lt totalPageCount }">
						<li class="page-item">
							<a href="support_faq?pageNum=${endPageNum+1 }&condition=${condition}&keyword=${encodedK}">Next</a>
						</li>
					</c:if>				
				</ul>
			</nav>
		</div>
		<!-- 스크립트 답변 토글 및 관리자 기능 -->
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script>
			$(document).ready(function(){
			
				$(".faq_question").click(function(e){
					e.preventDefault();
					$(this).closest(".dropbox").find(".detail_content").toggle();
				});
				// 처음에는 숨겨두기
				$(".detail_content").hide();
			});
			document.querySelectorAll("#delete-btn").forEach((item)=>{
				item.addEventListener("click", (e)=>{
					e.preventDefault();
					const isTrue = Swal.fire({
				  		title: "질문을  삭제하시겠습니까?",
				  		text: "",
				  		icon: 'warning',
				  		showCancelButton: true,
				  		confirmButtonColor: 'rgb(13, 110, 253)',
				  		cancelButtonColor: 'rgb(248, 162, 146)',
				  		confirmButtonText: '확인',
				  		cancelButtonText: '취소',
						}).then((result) => {
				      	if (result.isConfirmed) {
				      		Swal.fire('삭제 되었습니다.','success');
				      		const faqNum=e.target.getAttribute("data-num");
				      		postTo("${pageContext.request.contextPath}/support/support_faq_delete?faq_num="+faqNum);
				      	}else if(result.isDismissed){
				      		location.href="${pageContext.request.contextPath}/support/support_faq";
				      	}
				    });
				});
			});
			
	</script>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





