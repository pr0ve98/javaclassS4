<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div id="popup-join" class="hide">
  <div class="popup-join-content scrollbar">
		<div class="popup-join-header">
			<span style="cursor: pointer;"><i class="fa-solid fa-headset fa-lg" style="color: #b2bdce;"></i>&nbsp;&nbsp;문의하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('join')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-join-main">
			<div class="socialBtn" onclick="kakaoLogin()">
				<span class="mr-2"><img src="${ctp}/images/kakaoIcon.png"></span>
				<span>카카오로 시작하기</span>
			</div>
			<div class="socialBtn ingametory" id="emailjoin" onclick="emailJoin()">
				<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
				<span>이메일로 시작하기</span>
			</div>
			<div id="join-form" style="display: none;">
				<hr/>
				<form name="joinform" method="post" action="${ctp}/member/memberJoin">
					<input type="text" name="email" id="joinemail" placeholder="이메일을 입력하세요" class="form-control forminput" />
					<span id="email-error" class="error-message"></span><br/>
					<input type="password" name="pwd" id="joinpwd" placeholder="비밀번호를 입력하세요" class="form-control forminput" />
					<span id="pwd-error" class="error-message"></span>
					<div class="socialBtn ingametory mt-4" id="submitBtn" onclick="joinCheck()">
						<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
						<span>이메일로 가입하기</span>
					</div>
				</form>
			</div>
			<div style="margin: 30px 0 20px;">이미 계정이 있으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupLogin()" id="joinPopupLoginBtn">로그인</span></div>
		</div>
  </div>
</div>
<div id="popup-login" class="hide">
  <div class="popup-login-content scrollbar">
		<div class="popup-login-header">
    		<div style="cursor:pointer;" onclick="closePopup('login')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-login-main">
			<h2><b>로그인</b></h2>
			<div style="margin: 20px 0 20px;">인겜토리 계정이 없으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupJoin()" id="loginPopupJoinBtn">회원가입</span></div>
			<div class="socialBtn" onclick="kakaoLogin()">
				<span class="mr-2"><img src="${ctp}/images/kakaoIcon.png"></span>
				<span>카카오로 로그인</span>
			</div>
			<hr class="mb-4"/>
			<form name="loginform" method="post" action="${ctp}/member/memberLogin">
				<input type="text" name="email" id="loginemail" placeholder="이메일을 입력하세요" class="form-control forminput" />
				<br/>
				<input type="password" name="pwd" id="loginpwd" placeholder="비밀번호를 입력하세요" class="form-control forminput" />
				<div class="text-right"><span class="pwdReset" onclick="pwdReset()">비밀번호를 잊으셨나요?</span></div>
				<div class="socialBtn ingametory mt-4" id="submitBtn" onclick="loginCheck()">
					<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
					<span>이메일로 로그인</span>
				</div>
				<input type="hidden" name="flag" id="flag" value="${flag}" />
			</form>
		</div>
		<hr/>
		<div class="popup-login-footer">
			<div style="margin: 20px 0 20px;">로그인에 문제가 있으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupSupport()" id="supportPopupBtn">문의하기</span></div>
		</div>
    </div>
</div>