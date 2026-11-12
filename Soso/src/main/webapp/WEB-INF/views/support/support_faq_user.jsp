<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주하는 질문 - 회원</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_faq.css" />

<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<!-- 상단 배너 -->
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
			<a class="nav- active" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
		</li>
		<li class="menu_notice">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_notice">공지사항</a>
		</li>
		<li class="menu_inquire">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_inquire">문의하기</a>
		</li>
	</ul>
	<!-- 메인 메뉴바 끝 -->
	<!-- 검색 창 시작 -->
	<div class="search">
		<form action="" class="search_form" method="get">
			<input type="text" name="" id="" class="search_main" placeholder="예) 회원가입, 로그인, 결제 등" />
			<input type="submit" class="search_cs" value="" />
		</form>
	</div>
	<!-- 검색 창 끝 -->
		<div class="main_content">
			<div class="tab_section">
			<ul class="tab_menu">
				<li class="">
					<a href="${pageContext.request.contextPath }/support/support_faq?">전체(${categoryAllRow })</a>
				</li>
				<li class="active">
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
			</div>
			<h3 class="faq">회원(${categoryOneRow})</h3>
			<div class="tab_content">
			<ul>
				<c:forEach var="tmp" items="${list}">
					<c:if test="${tmp.category eq '1'}">
					<li class="dropbox">
						<button type="button" class="btn_more">답변</button>
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
								<a class="faq_question" href="">${tmp.question}</a>
							</h5>
						</div>
						<div class="detail_content">
							<span style="line-height: 24px;">
								<pre>${tmp.answer }</pre>
							</span>
							<c:if test="${isAdmin }">
								<button type="submit" data-num="${tmp.faq_num}" class="admin_delbutton" id="delete-btn">삭제</button>
							</c:if>
						</div>
					</li>
					</c:if>
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
	<div>
	<!-- 페이징 처리 -->
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
		document.querySelectorAll(".pagination a").forEach(function(item){
			//item 은 a 의 참조값이다 모든 a 요소에 mouseover 이벤트가 발생했을때 실행할 함수 등록
			item.addEventListener("mouseover", function(e){
				//애니메이션 클래스를 추가해서 애니메이션이 동작하도록한다.
				e.target.classList.add("animate__swing");
			});
			//item 은 a 의 참조값이다 모든 a 요소에 animationend 이벤트가 발생했을때 실행할 함수 등록
			item.addEventListener("animationend", function(e){
				//애니메이션 클래스를 제거해서 다음번에 추가 되면 다시 애니매이션이 동작 되도록한다.
				e.target.classList.remove("animate__swing");
			});
		});
		$(document).ready(function(){
			
			$(".faq_question").click(function(e){
				e.preventDefault();
				$(this).closest(".dropbox").find(".detail_content").toggle();
			});
			// 처음에는 숨겨두기
			$(".detail_content").hide();
		});
	</script>
	</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





