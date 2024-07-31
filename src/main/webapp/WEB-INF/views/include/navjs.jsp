<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
 	<script>
 	
    window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
    Kakao.isInitialized();
    
    document.addEventListener('DOMContentLoaded', function () {
        const emailInput = document.getElementById('supportEmail');
        const mainSupportSelect = document.getElementById('mainSupport');
        const subSupportSelect = document.getElementById('subSupport');
        const textarea = document.querySelector('textarea');
        const submitButton = document.querySelector('button[onclick="supportInput()"]');

        function validateForm() {
            const emailFilled = emailInput.value.trim() !== '';
            const mainSupportFilled = mainSupportSelect.value.trim() !== '';
            const textareaFilled = textarea.value.trim() !== '';
            let subSupportFilled = true;

            if (mainSupportSelect.value === '회원 정보' || mainSupportSelect.value === '서비스 불편/오류 제보') {
                subSupportFilled = subSupportSelect.value.trim() !== '';
            }

            if (emailFilled && mainSupportFilled && textareaFilled && subSupportFilled) {
                submitButton.disabled = false;
            } else {
                submitButton.disabled = true;
            }
        }

        emailInput.addEventListener('input', validateForm);
        mainSupportSelect.addEventListener('change', function() {
            validateForm();
            // mainSupport 값이 변경될 때 subSupport를 표시 또는 숨김
            if (mainSupportSelect.value === '회원 정보' || mainSupportSelect.value === '서비스 불편/오류 제보') {
                subSupportSelect.style.display = 'block';
            } else {
                subSupportSelect.style.display = 'none';
                subSupportSelect.value = ''; // 선택 초기화
            }
        });
        subSupportSelect.addEventListener('change', validateForm);
        textarea.addEventListener('input', validateForm);
    });
    
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
        html.style.overflow = 'hidden';
    }

    function showPopupLogin() {
    	const popup = document.querySelector('#popup-login');
    	const joinpopup = document.querySelector('#popup-join');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        joinpopup.classList.add('hide');
        html.style.overflow = 'hidden';
    }
    
	function showPopupSupport() {
    	const popup = document.querySelector('#popup-support');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
    
    function closePopup(flag) {
    	let popup = '';
    	if(flag == 'join') popup = document.querySelector('#popup-join');
    	else if(flag == 'login') popup = document.querySelector('#popup-login');
    	else if(flag == 'search') popup = document.querySelector('#popup-gamesearch');
    	else if(flag == 'write') popup = document.querySelector('#popup-write');
    	else if(flag == 'edit') popup = document.querySelector('#popup-edit');
    	else if(flag == 'replyedit') popup = document.querySelector('#popup-replyedit');
    	else if(flag == 'add') popup = document.querySelector('#popup-add');
    	else if(flag == 'gameedit') popup = document.querySelector('#popup-gameedit');
    	else if(flag == 'report') popup = document.querySelector('#popup-report');
    	else if(flag == 'support') popup = document.querySelector('#popup-support');
    	else if(flag == 'reviewwrite') popup = document.querySelector('#popup-reviewwrite');
    	const html = document.querySelector('html');
    	popup.classList.add('hide');
    	html.style.overflow = 'auto';
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
        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4,}$/;
        
        if (!emailReg.test(email.value)) {
        	alert("이메일이 올바르지 않습니다");
        	return false;
        }
        else if (!pwdReg.test(pwd.value)) {
        	alert("비밀번호가 올바르지 않습니다");
        	return false;
        }
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
						location.href = "${ctp}/member/kakaoLogin?nickname="+kakao_account.profile.nickname+"&email="+kakao_account.email+"&accessToken="+Kakao.Auth.getAccessToken()+"&flag=${flag}";
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
  	
	function supportInputImg() {
		$("#supportInputImgs").trigger('click');
	}
	
	function supportFileChange() {
		let fName = document.getElementById("supportInputImgs").files[0].name;
		if(fName.length > 15) fName = fName.substring(0, 15) + "...";
		$('#supportInputText').html(fName+"<span onclick='supportDeleteImg()' style='color:red; font-weight: bold; margin-left: 3px; cursor:pointer;'>x</span>");
		$('#supportInputText').show();
	}
	
	function mainSupportChange(e) {
		let subMember = ["로그인", "회원가입", "탈퇴", "기타"];
		let subService = ["서비스 관련", "웹 이용문의", "모바일 이용문의", "기타"];
		
		$("#subSupport").empty();
		
		let op;
		if(e.value == "회원 정보") op = subMember;
		else if(e.value == "서비스 불편/오류 제보") op = subService;
		else {
			$("#subSupport").hide();
		}
		
		if(op) {
			for(let i=0; i<op.length; i++){
				$("#subSupport").append('<option>'+op[i]+'</option>');
			}
			$("#subSupport").show();
		}
	}
	
	function supportDeleteImg() {
		$('#supportInputImgs, #supportInputText').val('');
		$('#supportInputText').hide();
	}
	
	function supportInput() {
		const supEmail = document.getElementById('supportEmail');
	    const main = document.getElementById('mainSupport');
	    const sub = document.getElementById('subSupport');
	    const supContent = document.getElementById('supportContent');
	    const supImg = document.getElementById('supportInputImgs');
	    
	    const formData = new FormData();
	    formData.append('supEmail', supEmail.value);
	    formData.append('main', main.value);
	    if (sub.style.display !== 'none') {
	        formData.append('sub', sub.value);
	    }
	    formData.append('supContent', supContent.value);
	    if (supImg.files.length > 0) {
	        formData.append('supImg', supImg.files[0]);
	    }
	    
	    $.ajax({
			url : "${ctp}/admin/supportInput",
			type : "post",
			data : formData,
			processData: false,
			contentType: false,
			success : function(res) {
				if(res != "0"){
					alert("문의 등록 완료!");
					location.reload();
				}
			},
			error : function() {
				alert("오류!!");
			}
		});

	}
	</script>