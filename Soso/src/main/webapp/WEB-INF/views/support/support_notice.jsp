<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<c:set var="path" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_notice.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
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
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
		</li>
		<li class="menu_notice">
			<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_notice">공지사항</a>
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
	<!-- 공지사항 메인 컨텐츠 -->
	<div class="content_wrap">
		<div class="main_content">
			<h3 class="title">공지사항</h3>
			<table class="notice">
				<thead>
					<tr>
						<th class="category">분류</th>
						<th class="title">제목</th>
						<th class="date">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="tmp" items="${notice_list }">
					<tr>
						<td class="td_category">
							<c:choose>
								<c:when test="${tmp.category == 1}">공지</c:when>
								<c:when test="${tmp.category == 2}">업데이트</c:when>
								<c:when test="${tmp.category == 3}">휴무</c:when>
								<c:when test="${tmp.category == 0}">기타</c:when>
							</c:choose>
						</td>
						
						<td class="title">
							<a  class="notice_title" href="${pageContext.request.contextPath }/support/support_notice_detail?notice_num=${tmp.notice_num}">${tmp.title }</a>
						</td>
						<td>${tmp.regdate }
							<c:if test="${isAdmin }">
								<button type="submit" data-num="${tmp.notice_num}" class="admin_delbutton" id="delete-btn">삭제</button>
							</c:if>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
			<!-- 관리자 메뉴 -->
			<div class="admin_menu">
				<c:if test="${isAdmin}">
					<a href="${pageContext.request.contextPath }/support/support_notice_insertform" class="admin_button">공지 등록</a>
				</c:if>
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
			      		location.href="${pageContext.request.contextPath}/support/support_notice";
			      	}
			    });
			});	
		});
			
	</script>
	<!-- 페이지네이션 시작 -->
	<div class="pagination_wrap">
		<nav class="pagination">
			<ul class="pagination_ul">
				<%--
					startPageNum 이 1 이 아닌 경우에만 Prev 링크를 제공한다. 
					&condition=${condition}&keyword=${encodedK}
				 --%>
				<c:if test="${startPageNum ne 1 }">
					<li class="page-item">
						<a href="support_notice?pageNum=${startPageNum-1 }">이전</a>
					</li>
				</c:if>
				<c:forEach var="i" begin="${startPageNum }" end="${endPageNum }">
					<li class="page-item ${pageNum eq i ? 'active' : '' }">
						<a href="support_notice?pageNum=${i }">${i }</a>
					</li>
				</c:forEach>
				<%--
					마지막 페이지 번호가 전체 페이지의 갯수보다 작으면 Next 링크를 제공한다. 
				 --%>
				<c:if test="${endPageNum lt totalPageCount }">
					<li class="page-item">
						<a href="support_notice?pageNum=${endPageNum+1 }">></a>
					</li>
				</c:if>				
			</ul>
		</nav>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





