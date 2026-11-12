<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<div class="altertable">
		<table class="table table-striped">
			<thead class="table-dark">
				<tr>
					<th>등록일</th>
					<th>문의 제목</th>
					<th>답변 여부</th>
				</tr>
			</thead>
			<tbody>			
				<c:forEach var="tmp" items="${list }">
					<tr>
						<td>${tmp.regdate}</td>
						<td>
							<a href="${pageContext.request.contextPath}/support/support_inquire_MyInquire">${tmp.title}</a>
						</td>
						<td>
							<c:if test="${empty tmp.answer}">
								답변대기
							</c:if>
							<c:if test="${not empty tmp.answer}">
								답변완료
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<nav class="d-flex justify-content-center">
			<ul class="pagination">
				<c:if test="${startPageNum ne 1 }">
					<li class="page-item">
						<a class="page-link support-link" href="${pageContext.request.contextPath}/users/info/support_list?pageNum=${startPageNum-1 }&condition=${condition}&keyword=${encodedK}">Prev</a>
					</li>
				</c:if>
				<c:forEach var="i" begin="${startPageNum }" end="${endPageNum }">
					<li class="page-item ${pageNum eq i ? 'active' : '' }">
						<a class="page-link support-link" href="${pageContext.request.contextPath}/users/info/support_list?pageNum=${i }&condition=${condition}&keyword=${encodedK}" data-page-num=${i}>${i }</a>
					</li>
				</c:forEach>
				<c:if test="${endPageNum lt totalPageCount }">
					<li class="page-item">
						<a class="page-link support-link" href="${pageContext.request.contextPath}/users/info/support_list?pageNum=${endPageNum+1 }&condition=${condition}&keyword=${encodedK}">Next</a>
					</li>
				</c:if>				
			</ul>
		</nav>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function() {
			$(document).on("click", ".support-link", function(e) {
				e.preventDefault(); 
	
				// 클릭한 페이지의 번호를 가져옵니다.
				var pageNum = $(this).data("page-num");
	
				// AJAX 처리를 통해 페이지 내용을 갱신하는 코드를 추가합니다.
				$.ajax({
					type: "GET",
					url: "${pageContext.request.contextPath}/users/info/support_list?&pageNum=" + pageNum,
					dataType: "text",
					error: function() {
						console.log("통신실패");
					},
					success: function(data) {
						// 받아온 데이터를 사용하여 페이지 내용을 갱신하는 코드를 작성합니다.
						$(".altertable").html(data);
					}
				});
			});
		});
		
	</script>
</body>
</html>