<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/support_faq_insertform</title>
<style>
	.noticeBtn{
	width: 240px;
    height: 60px;
    margin: 0 auto;
    display: block;
    border: 1px solid gray;
    border-radius: 30px;
    background-color: gray;
    color: white;
    font-size: 18px;
    text-align: center;
	}
</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_inquire.css" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<!-- 상단 배너 -->
	<div class="head">
		<h2 class="main_title">Notice 관리</h2>
		<p class="sub_text">공지사항을 수정할 수 있습니다.</p>
	</div>
	<!-- 메인 메뉴바 시작 -->
	<div class="main_area">
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
		<li class="menu_inquire">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_inquire">문의하기</a>
		</li>
	</ul>
		<div class="body_area">
			<div class="main_content">
				<h3>공지사항 수정</h3>
				<form action="${pageContext.request.contextPath }/support/support_notice_update" class="area_form" method="post">
					<div class="row-wrap">
						<input type="hidden" name="notice_num" value="${dto.notice_num }"/>
						<div class="input_title">
							<h4 class="label">공지</h4>
						
							<select name="category" id="category" class="title_select">
								<option selected="selected" class="inquire_select">분류</option>
								<option value="1" ${dto.category == 1 ? 'selected' : '' }>공지</option>
								<option value="2" ${dto.category == 2 ? 'selected' : '' }>업데이트</option>
								<option value="3" ${dto.category == 3 ? 'selected' : '' }>휴무</option>
								<option value="0" ${dto.category == 0 ? 'selected' : '' }>기타</option>
							</select>
							<input value="${dto.title }"type="text" class="inquire_title" name="title" id="title" placeholder="제목을 입력해주세요" />
						</div>
					</div>
					<div class="row-wrap">
						<div class="input_text">
							<h4 class="label">내용 *</h4>
							<textarea name="content" id="content" placeholder="내용을 입력 해 주세요.">${dto.content }</textarea>
						</div>
					</div>
			
					<p class="info_message">
						이 사이트는 reCAPTCHA에 의해 보호되며 Google 개인 정보 취급 방침 및 서비스 약관이 적용됩니다.
					</p>
					<button type="submit" class="noticeBtn">수정하기</button>
			
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





