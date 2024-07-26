<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원리스트 | 관리자모드</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';

		window.addEventListener('load', function() {
			const mask = document.querySelector('.mask');
	        const html = document.querySelector('html');
	        
			mask.style.display = 'none';
			html.style.overflow = 'auto';
		});
		
		// 검색창 엔터로 검색
        let searchInput = document.getElementById('search');

	    if (searchInput) {
	        searchInput.addEventListener('keyup', function(e) {
	            if (e.key === 'Enter') {
	        		let viewpart = $("#viewpart").val();
	        		let searchpart = $("#searchpart").val();
	        		let search = $("#search").val();
	        		location.href = "${ctp}/admin/userlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	            }
	        });
	    }
	});
	
	function partchange() {
		let viewpart = $("#viewpart").val();
		let searchpart = $("#searchpart").val();
		let search = $("#search").val();
		location.href = "${ctp}/admin/userlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	}
	
	function levelChange(idx) {
		$("#levelBtn"+idx).hide();
		$("#levelShow"+idx).hide();
		$("#levelCanBtn"+idx).show();
		$("#levelOkBtn"+idx).show();
		$("#levelSelect"+idx).show();
	}
	
	function levelChangeCancle(idx) {
		$("#levelBtn"+idx).show();
		$("#levelShow"+idx).show();
		$("#levelCanBtn"+idx).hide();
		$("#levelOkBtn"+idx).hide();
		$("#levelSelect"+idx).hide();
	}
	
	function levelChangeOk(idx, nickname) {
		let level = $("#selectlevel"+idx).val();
		
		$.ajax({
 			url : "${ctp}/admin/levelChange",
 			type : "post",
 			data : {level : level, idx : idx, nickname : nickname},
 			success : function(res) {
 				if(res != "0") location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
	
 	function reportPopup(banMid) {
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        $("#banMid").val(banMid);
	}
 	
 	function banInput() {
		let reason = $("select[name=reason]").val();
		let banMid = $("#banMid").val();
		
		if(reason == '') {
			alert("신고사유를 선택해주세요");
			return false;
		}
		
 		$.ajax({
 			url : "${ctp}/admin/banInput",
 			type : "post",
 			data : {banMid:banMid, reason:reason},
 			success : function() {
 				alert(banMid+" 사용자를 제재하였습니다");
 				location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
		
	}
 	
 	function reportDown(mid) {
		let ans = confirm("정말 제재를 푸시겠습니까?");
		if(ans) {
	 		$.ajax({
	 			url : "${ctp}/admin/reportDown",
	 			type : "post",
	 			data : {banMid:mid},
	 			success : function() {
	 				alert(mid+" 사용자 제재를 해제하였습니다");
	 				location.reload();
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
		}
	}
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="container">
		<div class="setting-main">
			<div class="setting-right">
				<h2>회원리스트</h2>
				<div style="display: flex; justify-content: space-between;">
					<div id="searchlist" style="display: flex;">
						<select id="searchpart" name="searchpart" class="dropdown-btn mr-4">
							<option ${searchpart == '아이디' ? 'selected' : ''}>아이디</option>
							<option ${searchpart == '닉네임' ? 'selected' : ''}>닉네임</option>
						</select>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" style="width: 100%;" />
					</div>
					<span id="resetpc"><button class="joinBtn-sm" onclick="location.href='${ctp}/admin/userlist';">초기화면으로</button></span>
				</div>
				<div id="resetmobile" class="text-right mt-3"><button class="badge badge-success" onclick="location.href='${ctp}/admin/gamelist';">초기화면으로</button></div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}명</div>
			<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()">
				<option value="all" ${viewpart == 'all' ? 'selected' : ''}>모두 보기</option>
				<option value="0" ${viewpart == '0' ? 'selected' : ''}>관리자만 보기</option>
				<option value="1" ${viewpart == '1' ? 'selected' : ''}>기자만 보기</option>
				<option value="2" ${viewpart == '2' ? 'selected' : ''}>일반 회원만 보기</option>
				<option value="OK" ${viewpart == 'OK' ? 'selected' : ''}>활동중 회원만 보기</option>
				<option value="NO" ${viewpart == 'NO' ? 'selected' : ''}>제재중 회원만 보기</option>
				<option value="BAN" ${viewpart == 'BAN' ? 'selected' : ''}>영구정지 회원만 보기</option>
				<option value="OUT" ${viewpart == 'OUT' ? 'selected' : ''}>탈퇴 회원만 보기</option>
				<option value="kakao" ${viewpart == 'kakao' ? 'selected' : ''}>카카오 가입 회원만 보기</option>
				<option value="normal" ${viewpart == 'normal' ? 'selected' : ''}>일반 가입 회원만 보기</option>
			</select>
		</div>
		<p><br/></p>
		<c:if test="${fn:length(vos) == 0}">
			<div style="margin: 200px 0; font-size:20px;" class="text-center">해당하는 회원이 없습니다!</div>
		</c:if>
		<c:if test="${fn:length(vos) > 0}">
			<table id="custom-responsive-table" class="table table-borderless text-center" style="color:#fff;">
				<tr id="thbody" class="text-center">
					<th>닉네임</th>
					<th>아이디</th>
					<th>이메일</th>
					<th>회원등급</th>
					<th>상태</th>
					<th>비고</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td data-title="닉네임">&nbsp;&nbsp;${vo.nickname}</td>
						<td data-title="아이디">&nbsp;&nbsp;${vo.mid}</td>
						<td data-title="이메일">&nbsp;&nbsp;${vo.email}</td>
						<td data-title="회원등급">&nbsp;&nbsp;
							<c:if test="${vo.level == 0}"><span id="levelShow${vo.idx}">관리자</span></c:if>
							<c:if test="${vo.level == 1}"><span id="levelShow${vo.idx}">기자</span></c:if>
							<c:if test="${vo.level == 2}"><span id="levelShow${vo.idx}">일반</span></c:if>
							<span id="levelSelect${vo.idx}" style="display:none;">
								<select id="selectlevel${vo.idx}" class="dropdown-btn" style="padding: 0 10px;">
									<option value="0" ${vo.level == 0 ? 'selected' : ''}>관리자</option>
									<option value="1" ${vo.level == 1 ? 'selected' : ''}>기자</option>
									<option value="2" ${vo.level == 2 ? 'selected' : ''}>일반</option>
								</select>
							</span>
						</td>
						<td data-title="상태">&nbsp;&nbsp;
							<c:if test="${vo.loginState == 'OK'}">활동중</c:if>
							<c:if test="${vo.loginState == 'NO'}"><span style="color:#00c722;">제재중</span>(${vo.banDay}일)</c:if>
							<c:if test="${vo.loginState == 'BAN'}"><span style="color:red;">영구정지</span></c:if>
							<c:if test="${vo.loginState == 'OUT'}">탈퇴</c:if>
						</td>
						<td>
							<button id="levelBtn${vo.idx}" class="badge badge-warning" onclick="levelChange(${vo.idx})">등급변경</button>
							<button id="levelOkBtn${vo.idx}" style="display: none" class="badge badge-primary" onclick="levelChangeOk(${vo.idx}, '${vo.nickname}')">적용</button>
							<button id="levelCanBtn${vo.idx}" style="display: none" class="badge badge-secondary" onclick="levelChangeCancle(${vo.idx})">취소</button>
							<c:if test="${vo.loginState == 'NO' && vo.level != 0}"><button class="badge badge-success" onclick="reportDown('${vo.mid}')">제재 풀기</button></c:if>
							<c:if test="${vo.loginState == 'OK' && vo.level != 0}"><button class="badge badge-danger" onclick="reportPopup('${vo.mid}')">제재하기</button></c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
			<div class="news-page">
				<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/admin/gamelist?page=${page-1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
		        <span class="page-info">${page}/${totPage}</span>
		        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/admin/gamelist?page=${page+1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
			</div>
		</c:if>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-report" class="hide">
  <div class="popup-report-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">제재하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('report')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="text-center mb-4"><select class="dropdown-btn" name="reason">
			<option value="">신고사유 선택</option>
			<option>스팸</option>
			<option>스포일러</option>
			<option value="선정성">나체이미지 또는 성적행위</option>
			<option>사기</option>
			<option value="욕설혐오">욕설, 혐오 발언</option>
			<option>지식재산권 침해</option>
			<option value="명예훼손">타인의 명예 훼손</option>
		</select></div>
 		<input type="hidden" id="banMid" name="banMid" />
	 	<div class="text-center"><button class="btn btn-danger" onclick="banInput()">신고하기</button></div>
    </div>
</div>
</body>
</html>