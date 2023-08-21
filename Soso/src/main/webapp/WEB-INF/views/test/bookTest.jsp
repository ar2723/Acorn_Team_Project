<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
<script src="${path }/resources/js/jquery.easing.1.3.js"></script>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<meta charset="UTF-8">
		<title>book::list</title>
	</head>
	<body>
		<h3>네이버 오픈 API를 활용한 도서 목록</h3>		
		<table border="1">
			<c:forEach var="tmp" items="${books }">
				<tr>
					<td>${tmp.isbn }</td>
					<td><img src="${tmp.image }" alt="${tmp.title }" width="100" /></td>
					<td><a href="${tmp.link }">${tmp.title }</a></td>
					<td>${tmp.description }</td>
					<td>
						<form action="${pageContext.request.contextPath}/test/saveBook" method="post">
							<label for="saveBook">책을 DB에 저장(임시)</label>
							<input type="text" id="title" name="title" value ="${tmp.title }" hidden />
							<input type="text" id="link" name="link" value ="${tmp.link }" hidden />
							<input type="text" id="image" name="image" value ="${tmp.image }" hidden />
							<input type="text" id="isbn" name="isbn" value ="${tmp.isbn }" hidden />
							<input type="text" id="description" name="description" value ="${tmp.description }" hidden />
							<button type="submit">저장</button>
						</form>
					</td>
				</tr>
			</c:forEach>
		</table>
	</body>
</html>