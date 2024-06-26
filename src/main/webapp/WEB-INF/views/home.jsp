<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>나만의 인겜토리!</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
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
</script>
<style>
	@font-face{
		font-family:'DNFBitBitv2';
		font-style:normal;
		font-weight:400;
		src:url('//cdn.df.nexon.com/img/common/font/DNFBitBitv2.otf')format('opentype')
	}
	@font-face {
	    font-family: 'SUITE-Regular';
	    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-Regular.woff2') format('woff2');
	    font-weight: 400;
	    font-style: normal;
	}
	@font-face {
	    font-family: 'SUITE-ExtraBold';
	    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-ExtraBold.woff2') format('woff2');
	    font-weight: 800;
	    font-style: normal;
	}
	* {box-sizing: border-box;}
	html, body, .darkmode {
		background-color: #161d25;
		color: #b2bdce;
		font-family: 'SUITE-Regular';
	}
	main {
		padding: 20px;
		min-height: 1000px;
		background-color: #32373d;
	}
	#hambuger-menu {
		display: none;
	}
	#pc-menu {
		font-family: DNFBitBitv2;
		border-bottom: 1px #32373d solid;
	}
	.p-menu {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.p-menu a:hover {
		color: #00c722;
		text-decoration: none;
	}
	.menu-item {
		padding: 5px 10px;
		font-size: 18pt;
	}
	.selected {
		color: #00c722;
	}
	.right-menu {
		display: flex;
		gap: 30px;
		align-items: center;
	}
	.right-menu img {
		border-radius: 50%;
		object-fit: cover;
	}
	.search-container {
	    position: relative;
	}
	.search-bar {
	    width: 200px;
	    height: 40px;
	    padding: 0 15px 0 46px;
	    border-radius: 20px;
	    border: none;
	    outline: none;
	    background-color: #32373d;
	    color: #fff;
	    font-size: 14px;
	    box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
	}
	.search-bar::placeholder {
	    color: #aaa;
	}
	.search-container::before {
	    content: '\1F50D';
	    position: absolute;
	    left: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 20px;
	    color: #aaa;
	}
	.banner img {
		width: 100%;
		height: 200px;
		border-radius: 10px;
		object-fit: cover;
	}
	.content1 {
		display: flex;
		margin-top: 20px;
		gap: 30px;
	}
	.news, .mygames {
		flex: 1 1;
	}
	.news-title, .mygames-title {
		font-family: 'SUITE-ExtraBold';
		font-size: 24px;
		color: #fff;
		margin-bottom: 5px;
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.more {
		color: #b2bdce;
		font-family: 'SUITE-Regular';
		font-size: 16px;
	}
	.content-box {
		flex-wrap: wrap;
		padding: 20px;
		background-color: #161d25;
		border-radius: 10px;
		height: calc(100% - 38px);
	}
	.news-text {
	  	overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 1;
	  	-webkit-box-orient: vertical;
	}
	hr {
		border-top: 1px solid #b2bdce30;
    	margin: 10px 0;
	}
	.news-img {
		display: flex;
		justify-content: center;
		gap: 0 15px;
	}
	.news-img div {
	    flex: 1;
	    display: flex;
	    flex-direction: column;
	  	overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 2;
	  	-webkit-box-orient: vertical;
	}
	.news-img img {
		width: 100%;
		height: 110px;
		object-fit: cover;
		border-radius: 10px;
		margin-bottom: 10px;
	}
	@media screen and (max-width: 991px) {
		main {
			padding: 20px 0;
			min-height: 1000px;
			background-color: #32373d;
		}
		#pc-menu {
			display: none;
		}
		#hambuger-menu {
			display: block;
		}
		.header .w3-button {
			padding: 0;
		}
		.w3-button:hover {
			color: #fff!important;
			background-color: #161d25!important;
		}
		.litiledark {
			background-color: #b2bdce;
			color: #32373d;
		}
		.darkmode-hover {
			color: #fff;
			background-color: #161d25;
		}
		.header {
			display: flex;
			align-items: center;
			justify-content: space-around;
		}
		.right-menu {
			gap: 20px;
		}
		.banner img {
			width: 100%;
			height: 60%;
			border-radius: 10px;
			object-fit: cover;
		}
		.content1 {
			flex-direction: column;
		}
	}
</style>
</head>
<body>
<nav>
	<div id="hambuger-menu" class="pt-1 pb-1">
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
				<i class="fa-solid fa-bell fa"></i>
				<img src="${ctp}/resources/images/profile.jpg" alt="프로필" width="40px">
			</div>
		</div>
	</div>
	<div id="pc-menu" class="darkmode pt-1 pb-1">
		<div class="container p-menu">
			<div>
				<img src="${ctp}/resources/images/logo.png" alt="로고" height="80px" class="p-2 ml-2">
				<span class="menu-item"><a href="#" class="selected">홈</a></span>
				<span class="menu-item"><a href="#">뉴스</a></span>
				<span class="menu-item"><a href="#">커뮤니티</a></span>
				<span class="menu-item"><a href="#">스토어</a></span>
			</div>
			<div class="right-menu">
				<div class="search-container">
			        <input type="text" class="search-bar" placeholder="Search...">
			    </div>
				<i class="fa-solid fa-bell fa-lg"></i>
				<img src="${ctp}/resources/images/profile.jpg" alt="프로필" width="50px">
			</div>
		</div>
	</div>
</nav>
<main>
	<div class="container">
		<div class="banner"><img alt="배너" src="${ctp}/resources/images/banner1.jpg" width="100%"></div>
		<div class="content1">
			<div class="news">
				<div class="news-title">
					<span>📄 뉴스</span>
					<span class="more">더보기</span>
				</div>
				<div class="content-box">
					<div class="news-img">
						<div>
							<img src="${ctp}/resources/images/news1.jpg" alt="뉴스이미지">
							<div>서머 게임 페스트 2024 발표 게임 총정리 (1/2)</div>
						</div>
						<div>
							<img src="${ctp}/resources/images/news2.jpg" alt="뉴스이미지">
							<div>2024년 6월 닌텐도 다이렉트 총정리</div>
						</div>
					</div>
					<hr/>
					<div class="news-text">[6월 넷째 주 뉴스레터] 크래프톤 : 해당 문제 가능성에 대해 충분히 예상</div>
					<hr/>
					<div class="news-text">7년째 개발 중! 슬롯 매니징 로그라이크 'RP7'을 개발한 박선용 디렉터 인터뷰</div>
					<hr/>
					<div class="news-text">닌텐도 스위치용 ‘에이스 컴뱃 7: 스카이즈 언노운 디럭스 에디션’(한국어판) 패키지 선주문 판매 6월 26일(수) 오후 3시 시작!</div>
					<hr/>
					<div class="news-text">'슈퍼 몽키 볼 바나나 럼블', 6월 25일(화) 발매</div>
				</div>
			</div>
			<div class="mygames">
				<div class="mygames-title">
					<span>🎮 내 게임</span>
					<span class="more">내 게임</span>
				</div>
				<div class="content-box">
					
				</div>
			</div>
		</div>
	</div>
</main>
<footer>

</footer>
</body>
</html>