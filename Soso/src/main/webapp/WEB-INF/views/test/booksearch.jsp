<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
<script src="${path }/resources/js/jquery.easing.1.3.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그룹에 넣고 싶은 책을 찾아봅시다.</title>
</head>
<body>
	<div class="container">
		<!-- method를 get으로 하면 주소창을 통해 text를 보낼 수 있다. -->
		<form action="${pageContext.request.contextPath}/test/bookTest" method="get">
			<label for="search">찾기</label>
			<input type="text" id="search" name="search" value=""/>
			<button type="button" id="searchBook">찾기</button>
		</form>
	</div>
	<!-- 여기에 목록을 출력한다. -->
    <div id="Parse_Area"gt;lt;></div>

	<script>
	//ajax로 페이지 전환 없이 검색결과 표시
    function performSearch() {
        var searchValue = $("#search").val();
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/test/bookTest",
            data: {
                search: searchValue
            },
            dataType: "text",
            error: function () {
                console.log("통신실패");
            },
            success: function (Parse_data) {
                $("#Parse_Area").html(Parse_data);
                console.log("통신 데이터 값: " + Parse_data);
            }
        });
    }

    // "click" 이벤트 처리
    $("#searchBook").click(function (event) {
        event.preventDefault();
        performSearch();
    });

    // "keydown" 이벤트 처리
    $("#search").keydown(function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            performSearch();
        }
    });
	</script>
</body>
</html>