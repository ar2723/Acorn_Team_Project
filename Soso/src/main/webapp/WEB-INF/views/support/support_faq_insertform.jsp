<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<c:set var="path" value="${pageContext.request.contextPath}"/>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주하는 질문 등록</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<style>
	.admin_button{
		width: 130px;
	    height: 48px;
	    display: inline-block;
	    border-radius: 0;
	    border: 1px solid #d8d8d8;
	    background-color: #f7f7f7;
	    text-align: center;
	    line-height: 48px;
	    font-size: 14px;
	    color: #333;
	}
	.admin_button:hover{
		color: rgb(157 128 63);
		font-weight: 600;
	}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_inquire.css" />

<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
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
	<div class="main_area">
	<ul class="menu_bar">
		<li class="menu_home">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_main">고객센터</a>
		</li>
		<li class="menu_faq">
			<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
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
				<h3>질문 등록</h3>
				<form action="${pageContext.request.contextPath }/support/support_faq_insert" class="area_form" method="post" enctype="multipart/form-data">
					<div class="row-wrap">
						<div class="input_title">
							<h4 class="label">질문</h4>
							<select name="category" id="category" class="title_select" required>
								<option value="" selected="selected" disabled class="inquire_select">분류</option>
								<option value="1">회원</option>
								<option value="2">모임신청</option>
								<option value="3">모임개설</option>
								<option value="0">기타</option>
							</select>
							<input type="text" class="inquire_title" name="question" id="question" placeholder="질문을 입력해주세요" />
						</div>
					</div>
					<div class="row-wrap">
						<div class="input_text">
							<h4 class="label">답변 *</h4>
							<textarea name="answer" id="answer" placeholder="답변내용을 입력 해 주세요."></textarea>
						</div>
					</div>
					
					<p class="info_message">
						이 사이트는 reCAPTCHA에 의해 보호되며 Google 개인 정보 취급 방침 및 서비스 약관이 적용됩니다.
					</p>
					<button type="submit" class="admin_button">질문 등록</button>
				</form>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





