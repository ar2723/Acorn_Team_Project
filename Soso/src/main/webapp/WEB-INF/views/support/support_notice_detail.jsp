<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_notice_detail.css" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
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
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_main">고객센터</a>
		</li>
		<li class="menu_faq">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
		</li>
		<li class="menu_notice">
			<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_notice">공지사항</a>
		</li>
		<li class="menu_inquire">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_inquire">문의하기</a>
		</li>
	</ul>
	<!-- 메인컨텐츠 -->
		<div class="body_area">
			<div class="main_content">
				<h3 class="detail_title">공지사항</h3>
				<article class="detail_notice">
					<input type="hidden" name="notice_num" value="${dto.notice_num }"/>
					<div class="notice_head">
						<h6 class="title">${dto.title }</h6>
						<span class="info">
							<span>작성일 : ${dto.regdate }</span>
						</span>
					</div>
					<div class="notice_content">
						<textarea cols="30" rows="25" readonly>${dto.content }</textarea>
					</div>
					<p class="info_message">
						이 사이트는 reCAPTCHA에 의해 보호되며 Google 개인 정보 취급 방침 및 서비스 약관이 적용됩니다.
					</p>
					
					<div class="admin_menu">
					<div>
						<a class="btn_list" href="${pageContext.request.contextPath }/support/support_notice">목록</a>
					</div>
					<c:if test="${isAdmin }">
						<button data-num="${dto.notice_num }"type="submit" class="btn_list" id="delete-btn">삭제</button>
					</c:if>
					</div>
				</article>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		document.querySelectorAll("#delete-btn").forEach((item)=>{
			item.addEventListener("click", (e)=>{
				e.preventDefault();
				const isTrue = Swal.fire({
			  		title: "공지를 삭제하시겠습니까?",
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
			      		const noticeNum=e.target.getAttribute("data-num");
			      		postTo("${pageContext.request.contextPath}/support/support_notice_delete?notice_num="+noticeNum);
			      	}else if(result.isDismissed){
			      		location.href="${pageContext.request.contextPath}/support/support_detail?notice_num="+noticeNum;
			      	}
			    });
			});	
		});
			
	</script>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>