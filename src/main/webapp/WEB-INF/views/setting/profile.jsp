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
<title>프로필 설정 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	let submitOK = false;
	
	document.addEventListener('DOMContentLoaded', function() {
 	    const mid = document.getElementById('mid');
 	    const submitBtn = document.getElementById('submitBtn');

 	    const midError = document.getElementById('mid-error');
 	    
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';

        // 파일 입력 요소에 change 이벤트 리스너 추가
        document.getElementById('inputImgs').addEventListener('change', function() {
            memberImgChange();
        });

 	    function validateForm() {
 	    	submitOK = false;
 	       midError.classList.remove('loding-msg');
 	       midError.classList.remove('success-msg');

 	        const midReg = /^[a-zA-Z0-9_-]{4,20}$/;
 	        if (!midReg.test(mid.value)) {
 	        	midError.textContent = '잘못된 형식입니다';
 	        	midError.style.display = 'block';
 	        	mid.classList.add('error-form');
 	        } else {
 	        	midError.textContent = '중복 확인을 위해 검색중입니다';
 	        	midError.style.display = 'block';
 	        	midError.classList.add('loding-msg');
 	        	
 	        	$.ajax({
 	        		url : "${ctp}/member/memberIdCheck",
 	        		type : "post",
 	        		data : {mid : mid.value},
 	        		success : function(res) {
						if(res != "0") {
			 	        	midError.textContent = '사용할 수 있는 아이디입니다';
			 	        	midError.style.display = 'block';
			 	        	midError.classList.add('success-msg');
			 	        	mid.classList.remove('error-form');
			 	        	submitOK = true;
						}
						else {
			 	        	midError.textContent = '중복된 아이디입니다';
			 	        	midError.style.display = 'inline';
			 	        	midError.classList.remove('loding-msg');
						}
					},
					error : function() {
						alert("전송오류!");
					}
 	        	});
 	        }

 	    }
 	    mid.addEventListener('input', validateForm);
 	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
	});
	
	function idChange() {
		let mid = document.getElementById('mid').value;
		
		if(submitOK != true) return false;
		
		$.ajax({
			url : "${ctp}/member/memberIdChange",
			type : "post",
			data : {mid:mid},
			success : function(res) {
				if(res != "0") location.reload();
				else alert("변경 실패!");
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	function imageUpload() {
		$("#inputImgs").trigger('click');
	}
	
	function memberImgChange() {
		let fName = document.getElementById("inputImgs").value;
		let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
		let maxSize = 1024 * 1024 * 20 // 기본단위는 Byte, 1024 * 1024 * 10 = 20MB 허용
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'block';
		html.style.overflow = 'hidden';
		
		if(fName.trim() == ""){
			alert("업로드할 파일을 선택하세요");
			return false;
		}
		
		let fileSize = document.getElementById("inputImgs").files[0].size;
		if(fileSize > maxSize){
			alert("업로드할 파일의 최대크기는 20MB입니다");
		}
		else if(ext != 'jpg' && ext != 'png' &&ext != 'gif' &&ext != 'jpeg'){
			alert("이미지 파일만 업로드해주세요");
		}
		else {
			let formData = new FormData();
			formData.append("fName", document.getElementById("inputImgs").files[0]);
			formData.append("mid", '${sMid}');
			
			$.ajax({
				url : "${ctp}/member/memberPhotoChange",
				type : "post",
				data : formData,
				processData: false,
				contentType: false,
				success : function(res) {
					if(res != "0"){
						mask.style.display = 'none';
						html.style.overflow = 'auto';
						location.reload();
					}
					else alert("변경 실패...");
				},
				error : function() {
					alert("오류!!");
				}
			});
		}
	}
	
	function memberEdit() {
		let memInfo = myform.memInfo.value;
		let nickname = myform.nickname.value.trim();
		let level = ${sLevel};
		
		if(level != 0 && nickname.toLowerCase().indexOf("gm") != -1) {
			alert("닉네임에 GM을 사용할 수 없어요!");
			return false;
		}
		
		$.ajax({
			url : "${ctp}/member/memberEdit",
			type : "post",
			data : {nickname : nickname, memInfo : memInfo},
			success : function(res) {
				if(res == "1") {
					alert("변경완료!");
					location.reload();
				}
				else {
					alert("변경에 실패했어요...");
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
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/profile';" style="font-weight: bold; color:#00c722;">프로필 변경</div>
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/pwdChange';">비밀번호 변경</div>
				<hr/>
				<div class="left-menu-title">기타</div>
				<div class="left-menu-box" onclick="location.href='${ctp}/setting/memberOut';">계정 탈퇴</div>
				<c:if test="${sKakao == 'OK'}"><div class="left-menu-box" onclick="javascript:kakaoLogout()">로그아웃</div></c:if>
		        <c:if test="${sKakao == 'NO'}"><div class="left-menu-box" onclick="location.href='${ctp}/member/memberLogout';">로그아웃</div></c:if>
			</div>
			<div class="setting-right">
				<h2>프로필 변경</h2>
				<div class="setting-title">아이디</div>
				<c:if test="${idChange == 'OK'}">
					<input type="text" name="mid" id="mid" value="${sMid}" placeholder="아이디를 입력하세요" maxlength="20" disabled class="form-control forminput" style="width: 100%;" />
					<div class="error-msg" id="mid-error">이미 아이디를 1회 변경하셨어요!</div>
				</c:if>
				<c:if test="${idChange != 'OK'}">
					<input type="text" name="mid" id="mid" value="${sMid}" placeholder="아이디를 입력하세요" maxlength="20" class="form-control forminput" style="width: 100%;" />
					<div class="error-msg" id="mid-error">아이디는 최초 1회만 변경가능하니 신중히 입력해주세요</div>
					<div class="text-right"><button class="joinBtn mb-3" id="submitBtn" onclick="idChange()">아이디 변경</button></div>
				</c:if>
				<hr/>
				<div class="setting-title">프로필 이미지</div>
				<img src="${ctp}/member/${sMemImg}" alt="프로필" class="profile-pic" style="width: 150px; height: 150px;"/>
				<div><button class="joinBtn mt-3 mb-4" onclick="imageUpload()">이미지 변경</button></div>
				<span style="display:none"><input type="file" name="fName" id="inputImgs" accept=".jpg,.gif,.png,.jpeg" /></span>
				<form name="myform">
					<div class="setting-title">닉네임</div>
					<input type="text" name="nickname" id="nickname" value="${sNickname}" placeholder="닉네임을 입력하세요" class="form-control forminput mb-4" style="width: 100%;" />
					<div class="setting-title">자기소개</div>
					<textarea rows="4" name="memInfo" id="memInfo" class="form-control textarea mb-4" placeholder="소개글을 입력하세요">${memInfo}</textarea>
					<div class="text-right"><button class="joinBtn" onclick="memberEdit()">변경사항 저장</button></div>
				</form>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>