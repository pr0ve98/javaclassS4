<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<nav>
	<div id="hambuger-menu">
		<div class="w3-sidebar w3-bar-block w3-card w3-animate-left darkmode" style="display:none;z-index:5;top:0;" id="mySidebar">
			<button class="w3-bar-item w3-button w3-xxlarge" onclick="w3_close()">&times;</button>
			<button class="w3-button w3-block w3-left-align" onclick="location.href='${ctp}/'">홈으로</button>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(1)">커뮤니티</button>
			<div id="demoAcc1" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="${ctp}/community/recent" class="w3-bar-item w3-button">피드</a>
				<a href="#" class="w3-bar-item w3-button">뉴스</a>
			</div>
			<button class="w3-button w3-block w3-left-align" onclick="location.href='${ctp}/review'">평가</button>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(4)">Accordion4</button>
			<div id="demoAcc4" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="#" class="w3-bar-item w3-button">Link</a>
				<a href="#" class="w3-bar-item w3-button">Link</a>
			</div>
		</div>
		<div class="header darkmode">
			<button class="w3-button w3-xxlarge" onclick="w3_open()">&#9776;</button>
			<img src="${ctp}/resources/images/logo.png" alt="로고" height="70px" class="p-2 ml-4" onclick="location.href='${ctp}/'">
			<div class="right-menu">
								<c:if test="${sMid != null}">
					<i class="fa-solid fa-bell fa"></i>
					<span class="profile-menu" style="position: relative;">
						<img src="${ctp}/member/${sMemImg}" style="cursor:pointer;" alt="프로필" width="40px" onclick="mtoggleProfileMenu()">
						<!-- 일반 프로필 메뉴 드롭다운 -->
						<c:if test="${sLevel != 0}">
						    <div id="mprofileDropdown" class="dropdown-content">
						        <div class="profile-info">
						            <img src="${ctp}/member/${sMemImg}" alt="프로필" class="profile-pic">
						        	<div style="display: flex; flex-direction: column;">
							            <div class="profile-nickname">${sNickname}</div>
							            <div class="profile-name">@${sMid}</div>
						            </div>
						        </div>
						        <a href="#">마이페이지 홈</a>
						        <a href="#">내 게임</a>
						        <a href="#">일지</a>
						        <a href="#">리뷰</a>
						        <a href="#">업적</a>
						        <a href="#">통계</a>
						        <a href="${ctp}/setting/profile">설정</a>
						        <c:if test="${sKakao == 'OK'}"><a href="javascript:kakaoLogout()">로그아웃</a></c:if>
						        <c:if test="${sKakao == 'NO'}"><a href="${ctp}/member/memberLogout">로그아웃</a></c:if>
						    </div>
					    </c:if>
						<!-- 관리자 프로필 메뉴 드롭다운 -->
					    <c:if test="${sLevel == 0}">
					    	<div id="mprofileDropdown" class="dropdown-content">
					    		<div class="profile-info">
						            <img src="${ctp}/member/${sMemImg}" alt="프로필" class="profile-pic">
						        	<div style="display: flex; flex-direction: column;">
							            <div class="profile-nickname">${sNickname}</div>
							            <div class="profile-name">@${sMid}</div>
						            </div>
						        </div>
						        <a href="${ctp}/admin/userlist">회원 관리</a>
						        <a href="${ctp}/admin/gamelist">게임 관리</a>
						        <a href="#">문의 목록</a>
						        <a href="${ctp}/admin/reportlist">신고 목록</a>
						        <a href="${ctp}/setting/profile">계정 설정</a>
						        <c:if test="${sKakao == 'OK'}"><a href="javascript:kakaoLogout()">로그아웃</a></c:if>
						        <c:if test="${sKakao == 'NO'}"><a href="${ctp}/member/memberLogout">로그아웃</a></c:if>
						    </div>
					    </c:if>
					</span>
				</c:if>
				<c:if test="${sMid == null}">
					<button class="joinBtn" onclick="showPopupJoin()" id="joinBtn2">회원가입</button>
				</c:if>
			</div>
		</div>
	</div>
	<div id="pc-menu" class="darkmode pt-1 pb-1">
		<div class="container p-menu">
			<div>
				<img src="${ctp}/resources/images/logo.png" alt="로고" height="80px" class="p-2 ml-2" onclick="location.href='${ctp}/'">
				<span class="menu-item"><a href="${ctp}/main" ${flag == 'main' ? 'class="selected"' : ''}>홈</a></span>
				<span class="menu-item"><a href="${ctp}/community/recent" ${flag == 'community' ? 'class="selected"' : ''}>커뮤니티</a></span>
				<span class="menu-item"><a href="${ctp}/review" ${flag == 'review' ? 'class="selected"' : ''}>평가</a></span>
			</div>
			<div class="right-menu">
				<div class="search-container">
			        <input type="text" class="search-bar" placeholder="Search...">
			    </div>
			    <c:if test="${sMid != null}">
					<i class="fa-solid fa-bell fa-lg"></i>
					<span class="profile-menu" style="position: relative;">
						<img src="${ctp}/member/${sMemImg}" style="cursor:pointer;" alt="프로필" width="50px" onclick="toggleProfileMenu()">
						    <!-- 프로필 메뉴 드롭다운 -->
						    <c:if test="${sLevel != 0}">
							    <div id="profileDropdown" class="dropdown-content">
							        <div class="profile-info">
							            <img src="${ctp}/member/${sMemImg}" alt="프로필" class="profile-pic">
							            <div style="display: flex; flex-direction: column;">
								            <div class="profile-nickname">${sNickname}</div>
								            <div class="profile-name">@${sMid}</div>
							            </div>
							        </div>
							        <a href="#">마이페이지 홈</a>
							        <a href="#">내 게임</a>
							        <a href="#">일지</a>
							        <a href="#">리뷰</a>
							        <a href="#">업적</a>
							        <a href="#">통계</a>
							        <a href="${ctp}/setting/profile">설정</a>
							        <c:if test="${sKakao == 'OK'}"><a href="javascript:kakaoLogout()">로그아웃</a></c:if>
						        	<c:if test="${sKakao == 'NO'}"><a href="${ctp}/member/memberLogout">로그아웃</a></c:if>
							    </div>
						    </c:if>
						  <!-- 관리자 프로필 메뉴 드롭다운 -->
					    <c:if test="${sLevel == 0}">
					    	<div id="profileDropdown" class="dropdown-content">
					    		<div class="profile-info">
						            <img src="${ctp}/member/${sMemImg}" alt="프로필" class="profile-pic">
						        	<div style="display: flex; flex-direction: column;">
							            <div class="profile-nickname">${sNickname}</div>
							            <div class="profile-name">@${sMid}</div>
						            </div>
						        </div>
						        <a href="${ctp}/admin/userlist">회원 관리</a>
						        <a href="${ctp}/admin/gamelist">게임 관리</a>
						        <a href="#">문의 목록</a>
						        <a href="${ctp}/admin/reportlist">신고 목록</a>
						        <a href="${ctp}/setting/profile">계정 설정</a>
						        <c:if test="${sKakao == 'OK'}"><a href="javascript:kakaoLogout()">로그아웃</a></c:if>
						        <c:if test="${sKakao == 'NO'}"><a href="${ctp}/member/memberLogout">로그아웃</a></c:if>
						    </div>
					    </c:if>
					</span>
				</c:if>
				<c:if test="${sMid == null}">
					<a href="javascript:showPopupLogin()" id="loginBtn">로그인</a>
					<button class="joinBtn" onclick="showPopupJoin()" id="joinBtn">회원가입</button>
				</c:if>
			</div>
		</div>
	</div>
</nav>
