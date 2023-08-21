<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_list.css" />
<!-- 커뮤니티 글 목록 -->

<div class="cafe_table">           
    <div class="cafe_search">
		<form class="d-flex" action="list" method="get">
		<input class="form-control" type="text" name="keyword" placeholder="검색어..." value="${keyword }"/>
			<select name="condition" id="condition">
				<option value="title_content" ${condition eq 'title_content' ? 'selected' : '' }>제목 + 내용</option>
				<option value="title" ${condition eq 'title' ? 'selected' : '' }>제목</option>
				<option value="writer" ${condition eq 'writer' ? 'selected' : '' }>작성자</option>
			</select>
			<button type="submit">검색</button>
		</form>
	</div>
	<div class="cafe_insert">
		<a href="${pageContext.request.contextPath }/cafe/insertform?num=${num }" aria-disabled="true" >글 쓰기</a>
	</div>
        <div class="table__body">
            <table>
                <thead>
                    <tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>날짜</th>
                    </tr>
                </thead>
                <tbody>
					<c:forEach var="tmp" items="${cafelist}">
						<tr>
							<td>${tmp.comu_num}</td>
							<td class="title">
								<a href="${pageContext.request.contextPath}/cafe/detail?comu_num=${tmp.comu_num}&group_num=${num}&condition=${condition}&keyword=${encodedK}">${tmp.title}</a>
							</td>
							<td>${tmp.writer }</td>
							<td>${tmp.viewCount }</td>
							<td>${tmp.regdate }</td>
						</tr>
					</c:forEach> 
				</tbody>
            </table>
        </div>
        <!-- 페이징 처리 -->
		<div class="mb-4">
			<ul class="pagination" style="justify-content: center;">
				<c:if test="${startPageNum ne 1 }">
					<li class="page-item">
						<a class="page-link animate__animated" 
							href="${pageContext.request.contextPath}/group_managing/group_userdetail?pageNum=${startPageNum-1 }&condition=${condition}&keyword=${encodedK}&num=${num}">Prev</a>
					</li>
				</c:if>
				<c:forEach var="i" begin="${startPageNum}" end="${endPageNum}">
					<li class="page-item ${pageNum eq i ? 'active' : '' }">
						<a class="page-link animate__animated" 
							href="${pageContext.request.contextPath}/group_managing/group_userdetail?pageNum=${i}&condition=${condition}&keyword=${encodedK}&num=${num}">${i}</a>
					</li>
				</c:forEach>
				<c:if test="${endPageNum lt totalPageCount }">
					<li class="page-item">
						<a class="page-link animate__animated" 
							href="${pageContext.request.contextPath}/group_managing/group_userdetail?pageNum=${endPageNum+1 }&condition=${condition}&keyword=${encodedK}&num=${num}">Next</a>
					</li>
				</c:if>				
			</ul>
		</div>
</div>


