<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀 번호 수정</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="pwd_update" name="current"/>
    </jsp:include>
    <div class="container">
        <p class="title">비밀번호 수정</p>
        <form action="${pageContext.request.contextPath}/users/pwd_update" method="post" id="myForm">
            <div>
                <label class="form-label mb-2" for="newPwd">새 비밀번호</label>
                <div class="input-group">
                    <input class="form-control" type="password" name="newPwd" id="newPwd"/>
                    <button class="btn btn-outline-gray bi-eye-slash" type="button" id="openpwd"></button>
                </div>
                <div class="invalid-feedback pwd-feedback">최소 8자 이상으로 문자와 숫자, 특수 문자를 각각 하나 이상 조합하세요.</div>
            </div>
            <div class="mt-2">
                <label class="form-label mb-2" for="newPwd2">새 비밀번호 확인</label>
                <div class="input-group">
                    <input class="form-control" type="password" id="newPwd2"/>
                    <button class="btn btn-outline-gray bi-eye-slash" type="button" id="openpwd2"></button>
                </div>
                <div class="invalid-feedback pwd2-feedback">비밀번호가 일치하지 않습니다.</div> 
            </div>
            <div class="d-flex justify-content-center mt-3">
            	<button class="btn btn-join me-4" type="submit" disabled>수정하기</button>
            	<button class="btn btn-cancle" type="reset">리셋</button>
            </div>
            
        </form>
    </div>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    <script>
    
        let isPwdValid = false;
        let isPwdValid2 = false;
    
        $("#newPwd").on("input", () => {
            const pwd = $("#newPwd").val();
            const reg = /^(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            isPwdValid = reg.test(pwd);
    
            if (pwd !== '') {
                if (isPwdValid) {
                    $("#newPwd").removeClass("is-invalid").addClass("is-valid");
                    $(".invalid-feedback.pwd-feedback").hide();
                } else {
                    $("#newPwd").removeClass("is-valid").addClass("is-invalid");
                    $(".invalid-feedback.pwd-feedback").show();
                }
            } else {
                $("#newPwd").removeClass("is-valid is-invalid");
                $(".invalid-feedback.pwd-feedback").hide();
                isPwdValid = false;
            }
    
            checkFormState();
        });
    
        $("#newPwd2").on("input", () => {
            const pwd = $("#newPwd").val();
            const pwd2 = $("#newPwd2").val();
    
            if (pwd2 === '') {
                $(".invalid-feedback").hide(); // 모든 invalid-feedback 숨기기
                $(".pwd2-feedback").hide(); // 새 비밀번호 확인과 관련된 invalid-feedback 숨기기
                isPwdValid2 = false;
            } else {
                if (pwd === pwd2) {
                    $("#newPwd2").removeClass("is-invalid").addClass("is-valid");
                    $(".invalid-feedback").hide(); // 모든 invalid-feedback 숨기기
                    $(".pwd2-feedback").hide(); // 새 비밀번호 확인과 관련된 invalid-feedback 숨기기
                    isPwdValid2 = true;
                } else {
                    $("#newPwd2").removeClass("is-valid").addClass("is-invalid");
                    $(".invalid-feedback").hide(); // 모든 invalid-feedback 숨기기
                    $(".pwd2-feedback").show(); // 새 비밀번호 확인과 관련된 invalid-feedback 보이기
                    isPwdValid2 = false;
                }
            }
    
            checkFormState();
        });
    
        function checkFormState() {
            const isAllValid = isPwdValid && isPwdValid2;
            $("button[type=submit]").prop("disabled", !isAllValid);
        }

        $(document).ready(function(){
        // 눈 아이콘을 누르면 입력한 비밀번호가 보이도록 설정
            $('button[id=openpwd]').on('click', function() {
                $('#newPwd').toggleClass('active');
                if ($('#newPwd').hasClass('active')) {
                    $(this).attr('class', "btn btn-outline-secondary bi-eye")
                    $('#newPwd').attr('type', 'text');
                } else {
                    $(this).attr('class', "btn btn-outline-secondary bi-eye-slash")
                    $('#newPwd').attr('type', 'password');
                }
            });
            $('button[id=openpwd2]').on('click', function() {
                $('#newPwd2').toggleClass('active');
                if ($('#newPwd2').hasClass('active')) {
                    $(this).attr('class', "btn btn-outline-secondary bi-eye")
                    $('#newPwd2').attr('type', 'text');
                } else {
                    $(this).attr('class', "btn btn-outline-secondary bi-eye-slash")
                    $('#newPwd2').attr('type', 'password');
                }
            });
        })
    </script>
</body>
</html>