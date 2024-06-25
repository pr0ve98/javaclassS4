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
	html, body, .darkmode {
		background-color: #161d25;
		color: #b2bdce;
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
	</div>
</main>
<footer>

</footer>
</body>
</html>