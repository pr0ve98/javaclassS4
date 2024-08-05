<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width" />
<title>비밀번호 변경 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	let submitOK = false;
	let isValid = true;
	
	document.addEventListener('DOMContentLoaded', function() {
 	    const mid = document.getElementById('mid');
 	    const submitBtn = document.getElementById('submitBtn');

 	    const midError = document.getElementById('mid-error');
 	    
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';

 	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
		
	    const nowpwd = document.getElementById('nowpwd');
	    const pwd = document.getElementById('changepwd');
	    const repwd = document.getElementById('changepwd2');
	    const submitBtn = document.getElementById('pwdChangeBtn');
	    
	    const pwdError = document.getElementById('pwd-error');
	    const repwdError = document.getElementById('repwd-error');

	    function validateForm() {
	        isValid = true;

	        if (nowpwd.value.trim() === '') {
	            isValid = false;
	        }

	        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4,}$/;
	        if (!pwdReg.test(pwd.value)) {
	            pwdError.textContent = '4자 이상 영문,숫자,특수문자';
	            pwdError.style.display = 'inline';
	            pwd.classList.add('error-form');
	            isValid = false;
	        } else {
	            pwdError.style.display = 'none';
	            pwd.classList.remove('error-form');
	        }

	        if (pwd.value !== repwd.value) {
	            repwdError.textContent = '비밀번호가 일치하지 않습니다';
	            repwdError.style.display = 'inline';
	            repwd.classList.add('error-form');
	            isValid = false;
	        } else {
	            repwdError.style.display = 'none';
	            repwd.classList.remove('error-form');
	        }

	        submitBtn.disabled = !isValid;
	    }

	    nowpwd.addEventListener('input', validateForm);
	    repwd.addEventListener('input', validateForm);
	    pwd.addEventListener('input', validateForm);
	    
	    validateForm();
	 	    
	});
	
	function pwdChange() {
	    let nowpwd = document.getElementById('nowpwd').value;
	    let pwd = document.getElementById('changepwd').value;
	    let repwd = document.getElementById('changepwd2').value;
		
		if(isValid != true) return false;
		
		$.ajax({
			url : "${ctp}/member/pwdChange",
			type : "post",
			data : {nowpwd:nowpwd, pwd:pwd},
			success : function(res) {
				if(res == "0") {
					alert("현재 비밀번호가 일치하지 않습니다!");
				}
				else if(res == "2"){
					alert("카카오 로그인 유저는 비밀번호를 변경할 수 없습니다.");
				}
				else {
					alert("변경 완료!");
					location.reload();
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="container">
		<div class="setting-main">
			<div class="setting-left">
				<div class="left-menu-title">계정관리</div>
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/profile';">프로필 변경</div>
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/pwdChange';" style="font-weight: bold; color:#00c722;">비밀번호 변경</div>
				<hr/>
				<div class="left-menu-title">기타</div>
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/memberOut';">계정 탈퇴</div>
				<c:if test="${sKakao == 'OK'}"><div class="left-menu-box" onclick="javascript:kakaoLogout()">로그아웃</div></c:if>
		        <c:if test="${sKakao == 'NO'}"><div class="left-menu-box" onclick="location.href='${ctp}/member/memberLogout';">로그아웃</div></c:if>
			</div>
			<div class="setting-right">
				<h2>비밀번호 변경</h2>
				<div class="setting-title">현재 비밀번호</div>
				<input type="password" name="nowpwd" id="nowpwd" placeholder="현재 비밀번호" class="form-control forminput mb-5" style="width: 100%;" />
				<div class="setting-title">변경할 비밀번호</div>
				<input type="password" name="changepwd" id="changepwd" placeholder="변경할 비밀번호" class="form-control forminput" style="width: 100%;" />
				<span id="pwd-error" class="error-message"></span>
				<input type="password" name="changepwd2" id="changepwd2" placeholder="변경할 비밀번호 재입력" class="form-control forminput" style="width: 100%;" />
				<span id="repwd-error" class="error-message"></span>
				<div class="text-right mt-5"><button id="pwdChangeBtn" class="joinBtn" disabled="disabled" onclick="pwdChange()">비밀번호 변경</button></div>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>