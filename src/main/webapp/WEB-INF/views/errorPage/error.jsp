<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>삭제된 페이지 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
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
	body {
		background-color: #32373d;
		height: 100vh;
		font-family: 'SUITE-Regular';
	}
	.errorMain {
		position: absolute;
		left: 50%;
		top: 50%;
		transform: translate(-50%, -50%);
	}
	.error {
		font-family:'DNFBitBitv2';
		font-size: 80px;
		color:#00c722;
	}
	.text {
		color:#b2bdce;
		font-size: 20px;
	}
	.fa-xxxl {
		font-size: 100px;
		color: #00c722;
	}
	.button {
		border-radius: 15px;
		padding: 5px 15px;
		background-color: #00c722d1;
		color: #fff;
		border-color: #00c722;
		min-width: 120px;
		text-align: center;
	}

</style>
</head>
<body>
	<div class="errorMain text-center">
		<i class="fa-solid fa-triangle-exclamation fa-xxxl"></i>
	    <div class="error">ERROR</div>
	    <div class="text">이런... 뭔가 문제가 생겼어요!</div>
	    <button class="mt-3 button" onclick="location.href='${ctp}/';">인겜토리 메인으로</button>
	</div>
</body>
</html>