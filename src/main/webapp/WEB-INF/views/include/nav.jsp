<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<nav>
	<div id="hambuger-menu">
		<div class="w3-sidebar w3-bar-block w3-card w3-animate-left darkmode" style="display:none;z-index:5" id="mySidebar">
			<button class="w3-bar-item w3-button w3-xxlarge" onclick="w3_close()">&times;</button>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(1)">Accordion1</button>
			<div id="demoAcc1" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="#" class="w3-bar-item w3-button">Link</a>
				<a href="#" class="w3-bar-item w3-button">Link</a>
			</div>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(2)">Accordion2</button>
			<div id="demoAcc2" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="#" class="w3-bar-item w3-button">Link</a>
				<a href="#" class="w3-bar-item w3-button">Link</a>
			</div>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(3)">Accordion3</button>
			<div id="demoAcc3" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="#" class="w3-bar-item w3-button">Link</a>
				<a href="#" class="w3-bar-item w3-button">Link</a>
			</div>
			<button class="w3-button w3-block w3-left-align" onclick="myAccFunc(4)">Accordion4</button>
			<div id="demoAcc4" class="w3-bar-block w3-hide w3-card-4 litiledark">
				<a href="#" class="w3-bar-item w3-button">Link</a>
				<a href="#" class="w3-bar-item w3-button">Link</a>
			</div>
		</div>
		<div class="header darkmode">
			<button class="w3-button w3-xxlarge" onclick="w3_open()">&#9776;</button>
			<img src="${ctp}/resources/images/logo.png" alt="로고" height="70px" class="p-2 ml-4">
			<div class="right-menu">
				<c:if test="${sMid != null}">
					<i class="fa-solid fa-bell fa"></i>
					<img src="${ctp}/images/profile.jpg" alt="프로필" width="40px">
				</c:if>
				<c:if test="${sMid == null}">
					<button class="joinBtn">회원가입</button>
				</c:if>
			</div>
		</div>
	</div>
	<div id="pc-menu" class="darkmode pt-1 pb-1">
		<div class="container p-menu">
			<div>
				<img src="${ctp}/resources/images/logo.png" alt="로고" height="80px" class="p-2 ml-2">
				<span class="menu-item"><a href="#" class="selected">홈</a></span>
				<span class="menu-item"><a href="#">커뮤니티</a></span>
				<span class="menu-item"><a href="#">평가</a></span>
				<span class="menu-item"><a href="#">스토어</a></span>
			</div>
			<div class="right-menu">
				<div class="search-container">
			        <input type="text" class="search-bar" placeholder="Search...">
			    </div>
			    <c:if test="${sMid != null}">
					<i class="fa-solid fa-bell fa-lg"></i>
					<img src="${ctp}/images/profile.jpg" alt="프로필" width="50px">
				</c:if>
				<c:if test="${sMid == null}">
					<a href="">로그인</a>
					<button class="joinBtn">회원가입</button>
				</c:if>
			</div>
		</div>
	</div>
</nav>