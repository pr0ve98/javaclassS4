<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>최신피드 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="container">
		<p></p>
		<div class="community">
			<span class="cm-menu">
				<span class="cb mb-4">
					<span class="communityBtn cb-active">
			            <img src="https://img.icons8.com/ios-filled/50/ffffff/chat.png" alt="Chat Icon"/>
			        </span>
			        <span class="cb-text-active"><b>인겜토리</b></span>
				</span>
				<span class="cn">
			        <span class="communityBtn">
			            <img src="https://img.icons8.com/ios-filled/50/b2bdce/news.png" alt="News Icon"/>
			        </span>
			        <span class="cb-text"><b>뉴스</b></span>
				</span>
			</span>
			<div style="width:100%;">
				<div class="c-buttons">
					<span class="c-button">팔로우</span>
					<span class="c-button c-button-active">최신</span>
					<span class="c-button">리뷰</span>
					<span class="c-button">소식/정보</span>
					<span class="c-button">세일</span>
					<span class="c-button">내글</span>
				</div>
				<div class="cm-box">
					<div style="display:flex; align-items: center; justify-content: center;">
						<img src="${ctp}/images/profile.jpg" alt="프로필" class="text-pic">
						<div class="text-input">요즘 관심있는 게임은 무엇인가요?</div>
					</div>
				</div>
				<div class="cm-box">
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
					<p>safsdfsdf</p>
				</div>
			</div>
		</div>
	</div>
	<p></p>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>