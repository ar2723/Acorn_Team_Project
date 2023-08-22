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
	.detail_notice{
		margin-top: 14px;
		border-top: 2px solid black;
	}
	.notice_head{
		line-height: 18px;
		background-color: #f7f7f7;
	}
	.notice_head .info{
		float: right;
		margin-right: 40px;
		font-size: 14px;
	}
	.notice_content {
	    margin: 0 0 20px;
	    padding: 46px 50px 54px;
	    border-top: 1px solid #d3d3d3;
	    border-bottom: 1px solid #d3d3d3;
	    line-height: 19px;
	    overflow: hidden;
	}
	.btn_list{
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
		<h2 class="main_title">공지사항</h2>
		<p class="sub_text">북메이트에서 알려 드립니다.</p>
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
				<h3 style="font-size:20px">공지사항</h3>
				<article class="detail_notice">
					<input type="hidden" name="notice_num" value="${dto.notice_num }"/>
					<div class="notice_head">
						<h6 class="title" style="display:inline-block">${dto.title }</h6>
						<span class="info">
							<span>작성일 : ${dto.regdate }</span>
						</span>
					</div>
					<div class="notice_content">
						<pre>${dto.content }</pre>
					</div>
					<p class="info_message">
						이 사이트는 reCAPTCHA에 의해 보호되며 Google 개인 정보 취급 방침 및 서비스 약관이 적용됩니다.
					</p>
					
					<div style="text-align: center">
						<a class="btn_list" href="${pageContext.request.contextPath }/support/support_notice">목록</a>
					</div>
				</article>
			</div>
		</div>
	</div>
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





