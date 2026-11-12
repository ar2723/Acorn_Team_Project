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
				<th>번호</th>
				<th>구분</th>
				<th>제목</th>
				<th>작성일</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="tmp" items="${list }">
				<tr>
					<td>${tmp.num}</td>
					<td>
						<c:choose>
							<c:when test="${tmp.header == 1}">
								책 제목
							</c:when>
							<c:when test="${tmp.header == 2}">
								사진 / 영상
							</c:when>
							<c:when test="${tmp.header == 3}">
								수다
							</c:when>
							<c:when test="${tmp.header == 4}">
								정보 / 일정
							</c:when>
						</c:choose>
					</td>
					<td>
						<a href="${pageContext.request.contextPath}/cafe/detail?comu_num=${tmp.num}&group_num=${tmp.group_num}">${tmp.title }</a>
					</td>
					<td>${tmp.regdate}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<nav class="d-flex justify-content-center">
		<ul class="pagination">
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
			<c:if test="${endPageNum lt totalPageCount }">
				<li class="page-item">
					<a class="page-link animate__animated" href="list?pageNum=${endPageNum+1 }&condition=${condition}&keyword=${encodedK}">Next</a>
				</li>
			</c:if>				
		</ul>
	</nav>
</body>
</html>