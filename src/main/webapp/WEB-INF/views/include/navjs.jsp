<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
 	<script>
	
	function w3_open() {
	  document.getElementById("mySidebar").style.display = "block";
	}
	
	function w3_close() {
	  document.getElementById("mySidebar").style.display = "none";
	}
	
	function myAccFunc(flag) {
	  var x = document.getElementById("demoAcc"+flag);
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	    x.previousElementSibling.className += " darkmode-hover";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	    x.previousElementSibling.className = 
	    x.previousElementSibling.className.replace(" darkmode-hover", "");
	  }
	}
	
	function showPopupJoin() {
    	const popup = document.querySelector('#popup-join');
    	const loginpopup = document.querySelector('#popup-login');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        loginpopup.classList.add('hide');
        html.classList.add('popup-open');
    }

    function showPopupLogin() {
    	const popup = document.querySelector('#popup-login');
    	const joinpopup = document.querySelector('#popup-join');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        joinpopup.classList.add('hide');
        html.classList.add('popup-open');
    }
    
    function closePopup() {
    	const popup = document.querySelector('#popup-join');
    	const html = document.querySelector('html');
        popupJoin.classList.add('hide');
        popupLogin.classList.add('hide');
        html.classList.remove('popup-open');
    }

 	function kakaoLogin() {
 		window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
 		
 		window.Kakao.Auth.login({
			scope: 'profile_nickname, account_email',
			success : function(autoObj) {
				//console.log(Kakao.Auth.getAccessToken(), "정상 토큰 발급됨");
				window.Kakao.API.request({
					url : '/v2/user/me',
					success : function(res) {
						const kakao_account = res.kakao_account;
						console.log(kakao_account);
						location.href = "${ctp}/member/kakaoLogin?nickname="+kakao_account.profile.nickname+"&email="+kakao_account.email+"&accessToken="+Kakao.Auth.getAccessToken();
					}
				});
			}
		});
	}
 	
 	document.addEventListener('DOMContentLoaded', function() {
 	    const email = document.getElementById('joinemail');
 	    const pwd = document.getElementById('joinpwd');
 	    const submitBtn = document.getElementById('submitBtn');

 	    const emailError = document.getElementById('email-error');
 	    const pwdError = document.getElementById('pwd-error');

 	    function validateForm() {
 	        let isValid = true;

 	        const emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
 	        if (!emailReg.test(email.value)) {
 	            emailError.textContent = '잘못된 형식입니다';
 	            emailError.style.display = 'inline';
 	           	email.classList.add('error-form');
 	            isValid = false;
 	        } else {
 	            emailError.style.display = 'none';
 	           	email.classList.remove('error-form');
 	        }

 	       if (email.value.length > 0 && emailReg.test(email.value)) {
	 	        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4,}$/;
	 	        if (!pwdReg.test(pwd.value)) {
	 	        	pwdError.textContent = '4자 이상 영문,숫자,특수문자';
	 	        	pwdError.style.display = 'inline';
	 	        	pwd.classList.add('error-form');
	 	            isValid = false;
	 	        }
	 	        else {
	 	        	pwdError.style.display = 'none';
	 	        	pwd.classList.remove('error-form');
	 	        }
	 	   } 
 	       else {
	        	pwdError.style.display = 'none';
 	        	pwd.classList.remove('error-form');
 	        }

 	       submitBtn.disabled = !isValid;
 	    }

 	    email.addEventListener('input', validateForm);
 	    pwd.addEventListener('input', validateForm);
 	});
 	
 	function emailJoin() {
		$("#join-form").show();
		$("#emailjoin").hide();
	}
 	
 	function joinCheck() {
 		const email = document.getElementById('joinemail');
 	    const pwd = document.getElementById('joinpwd');

        const emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4}$/;
        
        if (!emailReg.test(email.value)) return false;
        else if (!pwdReg.test(pwd.value)) return false;
        else joinform.submit();
	}
 	
 	function loginCheck() {
 		const email = document.getElementById('loginemail').value;
 	    const pwd = document.getElementById('loginpwd').value;
 	    
        if (email.trim() == '') return false;
        else if (pwd.trim() == '') return false;
        else loginform.submit();
	}
	
 	// PC
 	function toggleProfileMenu() {
 	    var dropdown = document.getElementById("profileDropdown");
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
 	}
 	
 	// 모바일
 	function mtoggleProfileMenu() {
 	    var dropdown = document.getElementById("mprofileDropdown");
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
 	}

 	// 페이지의 다른 부분을 클릭하면 드롭다운이 닫히도록 이벤트 리스너 추가
 	window.onclick = function(event) {
 	    if (!event.target.matches('.profile-menu img')) {
 	        var dropdowns = document.getElementsByClassName("dropdown-content");
 	        for (var i = 0; i < dropdowns.length; i++) {
 	            var openDropdown = dropdowns[i];
 	            if (openDropdown.style.display === "block") {
 	                openDropdown.style.display = "none";
 	            }
 	        }
 	    }
 	}

 	// 카카오 로그인
 	function kakaoLogin() {
 		window.Kakao.Auth.login({
			scope: 'profile_nickname, account_email',
			success : function(autoObj) {
				//alert(Kakao.Auth.getAccessToken(), "정상 토큰 발급됨");
				window.Kakao.API.request({
					url : '/v2/user/me',
					success : function(res) {
						const kakao_account = res.kakao_account;
						console.log(kakao_account);
						location.href = "${ctp}/member/kakaoLogin?nickname="+kakao_account.profile.nickname+"&email="+kakao_account.email+"&accessToken="+Kakao.Auth.getAccessToken();
					}
				});
			}
		});
	}
 	
  	// 카카오 로그아웃
	function kakaoLogout() {
		const accessToken = Kakao.Auth.getAccessToken();
		if(accessToken) {
			Kakao.Auth.logout(function(){
				window.location.href = "https://kauth.kakao.com/oauth/logout?client_id=f1fade264b3d07d67f8e358b3d68803e&logout_redirect_uri=http://localhost:9090/javaclassS4/member/kakaoLogout";
			});
		}
	}
	</script>