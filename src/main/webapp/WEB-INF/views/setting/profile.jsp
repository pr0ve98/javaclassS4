<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>설정 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
	
	let submitOK = false;
	
	document.addEventListener('DOMContentLoaded', function() {
 	    const mid = document.getElementById('mid');
 	    const submitBtn = document.getElementById('submitBtn');

 	    const midError = document.getElementById('mid-error');
 	    

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
 	        	midError.style.display = 'inline';
 	        	mid.classList.add('error-form');
 	        } else {
 	        	midError.textContent = '중복 확인을 위해 검색중입니다';
 	        	midError.style.display = 'inline';
 	        	midError.classList.add('loding-msg');
 	        	
 	        	$.ajax({
 	        		url : "${ctp}/member/memberIdCheck",
 	        		type : "post",
 	        		data : {mid : mid.value},
 	        		success : function(res) {
						if(res != "0") {
			 	        	midError.textContent = '사용할 수 있는 아이디입니다';
			 	        	midError.style.display = 'inline';
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
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="container">
		<div class="setting-main">
			<div class="setting-left">
				<div class="left-menu-title">계정관리</div>
				<div class="left-menu-box">프로필 변경</div>
				<div class="left-menu-box">비밀번호 변경</div>
				<div class="left-menu-title">스토어 관리</div>
				<div class="left-menu-box">구매한 게임키 확인</div>
				<div class="left-menu-title">기타</div>
				<div class="left-menu-box">계정 삭제</div>
				<div class="left-menu-box">로그아웃</div>
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
				<div class="setting-title">사용중인 칭호</div>
				<div class="mb-4">
					준비중
				</div>
				<form name="myform" method="post">
					<div class="setting-title">닉네임</div>
					<input type="text" name="nickname" id="nickname" value="${sNickname}" placeholder="닉네임을 입력하세요" class="form-control forminput mb-4" style="width: 100%;" />
					<div class="setting-title">자기소개</div>
					<textarea rows="4" class="form-control textarea mb-4" placeholder="소개글을 입력하세요"></textarea>
					<div class="text-right"><button class="joinBtn">변경사항 저장</button></div>
				</form>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>