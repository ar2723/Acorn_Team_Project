<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">

<link rel="shortcut icon" type="image/x-icon" href="https://genfavicon.com/tmp/icon_7cacead7cd8483ca41a810db418dc8ab.ico">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_main.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
		<!-- 메인 메뉴바 -->
		<ul class="menu_bar">
			<li class="menu_home">
				<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_main">고객센터</a>
			</li>
			<li class="menu_faq">
				<a class="nav-link" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
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
		<!-- 메인 컨텐츠 -->
		<div class="main_content">
		<!-- 자주하는 질문 세션 -->
		<div class="area_faq">
			<h2 class="faq_title">자주하는 질문 10</h2>
			<a class="faq_more" href="${pageContext.request.contextPath }/support/support_faq">주제별 FAQ 더보기</a>
			<ul>
				<c:forEach var="tmp" items="${list }">
					<li class="dropbox">
						<span class="faq_category">
							<c:choose>
								<c:when test="${tmp.category == 1}">회원</c:when>
								<c:when test="${tmp.category == 2}">모임신청</c:when>
								<c:when test="${tmp.category == 3}">모임개설</c:when>
								<c:when test="${tmp.category == 0}">기타</c:when>
							</c:choose>
						</span>
						<p>
							<a class="faq_question" href="${pageContext.request.contextPath }/support/support_faq?faq_num=${tmp.faq_num}">${tmp.question }</a>
						</p>
					</li>
				</c:forEach>
			</ul>
		</div>
		<!-- 공지사항 세션 -->
		<div class="area_notice">
				<h2 class="title">공지사항</h2>
				<a class="view_more" href="${pageContext.request.contextPath }/support/support_notice">더보기</a>
				<ul>
					<c:forEach var="tmp" items="${notice_list }">
					<li>
						<a class="notice_title" href="${pageContext.request.contextPath }/support/support_notice_detail?notice_num=${tmp.notice_num}">${tmp.title}</a>
					</li>
					</c:forEach>
				</ul>
		</div>
		<!-- 운영시간 세션 -->
		<div class="area_contact">
				<h2 class="title">북메이트 운영시간 및 연락처</h2>
				<dl>
					<dt>상담시간</dt>
					<dd>
						월~금요일
						<span style="color:rgb(157 128 63); font-weight:bold">9:00 ~ 17:30</span>
						<span style="font-size:14px">(Break Time 12:00~13:00)</span>
					</dd>
					<dd>
						<span>메일문의</span>
						<span>tttmmm100@naver.com</span>
					</dd>
					<dd>
						<span>전화문의</span>
						"02-3500-3050"
					</dd>
				</dl>
			</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





