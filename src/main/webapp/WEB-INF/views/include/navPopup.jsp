<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div id="popup-join" class="hide">
  <div class="popup-join-content scrollbar">
		<div class="popup-join-header">
			<span style="cursor: pointer;" onclick="showPopupSupport()"><i class="fa-solid fa-headset fa-lg" style="color: #b2bdce;"></i>&nbsp;&nbsp;문의하기</span>
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
<div id="popup-support" class="hide">
  <div class="popup-support-content scrollbar">
		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">문의하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('support')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-support-main">
			<form name="supportForm" method="post">
				<label class="support-title">답변 받으실 이메일</label>
				<input type="text" name="email" id="supportEmail" value="${sEmail}" placeholder="이메일을 입력하세요" class="form-control forminput" style="width:100%;" />
				<div class="warning-info">📌 메일이 반송되는 경우가 빈번하게 발생하고 있습니다! 이메일을 제대로 입력했는지 확인해주세요.</div>
				<label class="support-title mt-3">문의 유형</label>
				<select id="mainSupport" name="mainSupport" class="dropdown-btn" style="width:100%;" onchange="mainSupportChange(this)">
					<option value="">선택해 주세요</option>
					<option>회원 정보</option>
					<option>서비스 불편/오류 제보</option>
					<option>제안하기</option>
					<option>기타 문의</option>
				</select>
				<select id="subSupport" name="subSupport" class="dropdown-btn mt-2" style="width:100%; display: none;">
				</select>
				<label class="support-title mt-3">문의 내용</label>
				<div><textarea id="supportContent" rows="5" class="textarea" placeholder="무엇이든 말씀해 주세요!" style="width: 100%;"></textarea></div>
				<label class="support-title mt-3">스크린샷 첨부(JPG, JPEG, PNG)</label>
				<div class="mb-2"><div class="imgInputBtn" onclick="supportInputImg()">+파일 선택</div></div>
				<div id="supportInputText" class="imgNameStyle" style="display: none;"></div>
				<span style="display:none"><input type="file" name="supportFName" id="supportInputImgs" accept=".jpg,.gif,.png,.jpeg" onchange="supportFileChange()" /></span>
			</form>
			<hr/>
			<div class="support-title">⏰ 업무 시간</div>
			<div style="letter-spacing: -1px;">월요일 - 금요일 오전 10시 - 오후 6시(토, 일, 공휴일 휴무)</div>
			<div class="support-title mt-3">🧘‍♀️ 언제 답변받을 수 있나요?‍</div>
			<div style="letter-spacing: -1px;">✔ 영업일을 기준으로 <font color="#00c722">24시간</font> 이내에 답변드립니다</div>
			<div style="letter-spacing: -1px;">✔ 금요일 오후나 주말에 남겨주신 문의는 48시간 이내에 답변드립니다</div>
			<button class="imgInputBtn text-center mt-2" style="width:100%; font-size:18px;" disabled="disabled" onclick="supportInput()">문의하기</button>
		</div>
    </div>
</div>
<div id="popup-pwdreset" class="hide">
  <div class="popup-pwdreset-content scrollbar">
		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">비밀번호 찾기</span>
    		<div style="cursor:pointer;" onclick="closePopup('pwdreset')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-support-main">
			회원가입 시 가입했던 이메일을 적어주시면 그 이메일로 임시비밀번호를 보내드립니다!
			<input type="text" id="pwdResetEmail" name="pwdResetEmail" placeholder="이메일을 입력하세요" class="forminput mt-2" style="width:100%" />
			<div><span id="email-error2" class="error-message"></span></div>
			<button id="pwdResetSubmit" class="imgInputBtn text-center mt-4" style="width:100%; font-size:18px;" disabled="disabled" onclick="pwdResetOk()">비밀번호 변경</button>
		</div>
    </div>
</div>
<div id="popup-ftgameedit" class="hide">
  <div class="popup-ftgameedit-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 등록</div>
    		<div style="cursor:pointer;" onclick="closePopup('ftgameedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-add-main">
			<form name="ftgameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="ftgameTitle" id="ftgameTitle" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="ftgameSubTitle" id="ftgameSubTitle" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="ftjangre" id="ftjangre" placeholder="장르를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>플랫폼</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="ft-button" data-platform="PC">PC</span>
			                    <span class="ft-button" data-platform="PS4">PS4</span>
			                    <span class="ft-button" data-platform="PS5">PS5</span>
			                    <span class="ft-button" data-platform="XBO">XBO</span>
			                    <span class="ft-button" data-platform="XSX">XSX</span>
			                    <span class="ft-button" data-platform="XSS">XSS</span>
			                    <span class="ft-button" data-platform="Switch">Switch</span>
			                    <span class="ft-button" data-platform="Android">Android</span>
			                    <span class="ft-button" data-platform="iOS">iOS</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 출시일</th>
						<td><input type="date" name="ftshowDate" id="ftshowDate" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="ftprice" id="ftprice" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="ftmetascore" id="ftmetascore" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="ftsteamscore" id="ftsteamscore" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="ftsteamPage" id="ftsteamPage" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="ftdeveloper" id="ftdeveloper" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="ftgameInfo" id="ftgameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea"></textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" class="joinBtn-sm" value="등록 요청" onclick="gameRequest()" /></td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>