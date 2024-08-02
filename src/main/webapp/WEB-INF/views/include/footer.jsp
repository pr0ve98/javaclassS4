<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<footer>
	<div class="footer-menu">
		<img src="${ctp}/images/logo.png" height="50px" />
		<span style="cursor:pointer;" onclick="showPopupSupport()">문의하기</span>
		<span style="cursor:pointer;" >게임찾기</span>
		<span style="cursor:pointer;" onclick="location.href='${ctp}/review';">게임평가</span>
		<span style="cursor:pointer;" onclick="showGameEditPopup()">게임요청</span>
	</div>
	<div>서울특별시 금천구 가산디지털1로 137 IT캐슬2차 13층 | 대표/개인정보관리자: 김한나 | 사업자등록번호: 251-31-27569 | 통신판매업신고번호: 2022-서울금천-1834</div>
	<div style="color:#00c722;">Copyrightⓒ pr0ve All Rights reserved.</div>
</footer>