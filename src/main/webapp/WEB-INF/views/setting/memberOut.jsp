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
<title>회원 탈퇴 | 인겜토리</title>
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
		
	    const text = document.getElementById('textwrite');
	    const submitBtn = document.getElementById('memberOutBtn');

	    function validateForm() {
	        isValid = true;

	        if (text.value.trim() != '탈퇴하겠습니다') {
	            text.classList.add('error-form');
	            isValid = false;
	        } else {
	        	isValid = true;
	        	text.classList.remove('error-form');
	        }

	        submitBtn.disabled = !isValid;
	    }
	    text.addEventListener('input', validateForm);
	    
	    validateForm();
	 	    
	});
	
	function memberOut() {
		if(isValid != true) return false;
		
		let ans = confirm("정말로 탈퇴하시겠습니까?");
		
		if(ans) {
			location.href='${ctp}/member/memberOutOk';
		}
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
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/pwdChange';">비밀번호 변경</div>
				<hr/>
				<div class="left-menu-title">기타</div>
				<div class="left-menu-box" style="font-weight: bold; color:#00c722;">계정 탈퇴</div>
				<c:if test="${sKakao == 'OK'}"><div class="left-menu-box" onclick="javascript:kakaoLogout()">로그아웃</div></c:if>
		        <c:if test="${sKakao == 'NO'}"><div class="left-menu-box" onclick="location.href='${ctp}/member/memberLogout';">로그아웃</div></c:if>
			</div>
			<div class="setting-right">
				<h2>회원 탈퇴</h2>
				<div class="warning-info">📌 회원 탈퇴시 복구할 수 없으며 가입 시 사용했던 이메일은 재사용할 수 없습니다.<br/>
				그리고 작성했던 리뷰, 댓글, 팔로우, 팔로워가 전부 사라집니다!<br/>
				그런데도 탈퇴하시겠다면 아래 하단 입력창에 '탈퇴하겠습니다'를 적어주세요</div>
				<div class="setting-title mt-5">입력창</div>
				<input type="text" name="textwrite" id="textwrite" placeholder="탈퇴하겠습니다" class="form-control forminput mb-5" style="width: 100%;" />
				<div class="text-right mt-5"><button id="memberOutBtn" class="joinBtn" disabled="disabled" onclick="memberOut()">탈퇴하기</button></div>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>