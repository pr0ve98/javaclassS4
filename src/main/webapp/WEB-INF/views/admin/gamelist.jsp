<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게임리스트 | 관리자모드</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");

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
		
		// 플랫폼 버튼 클릭 이벤트
		const buttons = document.querySelectorAll('.g-button');
        
        buttons.forEach(button => {
        	button.addEventListener('click', function () {
                button.classList.toggle('g-button-active');
            });
        });
        
		// 수정 플랫폼 버튼 클릭 이벤트
		const ebuttons = document.querySelectorAll('.eg-button');
        
        ebuttons.forEach(ebutton => {
        	ebutton.addEventListener('click', function () {
                ebutton.classList.toggle('eg-button-active');
            });
        });
	});

	function showPopupAdd() {
    	const popup = document.querySelector('#popup-add');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
	
	function imageUpload() {
		$("#inputImgs").trigger('click');
	}
	
	function gameImgFormOpen() {
		$("#gameImgForm").show();
	}
	
	function eimageUpload() {
		$("#einputImgs").trigger('click');
	}
	
	function egameImgFormOpen() {
		$("#egameImgForm").show();
	}
	
	function gameAdd() {
		let fileName = document.getElementById("inputImgs").value.trim();
		let ext = fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
		let maxSize = 1024 * 1024 * 20 // 기본단위는 Byte, 1024 * 1024 * 20 = 20MB 허용
		
		let gameTitle = document.getElementById("gameTitle").value.trim();
		let gameSubTitle = document.getElementById("gameSubTitle").value.trim();
		let jangre = document.getElementById("jangre").value.trim();
		let showDate = document.forms["gameaddform"]["showDate"].value;
		let price = document.getElementById("price").value.trim();
		let metascore = document.getElementById("metascore").value.trim();
		let steamscore = document.getElementById("steamscore").value.trim();
		let steamPage = document.getElementById("steamPage").value.trim();
		let developer = document.getElementById("developer").value.trim();
		let gameImg = document.getElementById("gameImg").value.trim();
		let gameInfo = document.getElementById("gameInfo").value.trim();
		
		const platformActive = document.querySelectorAll('.g-button-active');

		let platform = '';

		platformActive.forEach((button) => {
			platform += button.getAttribute('data-platform') + ', ';
		});
		
		platform = platform.substring(0, platform.length-2);
		
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'block';
		html.style.overflow = 'hidden';
		
		if(gameTitle == "") {
			alert("게임의 이름을 입력하세요");
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
			return false;
		}
		
		if(fileName == "" && gameImg == ""){
			alert("업로드할 파일을 선택하세요");
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
			return false;
		}
		
 		if(fileName != "") {
			let fileSize = document.getElementById("inputImgs").files[0].size;
			if(fileSize > maxSize){
				alert("업로드할 파일의 최대크기는 20MB입니다");
		        $('.mask').hide();
		        $('html').css('overflow', 'auto');
			}
			else if(ext != 'jpg' && ext != 'png' &&ext != 'gif' &&ext != 'jpeg'){
				alert("이미지 파일만 업로드해주세요");
		        $('.mask').hide();
		        $('html').css('overflow', 'auto');
			}
			else {
				let vo = new FormData();
				vo.append("fileName", document.getElementById("inputImgs").files[0]);
				vo.append("gameTitle", gameTitle);
				vo.append("gameSubTitle", gameSubTitle);
				vo.append("jangre", jangre);
				vo.append("platform", platform);
				vo.append("showDate", showDate);
				vo.append("price", price);
				vo.append("metascore", metascore);
				vo.append("steamscore", steamscore);
				vo.append("steamPage", steamPage);
				vo.append("developer", developer);
				vo.append("gameInfo", gameInfo);
				
				$.ajax({
					url : "${ctp}/admin/gameInput",
					type : "post",
					data : vo,
					processData: false,
					contentType: false,
					success : function(res) {
						if(res == "1"){
							mask.style.display = 'none';
							html.style.overflow = 'auto';
							location.reload();
						}
					},
					error : function() {
						alert("오류!!");
				        $('.mask').hide();
				        $('html').css('overflow', 'auto');
					}
				});
			}
		}
		else if(fileName == "" && gameImg != ""){
			let query = {
					gameTitle : gameTitle,
					gameSubTitle : gameSubTitle,
					jangre:jangre,
					platform:platform,
					showDate:showDate,
					price:price,
					metascore:metascore,
					steamscore:steamscore,
					steamPage:steamPage,
					developer:developer,
					gameImg:gameImg,
					gameInfo:gameInfo
			}
			
			// query라는 객체를 넘기기 때문에 formData나 json형식으로 넘겨야
			// @RequestBody(json)와 @ModelAttribute(formData)로 받을 수 있음
			// 기존 ajax 타입인 application/x-www-form-urlencoded로 받으려면 @RequestBody MultiValueMap<String, String>
			// 이런 식으로 맵으로 받아 변경해주어야 함
			$.ajax({
				url : "${ctp}/admin/gameInput2",
				type : "post",
	            data: JSON.stringify(query),
	            contentType: "application/json",
				success : function(res) {
					if(res == "1"){
						mask.style.display = 'none';
						html.style.overflow = 'auto';
						location.reload();
					}
					else if(res == "2") {
						alert("이미 해당 게임이 존재합니다!");
				        $('.mask').hide();
				        $('html').css('overflow', 'auto');
						return false;
					}
				},
				error : function() {
					alert("오류!!");
			        $('.mask').hide();
			        $('html').css('overflow', 'auto');
				}
			});
		}
	}
	
	
	function showGameEditPopup(voString) {
		let vo = parseGameVO(voString);
		
		if(vo.platform != null && vo.platform != ''){
			let platforms = vo.platform.split(", ");
			 platforms.forEach(platform => {
			        document.querySelectorAll('.eg-button').forEach(button => {
			            if (button.getAttribute('data-platform') === platform) {
			                button.classList.add('eg-button-active');
			            }
			        });
			    });
		}
		
		let gameImg = '';
		if(vo.gameImg.indexOf('http') != -1) {
			gameImg = vo.gameImg;
			$("#imgView").html("<img src='"+gameImg+"' width='100%'/>");
		}
		else $("#imgView").html("<img src='${ctp}/game/"+vo.gameImg+"' width='100%'/>");
		
		$("#gameIdx").val(vo.gameIdx);
		$("#egameTitle").val(vo.gameTitle);
		$("#egameSubTitle").val(vo.gameSubTitle);
		$("#ejangre").val(vo.jangre);
		$("#eshowDate").val(vo.showDate);
		$("#eprice").val(vo.price);
		$("#einvenscore").val(vo.invenscore);
		$("#emetascore").val(vo.metascore);
		$("#esteamscore").val(vo.steamscore);
		$("#esteamPage").val(vo.steamPage);
		$("#edeveloper").val(vo.developer);
		$("#egameImg").val(gameImg);
		if(vo.gameInfo != null && vo.gameInfo != '') $("#egameInfo").val(vo.gameInfo.replace(/<br\/>/g, '\n'));
		
    	const popup = document.querySelector('#popup-gameedit');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
		
	}
	
    function parseGameVO(voString) {
    	voString = voString.replace(/^GameVO\((.*)\)$/, '$1'); // 마지막 괄호 제거
        const keyValuePairs = voString.split(/, (?=\w+=)/); // 각 키-값 쌍을 분리
        const vo = {};

        keyValuePairs.forEach(pair => {
            const [key, value] = pair.split(/=(.+)/); // 첫 번째 등호로 분리
            let parsedValue = value;

            // 숫자 변환
            if (!isNaN(parsedValue) && parsedValue !== '') {
                parsedValue = Number(parsedValue);
            }

            // Boolean 변환
            if (parsedValue === 'true') {
                parsedValue = true;
            } else if (parsedValue === 'false') {
                parsedValue = false;
            }

            // 특수문자 복원
            if (typeof parsedValue === 'string') {
                parsedValue = parsedValue.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
            }

            vo[key.trim()] = parsedValue;
        });

        return vo;
   }

	function gameEdit() {
		let fileName = '';
		if(document.getElementById("einputImgs") != null) fileName = document.getElementById("einputImgs").value;
		
		let gameIdx = document.getElementById("gameIdx").value;
		let gameTitle = document.getElementById("egameTitle").value.trim();
		let gameSubTitle = document.getElementById("egameSubTitle").value.trim();
		let jangre = document.getElementById("ejangre").value.trim();
		let showDate = document.forms["egameaddform"]["eshowDate"].value;
		let price = document.getElementById("eprice").value.trim();
		let metascore = document.getElementById("emetascore").value.trim();
		let steamscore = document.getElementById("esteamscore").value.trim();
		let steamPage = document.getElementById("esteamPage").value.trim();
		let developer = document.getElementById("edeveloper").value.trim();
		let gameImg = document.getElementById("egameImg").value.trim();
		let gameInfo = document.getElementById("egameInfo").value.trim();
		
		const platformActive = document.querySelectorAll('.eg-button-active');

		let platform = '';

		platformActive.forEach((button) => {
			platform += button.getAttribute('data-platform') + ', ';
		});
		
		platform = platform.substring(0, platform.length-2);
		
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'block';
		html.style.overflow = 'hidden';
		
		if(gameTitle == "") {
			alert("게임의 이름을 입력하세요");
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
			return false;
		}
		
		if(fileName == "" && gameImg == ""){
			alert("업로드할 파일을 선택하세요");
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
			return false;
		}
		
 		if(fileName != "") {
 			let ext = fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
 			let maxSize = 1024 * 1024 * 20 // 기본단위는 Byte, 1024 * 1024 * 20 = 20MB 허용
			let fileSize = document.getElementById("einputImgs").files[0].size;
			if(fileSize > maxSize){
				alert("업로드할 파일의 최대크기는 20MB입니다");
		        $('.mask').hide();
		        $('html').css('overflow', 'auto');
			}
			else if(ext != 'jpg' && ext != 'png' &&ext != 'gif' &&ext != 'jpeg'){
				alert("이미지 파일만 업로드해주세요");
		        $('.mask').hide();
		        $('html').css('overflow', 'auto');
			}
			else {
				let vo = new FormData();
				vo.append("fileName", document.getElementById("einputImgs").files[0]);
				vo.append("gameIdx", gameIdx);
				vo.append("gameTitle", gameTitle);
				vo.append("gameSubTitle", gameSubTitle);
				vo.append("jangre", jangre);
				vo.append("platform", platform);
				vo.append("showDate", showDate);
				vo.append("price", price);
				vo.append("metascore", metascore);
				vo.append("steamscore", steamscore);
				vo.append("steamPage", steamPage);
				vo.append("developer", developer);
				vo.append("gameInfo", gameInfo);
				
				$.ajax({
					url : "${ctp}/admin/gameEdit",
					type : "post",
					data : vo,
					processData: false,
					contentType: false,
					success : function(res) {
						if(res == "1"){
							mask.style.display = 'none';
							html.style.overflow = 'auto';
							location.reload();
						}
						else if(res == "2") {
							alert("중복되는 이름을 가진 게임이 존재합니다!");
					        $('.mask').hide();
					        $('html').css('overflow', 'auto');
							return false;
						}
					},
					error : function() {
						alert("오류!!");
				        $('.mask').hide();
				        $('html').css('overflow', 'auto');
					}
				});
			}
		}
		else if(fileName == "" && gameImg != ""){
			let query = {
					gameIdx : gameIdx,
					gameTitle : gameTitle,
					gameSubTitle : gameSubTitle,
					jangre:jangre,
					platform:platform,
					showDate:showDate,
					price:price,
					metascore:metascore,
					steamscore:steamscore,
					steamPage:steamPage,
					developer:developer,
					gameImg:gameImg,
					gameInfo:gameInfo
			}
			
			// query라는 객체를 넘기기 때문에 formData나 json형식으로 넘겨야
			// @RequestBody(json)와 @ModelAttribute(formData)로 받을 수 있음
			// 기존 ajax 타입인 application/x-www-form-urlencoded로 받으려면 @RequestBody MultiValueMap<String, String>
			// 이런 식으로 맵으로 받아 변경해주어야 함
			$.ajax({
				url : "${ctp}/admin/gameEdit2",
				type : "post",
	            data: JSON.stringify(query),
	            contentType: "application/json",
				success : function(res) {
					if(res == "1"){
						mask.style.display = 'none';
						html.style.overflow = 'auto';
						location.reload();
					}
					else if(res == "2") {
						alert("중복되는 이름을 가진 게임이 존재합니다!");
				        $('.mask').hide();
				        $('html').css('overflow', 'auto');
						return false;
					}
				},
				error : function() {
					alert("오류!!");
			        $('.mask').hide();
			        $('html').css('overflow', 'auto');
				}
			});
		}
	}
	
	function gameDelete(gameIdx, gameImg) {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
        let ans = confirm("해당 게임을 삭제하시겠습니까?");
        
        if(ans) {
			$.ajax({
				url : "${ctp}/admin/gameDelete",
				type : "post",
	            data: {gameIdx:gameIdx, gameImg:gameImg},
				success : function(res) {
					if(res != "0"){
						mask.style.display = 'none';
						html.style.overflow = 'auto';
						location.reload();
					}
				},
				error : function() {
					alert("전송오류!");
			        $('.mask').hide();
			        $('html').css('overflow', 'auto');
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
				<h2>게임리스트</h2>
				<div style="display: flex; justify-content: space-between;">
					<div id="searchlist" style="display: flex;">
						<select name="searchpart" class="dropdown-btn mr-4">
							<option>이름</option>
							<option>개발사</option>
						</select>
						<input type="text" name="search" id="search" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" style="width: 100%;" />
					</div>
					<span id="resetpc"><button class="joinBtn-sm" onclick="location.href='${ctp}/admin/gamelist';">초기화면으로</button></span>
				</div>
				<div id="resetmobile" class="text-right mt-3"><button class="badge badge-success" onclick="location.href='${ctp}/admin/gamelist';">초기화면으로</button></div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}개<button class="badge badge-warning ml-3" onclick="showPopupAdd()">추가</button></div>
			<select name="part" class="dropdown-btn">
				<option>최근 등록된순</option>
				<option>많이 담은순</option>
				<option>발매일 최신순</option>
				<option>발매일 오래된순</option>
				<option>인벤스코어 높은순</option>
				<option>인벤스코어 낮은순</option>
				<option>메타스코어 높은순</option>
				<option>메타스코어 낮은순</option>
			</select>
		</div>
		<p><br/></p>
		<table id="custom-responsive-table" class="table table-borderless text-center" style="color:#fff;">
			<tr id="thbody" class="text-center">
				<th colspan="2">제목</th>
				<th>장르</th>
				<th>플랫폼</th>
				<th>출시일</th>
				<th>인벤스코어</th>
				<th>메타스코어</th>
				<th>비고</th>
			</tr>
			<c:forEach var="vo" items="${vos}">
				<tr>
					<td style="padding-left: .75rem">
						<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" class="gamelistImg"></c:if>
						<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="gamelistImg"></c:if>
					</td>
					<td data-title="제목" class="text-left">
						<div>&nbsp;&nbsp;${vo.gameTitle}</div>
						<div style="font-size:12px; color:#b2bdce">&nbsp;&nbsp;${vo.gameSubTitle}</div>
					</td>
					<td data-title="장르">&nbsp;&nbsp;${vo.jangre}</td>
					<td data-title="플랫폼">&nbsp;&nbsp;${vo.platform}</td>
					<td data-title="출시일">&nbsp;&nbsp;${fn:substring(vo.showDate, 0, 4)}</td>
					<td data-title="인벤스코어">
						<c:if test="${vo.invenscore == 0.0}">&nbsp;</c:if>
						<c:if test="${vo.invenscore != 0.0}">&nbsp;&nbsp;${vo.invenscore}</c:if>
					</td>
					<td data-title="메타스코어">
						<c:if test="${vo.metascore == 0.0}">&nbsp;</c:if>
						<c:if test="${vo.metascore != 0.0}">&nbsp;&nbsp;<img src="https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/color/Metacritic.svg" alt="" class="icon" width="18px">${vo.metascore}</c:if>
					</td>
					<td>
						<button class="badge badge-success" onclick="showGameEditPopup('${fn:replace(fn:replace(fn:replace(vo, '\'', ''), '\"', '&quot;'), newLine, '<br/>')}')">수정</button>
						<button class="badge badge-danger" onclick="gameDelete(${vo.gameIdx}, '${vo.gameImg}')">삭제</button>
					</td>
				</tr>
			</c:forEach>
		</table>
		<div class="news-page">
			<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/admin/gamelist?page=${page-1}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
	        <span class="page-info">${page}/${totPage}</span>
	        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/admin/gamelist?page=${page+1}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-add" class="hide">
  <div class="popup-add-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 등록</div>
    		<a href="" onclick="closePopup('add')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-add-main">
			<form name="gameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="gameTitle" id="gameTitle" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="gameSubTitle" id="gameSubTitle" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="jangre" id="jangre" placeholder="장르를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>플랫폼</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="g-button" data-platform="PC">PC</span>
			                    <span class="g-button" data-platform="PS4">PS4</span>
			                    <span class="g-button" data-platform="PS5">PS5</span>
			                    <span class="g-button" data-platform="XBO">XBO</span>
			                    <span class="g-button" data-platform="XSX">XSX</span>
			                    <span class="g-button" data-platform="XSS">XSS</span>
			                    <span class="g-button" data-platform="Switch">Switch</span>
			                    <span class="g-button" data-platform="Android">Android</span>
			                    <span class="g-button" data-platform="iOS">iOS</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>출시일</th>
						<td><input type="date" name="showDate" id="showDate" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="price" id="price" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="metascore" id="metascore" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="steamscore" id="steamscore" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="steamPage" id="steamPage" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="developer" id="developer" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이미지</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="i-button" onclick="imageUpload()">직접 등록</span>
			                    <span style="display:none"><input type="file" name="file" id="inputImgs" accept=".jpg,.gif,.png,.jpeg" /></span>
			                    <span class="i-button" onclick="gameImgFormOpen()">주소로 등록</span>
							</div>
							<div id="gameImgForm" style="display:none"><input type="text" name="gameImg" id="gameImg" placeholder="이미지 주소를 입력하세요" class="forminput" /></div>
						</td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="gameInfo" id="gameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea"></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="hidden" name="gameIdx" id="gameIdx" />
							<input type="button" class="joinBtn-sm" value="추가" onclick="gameAdd()" />
						</td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
<div id="popup-gameedit" class="hide">
  <div class="popup-gameedit-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 수정</div>
    		<a href="" onclick="closePopup('gameedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-add-main">
			<form name="egameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<td colspan="2" id="imgView"></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="egameTitle" id="egameTitle" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="egameSubTitle" id="egameSubTitle" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="ejangre" id="ejangre" placeholder="장르를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>플랫폼</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="eg-button" data-platform="PC">PC</span>
			                    <span class="eg-button" data-platform="PS4">PS4</span>
			                    <span class="eg-button" data-platform="PS5">PS5</span>
			                    <span class="eg-button" data-platform="XBO">XBO</span>
			                    <span class="eg-button" data-platform="XSX">XSX</span>
			                    <span class="eg-button" data-platform="XSS">XSS</span>
			                    <span class="eg-button" data-platform="Switch">Switch</span>
			                    <span class="eg-button" data-platform="Android">Android</span>
			                    <span class="eg-button" data-platform="iOS">iOS</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>출시일</th>
						<td><input type="date" name="eshowDate" id="eshowDate" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="eprice" id="eprice" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="emetascore" id="emetascore" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="esteamscore" id="esteamscore" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="esteamPage" id="esteamPage" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="edeveloper" id="edeveloper" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이미지</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="i-button" onclick="eimageUpload()">직접 등록</span>
			                    <span style="display:none"><input type="file" name="file" id="einputImgs" accept=".jpg,.gif,.png,.jpeg" /></span>
			                    <span class="i-button" onclick="egameImgFormOpen()">주소로 등록</span>
							</div>
							<div id="egameImgForm" style="display:none"><input type="text" name="egameImg" id="egameImg" placeholder="이미지 주소를 입력하세요" class="forminput" /></div>
						</td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="egameInfo" id="egameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea"></textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" class="joinBtn-sm" value="수정" onclick="gameEdit()" /></td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
</body>
</html>