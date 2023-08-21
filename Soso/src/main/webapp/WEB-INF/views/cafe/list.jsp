<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	
<h2 style="text-align: center">소모임 게시판</h2>
<div style="width:100%; text-align:right;">
	<a href="${pageContext.request.contextPath }/cafe/insertform?num=${num }" class="btn btn-outline-dark" tabindex="-1" role="small-button" aria-disabled="true" >글 쓰기</a>
</div>
<table class="table">
	<thead class="table-group-divider" style="border-bottom: 1px;">
		<tr>	
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th style="text-align: center">조회수</th>
			<th class="time" style="text-align: center">날짜</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="tmp" items="${cafelist}">
			<tr>
				<td>${tmp.comu_num}</td>
				<td>
					<a style="color: black;" class="text-decoration-none" href="${pageContext.request.contextPath}/cafe/detail?comu_num=${tmp.comu_num}&condition=${condition}&keyword=${encodedK}">${tmp.title}</a>
				</td>
				<td>${tmp.writer }</td>
				<td style="text-align: center">${tmp.viewCount }</td>
				<td style="text-align: center">${tmp.regdate }</td>
			</tr>
		</c:forEach> 
	</tbody>
</table>
<!-- 페이징 처리 -->
<div class="mb-4">
	<ul class="pagination" style="justify-content: center;">
		<c:if test="${startPageNum ne 1 }">
			<li class="page-item">
				<a class="page-link animate__animated" href="list?pageNum=${startPageNum-1 }&condition=${condition}&keyword=${encodedK}">Prev</a>
			</li>
		</c:if>
		<c:forEach var="i" begin="${startPageNum }" end="${endPageNum}">
			<li class="page-item ${pageNum eq i ? 'active' : '' }">
				<a class="page-link animate__animated" href="list?pageNum=${i}&condition=${condition}&keyword=${encodedK}&num=${num}">${i}</a>
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
</div>
<script>
	document.querySelectorAll(".pagination a").forEach(function(item){
		item.addEventListener("mouseover", function(e){
			e.target.classList.add("animate__swing");
		});
		item.addEventListener("animationend", function(e){
			e.target.classList.remove("animate__swing");
		});
	});
</script>
<!-- 검색 폼 -->
<div>
	<div class="d-flex justify-content-center">
		<form class="d-flex" action="list" method="get">
			<select name="condition" id="condition">
				<option value="title_content" ${condition eq 'title_content' ? 'selected' : '' }>제목 + 내용</option>
				<option value="title" ${condition eq 'title' ? 'selected' : '' }>제목</option>
				<option value="writer" ${condition eq 'writer' ? 'selected' : '' }>작성자</option>
			</select>
			<input class="form-control" type="text" name="keyword" placeholder="검색어..." value="${keyword }"/>
			<button type="submit" class="btn btn-outline-dark"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
	 			<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"></path>
			</svg></button>
		</form>
	</div>
</div>




