<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<c:set var="path" value="${pageContext.request.contextPath}"/>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 접수 내역</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/support/support_inquire_MyInquire.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
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
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_faq">자주하는 질문</a>
		</li>
		<li class="menu_notice">
			<a class="nav-link" href="${pageContext.request.contextPath }/support/support_notice">공지사항</a>
		</li>
		<li class="menu_inquire">
			<a class="nav-link active" href="${pageContext.request.contextPath }/support/support_inquire">문의하기</a>
		</li>
	</ul>
		<div class="body_area">
			<div class="main_content">
				<ul class="inquire_navi">
					<c:if test="${isAdmin }">
						<li>
							<a class="cs_inquire" href="${pageContext.request.contextPath }/support/support_inquire_inquireStatus">문의 접수 내역</a>
						</li>
					</c:if>
				</ul>
				<h3 class="title">사용자 문의 접수 내역</h3>
				<table class="table-data">
					<thead>
						<tr>
							<th class="num">번호</th>
							<th class="date">등록일</th>
							<th class="title">문의 제목</th>
							<th class="status">문의 상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="tmp" items="${list2}">
							<tr class="inquire-list">
								<td>
									<table class="main-data">
										<tbody>
											<tr class="summary-data">
												<td class="num">${tmp.cs_num }</td>
												<td class="date">${tmp.regdate }</td>
												<td class="title">
													<a class="inquire_title"href="">${tmp.title }</a>
												</td>
												<td class="status">
													 <c:if test="${empty tmp.answer}">
													        답변대기
													 </c:if>
													 <c:if test="${not empty tmp.answer}">
													 	<p>답변완료</p>
													 </c:if>
												</td>
											</tr>
											<tr class="detail-data">
												<td class="detail-td">
													<div class="inquiry-content">
														<div class="description">
															<button data-num="${tmp.cs_num}" type="submit" class="delete-btn">삭제</button>
															<a class="answer-btn" href="${pageContext.request.contextPath }/support/support_inquire_answerform?cs_num=${tmp.cs_num}">답변등록</a>
															<div class="inquire_question">
																<span class="inquire_q">Q</span>
																<pre id="content">${tmp.content }</pre>
															</div>
															<c:choose>
															<c:when test="${not empty tmp.answer }">
															<div class="inquire_answer">
																<span class="inquire_a">A</span>
																<pre id="answer">${tmp.answer }</pre>
															</div>
															</c:when>
															<c:otherwise>
																
															</c:otherwise>
															</c:choose>
														</div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script>
				$(document).ready(function(){
					$(".inquire_title").click(function(e){
						e.preventDefault();
						$(this).closest(".main-data").find(".detail-td").toggle();
					});
					// 처음에는 숨겨두기
					$(".detail-td").hide();
				});
				document.querySelectorAll(".delete-btn").forEach((item)=>{
					item.addEventListener("click", (e)=>{
						e.preventDefault();
						const isTrue = Swal.fire({
					  		title: "문의를 삭제하시겠습니까?",
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
					      		const csNum=e.target.getAttribute("data-num");
								postTo("${pageContext.request.contextPath}/support/support_inquire_delete?cs_num=" + csNum);
					      	}else if(result.isDismissed){
					      		location.href="${pageContext.request.contextPath}/support/support_inquire_inquireStatus";
					      	}
					    });
					});	
				});
		</script>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>





