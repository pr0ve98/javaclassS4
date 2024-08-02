<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게임 요청 목록 | 관리자모드</title>
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
		
		// 검색창 엔터로 검색
        let searchInput = document.getElementById('search');

	    if (searchInput) {
	        searchInput.addEventListener('keyup', function(e) {
	            if (e.key === 'Enter') {
	        		let viewpart = $("#viewpart").val();
	        		let searchpart = $("#searchpart").val();
	        		let search = $("#search").val();
	        		location.href = "${ctp}/admin/gameRequestlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	            }
	        });
	    }
	    
	 	// 플랫폼 버튼 클릭 이벤트
		const buttons = document.querySelectorAll('.g-button');
        
        buttons.forEach(button => {
        	button.addEventListener('click', function () {
                button.classList.toggle('g-button-active');
            });
        });
	    
	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
	});
	
	function eimageUpload() {
		$("#einputImgs").trigger('click');
	}
	
	function egameImgFormOpen() {
		$("#egameImgForm").show();
	}
	
	function gameEditPopup(voString) {
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
				
				if(gameIdx == 0) {
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
								location.href='${ctp}/admin/gamelist';
							}
						},
						error : function() {
							alert("오류!!");
					        $('.mask').hide();
					        $('html').css('overflow', 'auto');
						}
					});
				}
				else {
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
			if(gameIdx == 0) {
				$.ajax({
					url : "${ctp}/admin/gameInput2",
					type : "post",
		            data: JSON.stringify(query),
		            contentType: "application/json",
					success : function(res) {
						if(res == "1"){
							mask.style.display = 'none';
							html.style.overflow = 'auto';
							location.href='${ctp}/admin/gamelist';
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
			else {
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
	}
	
	
	
	function partchange() {
		let viewpart = $("#viewpart").val();
		let searchpart = $("#searchpart").val();
		let search = $("#search").val();
		location.href = "${ctp}/admin/gameRequestlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	}
	
 	function viewContent(contentPart, contentIdx) {
 		$.ajax({
 			url : "${ctp}/admin/viewContent",
 			type : "post",
 			data : {contentPart:contentPart, contentIdx:contentIdx},
 			success : function(response) {
 				let res = response.split("|");
 				$("#contentPartTitle").html(res[0]);
 				$("#cmContent").html(res[1]);
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
 		
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
 	
 	function reportOk(reIdx, banMid, banReason, contentPart, contentIdx) {
 		let ans = confirm("게시글/댓글이 삭제되며 유저는 활동 중지 처리됩니다 처리하겠습니까?");
 		if(ans) {
 			const mask = document.querySelector('.mask');
 			const html = document.querySelector('html');
 			mask.style.display = 'block';
 			html.style.overflow = 'hidden';

	 		$.ajax({
	 			url : "${ctp}/admin/reportOk",
	 			type : "post",
	 			data : {reIdx:reIdx, banMid:banMid, banReason:banReason, contentPart:contentPart, contentIdx:contentIdx},
	 			success : function() {
	 				mask.style.display = 'none';
	 				html.style.overflow = 'auto';
	 				alert("처리 완료!");
					location.reload();
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
 		}
	}
 	
 	function reportDel(reIdx, contentPart, contentIdx) {
 		let ans = confirm("게시글/댓글이 삭제됩니다 처리하겠습니까?");
 		if(ans) {
	 		$.ajax({
	 			url : "${ctp}/admin/reportDel",
	 			type : "post",
	 			data : {reIdx:reIdx, contentPart:contentPart, contentIdx:contentIdx},
	 			success : function() {
	 				alert("처리 완료!");
					location.reload();
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
 		}
	}
 	
 	function requestYes(grIdx) {
 		$.ajax({
 			url : "${ctp}/admin/requestYes",
 			type : "post",
 			data : {grIdx:grIdx},
 			success : function() {
 				alert("처리 완료!");
				location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function requestNo() {
 		let grIdx = $("#grIdx").val();
 		let reason = $("select[name=reason]").val();
 		
 		$.ajax({
 			url : "${ctp}/admin/requestNo",
 			type : "post",
 			data : {grIdx:grIdx, reason:reason},
 			success : function() {
 				alert("처리 완료!");
				location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function NoPopup(grIdx) {
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        $("#grIdx").val(grIdx);
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
				<h2>게임 요청 목록</h2>
				<div style="display: flex; justify-content: space-between;">
					<div id="searchlist" style="display: flex;">
						<select id="searchpart" name="searchpart" class="dropdown-btn mr-4">
							<option ${searchpart == '게임이름' ? 'selected' : ''}>게임이름</option>
							<option ${searchpart == '요청인' ? 'selected' : ''}>요청인</option>
						</select>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" style="width: 100%;" />
					</div>
					<span id="resetpc"><button class="joinBtn-sm" onclick="location.href='${ctp}/admin/gameRequestlist';">초기화면으로</button></span>
				</div>
				<div id="resetmobile" class="text-right mt-3"><button class="badge badge-success" onclick="location.href='${ctp}/admin/gameRequestlist';">초기화면으로</button></div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}개의 요청</div>
			<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()">
				<option value="grIdx desc" ${viewpart == 'grIdx desc' ? 'selected' : ''}>최근순</option>
				<option value="grIdx" ${viewpart == 'grIdx' ? 'selected' : ''}>오래된순</option>
				<option value="notComplete" ${viewpart == 'notComplete' ? 'selected' : ''}>미처리 요청만</option>
				<option value="complete" ${viewpart == 'complete' ? 'selected' : ''}>처리완료 요청만</option>
				<option value="acquittal" ${viewpart == 'acquittal' ? 'selected' : ''}>처리거절 요청만</option>
			</select>
		</div>
		<p><br/></p>
		<c:if test="${fn:length(vos) == 0}">
			<div style="margin: 200px 0; font-size:20px;" class="text-center">해당되는 요청이 없습니다!</div>
		</c:if>
		<c:if test="${fn:length(vos) > 0}">
			<table id="custom-responsive-table" class="table table-borderless text-center" style="color:#fff;">
				<tr id="thbody" class="text-center">
					<th>요청인</th>
					<th>게임 이름</th>
					<th>거절 사유</th>
					<th>비고</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td data-title="요청인">&nbsp;&nbsp;${vo.reqMid}</td>
						<td data-title="게임 이름">&nbsp;&nbsp;${vo.gameTitle}</td>
						<td data-title="거절 사유">&nbsp;&nbsp;${vo.reason}</td>
						<td>
							<c:if test="${vo.grComplete == 0}">
								<button id="levelBtn${vo.grIdx}" class="badge badge-warning" onclick="gameEditPopup('${fn:replace(fn:replace(fn:replace(vo, '\'', ''), '\"', '&quot;'), newLine, '<br/>')}')">등록/수정</button>
								<button id="levelOkBtn${vo.grIdx}" class="badge badge-success" onclick="requestYes(${vo.grIdx})">완료</button>
								<button id="levelOkBtn${vo.grIdx}" class="badge badge-secondary" onclick="NoPopup(${vo.grIdx})">거절</button>
							</c:if>
							<c:if test="${vo.grComplete == 1}">
								<font color="#00c722"><b>수정/등록 완료</b></font>
							</c:if>
							<c:if test="${vo.grComplete == 2}">
								<font color="#aaa">수정/등록 불가</font>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
			<div class="news-page">
				<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/admin/gameRequestlist?page=${page-1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
		        <span class="page-info">${page}/${totPage}</span>
		        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/admin/gameRequestlist?page=${page+1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
			</div>
		</c:if>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-gameedit" class="hide">
  <div class="popup-gameedit-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 요청</div>
    		<div style="cursor:pointer;" onclick="closePopup('gameedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-add-main">
			<form name="egameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
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
						<td colspan="2">
							<input type="hidden" id="gameIdx" name="gameIdx" />
							<input type="button" class="joinBtn-sm" value="수정" onclick="gameEdit()" />
						</td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
<div id="popup-report" class="hide">
  <div class="popup-report-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">등록/수정 거절</span>
    		<div style="cursor:pointer;" onclick="closePopup('report')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="text-center mb-4"><select class="dropdown-btn" name="reason">
			<option value="">거절사유 선택</option>
			<option>이미 등록(변경)됨</option>
			<option>해당 게임 없음</option>
			<option>기타</option>
		</select></div>
 		<input type="hidden" id="grIdx" name="grIdx" />
	 	<div class="text-center"><button class="btn btn-danger" onclick="requestNo()">거절하기</button></div>
    </div>
</div>
</body>
</html>