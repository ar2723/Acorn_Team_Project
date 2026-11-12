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
	<table class="table table-striped">
		<thead class="table-dark">
			<tr>
				<th>문의 번호</th>
				<th>문의 제목</th>
				<th>작성일</th>
			</tr>
		</thead>
		<tbody>
			
			<c:forEach var="tmp" items="${list }">
				<tr>
					<td>${tmp.num }</td>
					<td>
						<a href="">${tmp.title }</a>
					</td>
					<td>${tmp.regdate }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<nav>
		<ul class="pagination">
			<%--
				startPageNum 이 1 이 아닌 경우에만 Prev 링크를 제공한다. 
				&condition=${condition}&keyword=${encodedK}
			 --%>
			<c:if test="${startPageNum ne 1 }">
				<li class="page-item">
					<a class="page-link animate__animated" href="list?pageNum=${startPageNum-1 }&condition=${condition}&keyword=${encodedK}">Prev</a>
				</li>
			</c:if>
			<c:forEach var="i" begin="${startPageNum }" end="${endPageNum }">
				<li class="page-item ${pageNum eq i ? 'active' : '' }">
					<a class="page-link animate__animated" href="list?pageNum=${i }&condition=${condition}&keyword=${encodedK}">${i }</a>
				</li>
			</c:forEach>
			<%--
				마지막 페이지 번호가 전체 페이지의 갯수보다 작으면 Next 링크를 제공한다. 
			 --%>
			<c:if test="${endPageNum lt totalPageCount }">
				<li class="page-item">
					<a class="page-link animate__animated" href="list?pageNum=${endPageNum+1 }&condition=${condition}&keyword=${encodedK}">Next</a>
				</li>
			</c:if>				
		</ul>
	</nav>
</body>
</html>