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
		cursor: default;
	}
	main {
		padding: 20px;
		background-color: #32373d;
	}
	#hambuger-menu {
		display: none;
	}
	#pc-menu {
		font-family: DNFBitBitv2;
		border-bottom: 1px #32373d solid;
	}
	nav {
		position: sticky;
		top: 0;
		z-index: 1000;
		
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
		margin-top: 30px;
		gap: 30px;
	}
	.news, .mygames, .popcommunity, .sale {
		width: 50%;
	}
	.news-title, .mygames-title, .popcommunity-title, .sale-title {
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
	.news-text, .newgame-text, .popcommunity-text, .sale-text {
	  	overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 1;
	  	-webkit-box-orient: vertical;
	}
	.news hr {
		border-top: 1px solid #b2bdce30;
    	margin: 10px 0;
	}
	hr {
		border-top: 1px solid #b2bdce30;
    	margin: 15px 0;
	}
	.news-img, .popcommunity-img, .sale-img {
		display: flex;
		justify-content: center;
		gap: 0 15px;
	}
	.news-img div, .popcommunity-img div, .sale-img div, .newgame-info {
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
	.popcommunity-img img, .sale-img img {
		width: 100%;
		height: 150px;
		object-fit: cover;
		border-radius: 10px;
		margin-bottom: 10px;
	}
	.news-page {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin: 30px 0 20px;
	    gap:20px;
	}
	
	.prev, .next {
	    background-color: #32373d;
	    border: none;
	    border-radius: 50%;
	    color: #b2bdce;
	    cursor: pointer;
	    padding: 1px 8px;
	    margin: 0 15px;
	}
	.game-status {
	    display: flex;
	    margin-bottom: 20px;
	    justify-content: space-between;
	    gap: 40px;
	}
	
	.game-info, .status-info {
	    width: 50%;
	    display: flex;
	    flex-direction: column;
	}
	
	.game-title {
	    font-size: 1.2em;
	    margin-bottom: 5px;
	    color: #fff;
	    font-weight: bold;
	    overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 1;
	  	-webkit-box-orient: vertical;
	}
	
	.game-count {
	    font-size: 2em;
	    margin-bottom: 30px;
	   	color: #fff;
	    font-weight: bold;
	}
	
	.game-details div, .status-detail div {
	    margin: 5px 0;
	}
	.dropdown {
	    position: static;
	}
	
	.dropdown-btn {
	    background-color: #161d25;
	    color: #b2bdce;
	    padding: 10px;
	    border: none;
	    cursor: pointer;
	    text-align: left;
	    font-size: 1em;
	}
	
	.dropdown-btn:focus {
	    outline: none;
	}
	.cnt-item {
		display: flex;
		justify-content: space-between;
	}
	.game-list {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin: 5px 0;
	}
	.game-item {
		display: inline-block;
		position: relative;
	    width: 90px;
	    height: 90px;
	    margin-right: 8px;
	}
	.playState {
		position: absolute;
	    width: 28px;
	    height: 28px;
	    right: -4px;
	    bottom: -5px;
	    z-index: 2;
	}
	.game-item img, .newgame-item img {
	    width: 100%;
	    height: 100%;
	    border-radius: 8px;
	    object-fit: cover;
	}
	.content2 {
		margin: 40px 0;
	}
	.newgame-list {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin-top: 5px;
	}
	.newgame-item {
		display: flex;
		flex-direction: column;
		width: 180px;
	}
	.newgame-item-img {
		display: inline-block;
		width: 180px;
	    height: 180px;
	    margin-right: 8px;
	}
	.v-line {
		border-left : thin solid #b2bdce30;
		height: 330px;
		margin: 0 20px;
	}
	.newgame {width: 100%;}
	.mobile-line {display: none;}
	.pc-line {
		border-top: 1px dotted #b2bdce30;
	}
	.category {
		font-weight: bold;
		color: #fff;
		margin-right: 10px;
	}
	.content3 {
		display: flex;
		margin: 50px 0;
		gap: 30px;
	}
	.sub-menu {
		display: flex;
		flex-direction: column;
		font-size: 20px;
		text-align: center;
		font-weight: bold;
	}
	.review {
		display: flex;
		gap: 20px;
		flex-wrap: wrap;
		justify-content: center;
	}
	.review-box {
		width: 31.5%;
		padding: 20px;
		background-color: #32373d;
		border-radius: 10px;
		height: calc(100% - 38px);
		box-shadow: 0 4px 5px rgba(0,0,0,.06),0 1px 10px rgba(0,0,0,.12),0 2px 4px rgba(0,0,0,.4);
	}
	.review-box:hover {
		background-color: #50748e24;
	}
	.review-h-img {
		display: inline-block;
		width: 20px;
	    height: 20px;
	    margin-right: 4px;
	}
	.review-h-img img, .review-game-img img {
	    border-radius: 50%;
		width: 100%;
		height: 100%;
	}
	.review-h-nickName {
		color: white;
		font-weight: bold;
	}
	.review-h-date {
		font-size: 12px;
	}
	.review-game {
		display: flex;
		margin-bottom: 10px;
	}
	.review-info {
		display: flex;
		flex-direction: column;
	}
	.review-game-img {
		width: 56px;
	    height: 56px;
	    border-radius: 8px;
	    margin-right: 12px;
	    object-fit: cover;
	}
	.review-star {
	    border: 2px solid #FFD43B;
	    border-radius: 5px;
	    color: #FFD43B;
	    padding: 2px 3px;
	    font-size: 12px;
	    margin-right: 3px;
	}
	.review-state-none {
	    border: 2px solid #9b9b9bb5;
	    border-radius: 5px;
	    color: #9b9b9bb5;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-state-play {
	    border: 2px solid #0085eb;
	    border-radius: 5px;
	    color: #0085eb;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-state-done {
	    border: 2px solid #00c722;
	    border-radius: 5px;
	    color: #00c722;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-text {
		overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 4;
	  	-webkit-box-orient: vertical;
	  	margin-bottom: 10px;
	}
	.review-more {
		font-weight: bold;
		color: #00c722;
	}
	.store-game {
		display: flex;
		gap: 30px;
	}
	.s-game {
		width: 33.3%;
	}
	.s-game img {
		width: 100%;
		height: 150px;
		border-radius: 8px;
		object-fit: cover;
	}
	.s-game-name {
		margin-top: 15px;
		color: #fff;
		font-weight: bold;
		font-size: 16px;
	}
	.s-game-price {
		margin-top: 25px;
		color: #fff;
		font-weight: bolder;
		font-size: 20px;
	}
	footer {
		margin: 80px 0;
		text-align: center;
		background-color: #161d25;
	}
	.footer-menu {
		display: flex;
		align-items: flex-start;
		justify-content: center;
		gap: 45px;
		font-size: 20px;
		font-weight: bold;
		margin-bottom: 50px;
	}
	
		
	@media screen and (min-width: 1200px) {
		.game-item {
			width: 110px;
		}
		.newgame-item {
			width: 220px;
		}
		.newgame-item-img {
			width: 220px;
		}
		.v-line {
			margin: 0 30px;
		}

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
			color: #00c722!important;
			background-color: #32373d!important;
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
		.game-list {
			margin: 3px;
		}
		.game-item {
			width: 150px;
			height: 70px;
		}
		.news, .mygames, .popcommunity, .sale {
			width: 100%;
		}
		.newgame-list {
		    flex-wrap: wrap;
		}
		.newgame-item {
			width: 100%;
			margin-bottom: 20px;
		}
		.newgame-item-img {
			width: 100%;
		}
		.v-line {
			display: none;
		}
		.mobile-line {display: block;}
		.pc-line {display: none;}
		.content3 {
			margin: 30px 0;
		}
		.sub-menu {
			font-size: 16px;
		}
		.review-box {
			width: 100%;
		}
		.store-game {
			flex-direction: column;
			gap: 0;
		}
		.s-game {
			width: 100%;
		}
		.s-game-price {
			margin-top: 10px;
		}
		footer {
			text-align: left;
			margin: 50px 10px;
		}
		.footer-menu img {display: none;}
		.footer-menu {
			flex-direction: column;
			gap: 10px;
			font-size: 16px;
			margin: 30px 10px;
		}
	}
</style>
<script>
	'use strict';
	
</script>
</head>
<body>
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
				<span class="menu-item"><a href="#">커뮤니티</a></span>
				<span class="menu-item"><a href="#">평가</a></span>
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
					<span>📰 뉴스</span>
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
					<div class="news-page">
						<button class="prev" onclick="prevPage()"><i class="fa-solid fa-chevron-left fa-2xs"></i></button>
				        <span class="page-info">1/4</span>
				        <button class="next" onclick="nextPage()"><i class="fa-solid fa-chevron-right fa-2xs"></i></button>
					</div>
				</div>
			</div>
			<div class="mygames">
				<div class="mygames-title">
					<span>🎮 내 게임</span>
					<span class="more">내 게임</span>
				</div>
				<div class="content-box">
			        <div class="game-status">
			            <div class="game-info">
			                <div class="game-title">내 게임</div>
			                <div class="game-count">109</div>
			                <div class="game-details">
			                    <div class="cnt-item"><span>5점 게임</span><span>16</span></div>
			                    <div class="cnt-item"><span>3점이상 게임</span><span>93</span></div>
			                    <div class="cnt-item"><span>2점이하 게임</span><span>28</span></div>
			                </div>
			            </div>
			            <div class="status-info">
			                <div class="status">
			                    <div class="game-title">게임 상태</div>
			                    <div class="status-detail">
			                        <div class="cnt-item"><span><i class="fa-solid fa-play fa-sm" style="color: #0085eb;"></i>&nbsp;&nbsp;하고있어요</span><span>3</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-check" style="color: #00c722;"></i>&nbsp;&nbsp;다했어요</span><span>42</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-xmark" style="color: #f50000;"></i>&nbsp;&nbsp;그만뒀어요</span><span>29</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-thumbtack fa-sm" style="color: #fff700;"></i>&nbsp;&nbsp;관심있어요</span><span>12</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-folder fa-sm" style="color: #d9d9d9;"></i>&nbsp;&nbsp;모셔놨어요</span><span>10</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-ellipsis" style="color:#37414cd6;"></i>&nbsp;&nbsp;상태없음</span><span>12</span></div>
			                    </div>
			                </div>
			            </div>
			        </div>
			        <hr/>
			        <div class="recent-games">
			            <div class="dropdown">
			                <select class="dropdown-btn">
			                    <option>최근 담은 게임</option>
			                    <option>최근 평가한 게임</option>
			                    <option>지금 하고있는 게임</option>
			                    <option>별점 높은 게임</option>
			                </select>
			            </div>
			            <div class="game-list">
			            	<span class="game-item"><img src="${ctp}/game/명조.jpg"><span class="playState"><img src="${ctp}/images/playIcon.svg"></span></span>
			            	<span class="game-item"><img src="${ctp}/game/사건탐정해결부.jpg"><span class="playState"><img src="${ctp}/images/pinIcon.svg"></span></span>
			            	<span class="game-item"><img src="${ctp}/game/스테퍼케이스.jpg"><span class="playState"><img src="${ctp}/images/doneIcon.svg"></span></span>
			            	<span class="game-item"><img src="${ctp}/game/원신.jpg"><span class="playState"><img src="${ctp}/images/playIcon.svg"></span></span>
			            </div>
			        </div>
				</div>
			</div>
		</div>
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>💡 최근 발매된 게임</span>
				</div>
				<div class="content-box">
					<div class="newgame-list">
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/러브크레센도.jpg"></span>
							<span class="game-title">러브크레센도</span>
							<span>06.28</span>
							<span>PC</span>
							<span class="newgame-text">비주얼 노벨, 시뮬레이션, 캐주얼</span>
							<hr class="pc-line"/>
							<span class="newgame-info">백마탄 공주님은 없다! 비밀스러운 그녀들과 함께하는 밴드부 생활.</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/루이지맨션2hd.jpg"></span>
							<span class="game-title">루이지 맨션 2 HD</span>
							<span>06.27</span>
							<span>닌텐도 스위치</span>
							<span class="newgame-text">어드벤처, 액션어드벤처</span>
							<hr class="pc-line"/>
							<span class="newgame-info">겁 많고 소심한 루이지가 유령이 사는 맨션을 모험!
							「아라따박사」에게 억지로 끌려온 루이지는 흩어진 「다크 문」의 조각을 모으기 위해 「유령 계곡」을 조사하게 되었습니다.
							과연 루이지는 「유령 계곡」의 평화를 되찾을 수 있을까요……?</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/스파이패밀리오퍼레이션다이어리.jpg"></span>
							<span class="game-title">스파이패밀리 오퍼레이션 다이어리</span>
							<span>06.27</span>
							<span>PS5, PS4, 닌텐도 스위치, PC</span>
							<span class="newgame-text">어드벤처</span>
							<hr class="pc-line"/>
							<span class="newgame-info">이든 칼리지의 숙제로 그림일기를 그리게 된 아냐. 평일에는 학교에 가고 휴일에는 가족들하고 바다, 수족관 같은 다양한 장소로 나들이하며 그림일기의 소재를 모아봐요. 『스파이 패밀리』다운 일상을 체험할 수 있는 미니 게임도 15종류 이상 수록. 과연 아냐는 그림일기를 완성할 수 있을까요?</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/엘든링황금나무의그림자.jpg"></span>
							<span class="game-title">엘든 링: 황금 나무의 그림자</span>
							<span>06.21</span>
							<span>PS5, PS4, XBOX, PC</span>
							<span class="newgame-text">3인칭 오픈 월드 ARPG</span>
							<hr class="pc-line"/>
							<span class="newgame-info">다채로운 시추에이션을 지닌 탁 트인 필드와 복잡하면서 입체적으로 짜인 거대한 던전이 경계선 없이 이어지는 드넓은 세계. 탐색 끝에는 미지의 것들을 발견했다는 기쁨과 높은 성취감으로 이어지는 압도적인 위협이 플레이어를 기다립니다.</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>📑 추천 리뷰</span>
					<span class="more">모두 보기</span>
				</div>
				<div class="content-box">
					<div class="review">
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member2.jpg"></span>
								<span class="review-h-nickName">nuwn3vv</span>
								<span class="review-h-date">· 24/04/22</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/발더스게이트.jpg">
									<div class="review-info">
										<div class="game-title">발더스 게이트 3</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;5.0</span>
											<span class="review-state-none"><i class="fa-solid fa-ellipsis"></i></i>&nbsp;상태없음</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">엄청난 양의 텍스트 내가 선택하는 선택지에 따른 확실한 답변과 결과 밀도높고 광활한 필드 독창적인 캐릭터성 괜히 2023 최다 goty가 아니다! 버그가 좀 있고 전투가 dnd 형식이다보니 취향을 안탄다곤 안하겠지만은 단언컨데 최고의 rpg게임이 아닐까 합니다 rpg를 좋아한다면 무조건 !</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member3.jpg"></span>
								<span class="review-h-nickName">김은수</span>
								<span class="review-h-date">· 24/05/15</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/로스트아크.jpg">
									<div class="review-info">
										<div class="game-title">로스트아크</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;4.0</span>
											<span class="review-state-play"><i class="fa-solid fa-play fa-sm" style="color: #0085eb;"></i>&nbsp;하고있어요</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">2년째 꾸준히 하고있지만 이제야 에키드나 트라이 중입니다. 이게임은 스토리는 보면안되는 게임입니다. 스토리를 밀고 발탄부터 시작하는게임이에요. 예전 와우가 만렙찍고 시작이라는 말처럼 여기도 스토리는 빨리 패스하고(물론 좋아하시는분들도있습니다만) 레이드부터 시작입니다. 아직은 질리지 않기때문에 계속할 예정이예요. 뭔가 또 재밌는 mmorpg가 나오지않는한...</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member1.jpg"></span>
								<span class="review-h-nickName">닉네임</span>
								<span class="review-h-date">· 24/03/12</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/하이파이러시.jpg">
									<div class="review-info">
										<div class="game-title">하이파이 러시</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;5.0</span>
											<span class="review-state-done"><i class="fa-solid fa-check" style="color: #00c722;"></i>&nbsp;다했어요</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">게임을 끄고 나서도 내 심장에 차이처럼 박혀있는 비트사운드! 어드벤쳐와 리듬게임의 조화도 더할 나위 없지만 캐릭터들, 연출과 그래픽디자인이 너무 경쾌해서 켤 때마다 너무 기대되고 그만큼 재밌게했다. 게임 행위성의 디자인은 클래식하지만 연출만 훌륭하게 해도 멋지게 나온다는 걸 증명하는 게임 같다. 이제는 락은 죽었지만 한 때 락스타를 꿈꿨던 학창시절의 대책없던 기분좋은 환상을 떠올리게 만드는 게임. 스토리의 익숙함도 뭐 흠이 될 정도가 아니니까 너무 짧은 게 기분좋은 흠이다!</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>❤️ 인기 스토어 게임</span>
					<span class="more">모두 보기</span>
				</div>
				<div class="content-box">
					<div class="store-game">
						<div class="s-game">
							<img src="${ctp}/game/디제이맥스.jpg">
							<div class="s-game-name">DJMAX RESPECT V</div>
							<div>#리듬게임</div>
							<div class="s-game-price">49,800원</div>
						</div>
						<hr class="mobile-line" />
						<div class="s-game">
							<img src="${ctp}/game/발더스게이트.jpg">
							<div class="s-game-name">발더스 게이트 3</div>
							<div>#턴제 #RPG</div>
							<div class="s-game-price">66,000원</div>
						</div>
						<hr class="mobile-line" />
						<div class="s-game">
							<img src="${ctp}/game/팰월드.jpg">
							<div class="s-game-name">Palworld / 팰월드</div>
							<div>#액션 #어드벤처 #RPG</div>
							<div class="s-game-price">32,000원</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="content1">
			<div class="popcommunity">
				<div class="popcommunity-title">
					<span>🔥 커뮤니티 인기글</span>
					<span class="more">더보기</span>
				</div>
				<div class="content-box">
					<div class="popcommunity-img">
						<div>
							<img src="${ctp}/community/cm1.png" alt="커뮤니티이미지">
							<div><span class="category">일지</span>6월 초에 [페이퍼 마리오 1000년의 문 (2024)] 플레이하다가 갑자기 스위치 본체가 뜨거워져서 강제 슬립 모드 되는 증상을 처음 겪어봤는데요. 또 희한한게 [스플래툰 3] 빅런 (6월 8일~10일)</div>
						</div>
						<div>
							<img src="${ctp}/community/cm2.png" alt="커뮤니티이미지">
							<div><span class="category">소식/정보</span>[Steam (Platform)] 클라이언트에 녹화기능이 들어갔습니다. 게다가 [Steam Deck]에서도 된다하네요.스팀 게임 아닌 곳에서도 사용 가능이라 하여, nvidia나 ms의 게임바 도 대체할 수 있을듯</div>
						</div>
					</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">소식/정보</span>#소식</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">일지</span>스팀에 라이브러리에 사놓기만 하고 하지 않은 게임이 무려 26조 규모!</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">일지</span>흠 ... 이게 뭘까~</div>
				</div>
			</div>
			<div class="sale">
				<div class="sale-title">
					<span>💵 최신 세일정보</span>
					<span class="more">더보기</span>
				</div>
				<div class="content-box">
					<div class="sale-img">
						<div>
							<img src="${ctp}/community/cm3.jpg" alt="커뮤니티이미지">
							<div><span class="category">일지</span>[EA 스포츠 FC 24] 이건데 되게 싸네요.. 여름세일 좋아용 😍</div>
						</div>
						<div>
							<img src="${ctp}/community/sale_thumbnail.png" alt="커뮤니티이미지">
							<div><span class="category">일지</span>#스팀 #여름세일 이하는 "스팀 평가 매우 긍정적(80%이상 긍정적) & 3만원 이하 & 역대 최저가 경신" 에 해당하는 게임 일부를 소개합니다.</div>
						</div>
					</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>[최대 90% 할인] ⛱️ 인겜토리 스토어 여름 세일</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>음!? 스팀 여름 할인이네???? 이건 못 참지 ㅋㅋㅋㅋ</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>[Steam (Platform)] 에서 여름할인을 시작하면서, "대폭 할인" 으로 별도의 페이지를 만들었습니다. 하나 -85% 빼고, 나머지 다 -90%가 넘는데, 뭐 사실 그게 중요한건 아니고.</div>
				</div>
			</div>
		</div>
		<div class="content3">
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>❔</span> 자주 묻는 질문</div>
			</div>
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>🕹️</span> 게임 등록 요청</div>
			</div>
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>🙋‍♀️</span> 1:1 문의하기</div>
			</div>
		</div>
	</div>
</main>
<footer>
	<div class="footer-menu">
		<img src="${ctp}/images/logo.png" height="50px" />
		<span>문의하기</span>
		<span>게임순위</span>
		<span>게임찾기</span>
		<span>게임평가</span>
		<span>게임요청</span>
	</div>
	<div>서울특별시 금천구 가산디지털1로 137 IT캐슬2차 13층 | 대표/개인정보관리자: 김한나 | 사업자등록번호: 251-31-27569 | 통신판매업신고번호: 2022-서울금천-1834</div>
	<div style="color:#00c722;">Copyrightⓒ pr0ve All Rights reserved.</div>
</footer>
</body>
</html>