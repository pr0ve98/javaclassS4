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
<title>${cmVO.newsTitle} | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
	});
	
	function likeAdd(cmIdx) {
		$.ajax({
			url : "${ctp}/community/likeAdd",
			type : "post",
			data : {cmIdx : cmIdx},
			success : function(res) {
				let r = res.split("%");
				$("#cm-likeCnt"+cmIdx).html(r[0]);
				$("#cm-like"+cmIdx).html(r[1]);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	function likeDelete(cmIdx) {
		let ans = confirm("좋아요를 취소하시겠어요?");
		
		if(ans) {
			$.ajax({
				url : "${ctp}/community/likeDelete",
				type : "post",
				data : {cmIdx : cmIdx},
				success : function(res) {
					let r = res.split("%");
					$("#cm-likeCnt"+cmIdx).html(r[0]);
					$("#cm-like"+cmIdx).html(r[1]);
				},
				error : function() {
					alert("전송오류!");
				}
			});
		}
	}
	
	function contentDelete(cmIdx) {
		let ans = confirm("정말로 삭제하시겠습니까?");
		if(ans) {
			$.ajax({
				url : "${ctp}/community/communityDelete",
				type : "post",
				data : {cmIdx:cmIdx},
				success : function(res) {
					if(res != "0") location.href='${ctp}/news/newsRecent';
					else alert("삭제실패!");
				},
				error : function() {
					alert("전송오류!");
				}
			});
		}
	}
	
	function replyPreview(cmIdx) {
		document.getElementById("replyPreview"+cmIdx).style.display = "none";
		document.getElementById("replyWrite"+cmIdx).style.display = "block";
		document.getElementById("replyContent"+cmIdx).focus();
	}
 	
 	function replyCancel(cmIdx) {
		document.getElementById("replyPreview"+cmIdx).style.display = "flex";
		document.getElementById("replyWrite"+cmIdx).style.display = "none";
	}
 	
 	function replyInput(cmIdx) {
 		let replyContent = $("#replyContent"+cmIdx).val().trim();
 		
 		if(replyContent == "") {
 			alert("댓글을 입력해주세요");
 			return false;
 		}
 		
		$.ajax({
			url : "${ctp}/community/replyInput",
			type : "post",
			data : {replyCmIdx : cmIdx, replyContent : replyContent},
			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					replyCancel(cmIdx);
					$("#replyList"+cmIdx).html(res[1]);
					$("#replyContent"+cmIdx).val("");
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function parentReplyMore(cmIdx) {
		$.ajax({
			url : "${ctp}/community/parentReplyMore",
			type : "post",
			data : {replyCmIdx : cmIdx},
			success : function(res) {
				$("#replyList"+cmIdx).html(res);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function rreplyPreview(replyIdx) {
 	   	const elements = document.querySelectorAll('[id^="rreplyWrite"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "rreplyWrite" + replyIdx); // 필터 적용해 조건부로 가져오기
 	    let toggle = document.getElementById("rreplyWrite"+replyIdx);
 	    
 	   otherElements.forEach(element => {
 	   		element.style.display = "none";
 		});
 	    
 	    if (toggle.style.display === "block") {
 	    	toggle.style.display = "none";
 	    } else {
 	    	toggle.style.display = "block";
 	    }
	}
 	
 	function rreplyInput(replyIdx, cmIdx) {
 		let rreplyContent = $("#rreplyContent"+replyIdx).val().trim();
 		
 		if(rreplyContent == "") {
 			alert("답글을 입력해주세요");
 			return false;
 		}
 		
		$.ajax({
			url : "${ctp}/community/rreplyInput",
			type : "post",
			data : {replyCmIdx : cmIdx, replyParentIdx : replyIdx, replyContent : rreplyContent},
			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					rreplyPreview(replyIdx);
					$("#rreplyList"+replyIdx).html(res[1]);
					$("#rreplyContent"+replyIdx).val("");
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function childReplyMore(replyIdx, cmIdx) {
		$.ajax({
			url : "${ctp}/community/childReplyMore",
			type : "post",
			data : {replyCmIdx : cmIdx, replyParentIdx : replyIdx},
			success : function(res) {
				$("#rreplyList"+replyIdx).html(res);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function replyEditPopup(replyIdx, replyContent) {
    	const popup = document.querySelector('#popup-replyedit');
    	const html = document.querySelector('html');
        $("#replyedit").val(replyContent);
        $("#replyIdx").val(replyIdx);
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
 	
 	function replyEdit(cmIdx) {
 		let replyedit = $("#replyedit").val().trim();
 		let replyIdx = $("#replyIdx").val();
 		let replyMid = $("#replyMid").val();
 		
 		$.ajax({
 			url : "${ctp}/community/replyEdit",
 			type : "post",
 			data : {replyContent : replyedit, replyIdx : replyIdx, replyMid : replyMid},
 			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					$("#replyList"+res[2]).html(res[1]);
					closePopup('replyedit');
				}
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function replyDelete(replyIdx, sw) {
		let ans = '';
		if(sw == 0) ans = confirm("댓글을 삭제하시겠어요?\n답글도 전부 삭제됩니다!");
		else ans = confirm("답글을 삭제하시겠어요?");
		
		if(ans) {
	 		$.ajax({
	 			url : "${ctp}/community/replyDelete",
	 			type : "post",
	 			data : {replyIdx : replyIdx},
	 			success : function(res) {
					if(res != "0") {
						location.reload();
					}
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
		}
	}
 	
 	function reportPopup(contentIdx, contentPart, sufferMid) {
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        $("#contentIdx").val(contentIdx);
        $("#contentPart").val(contentPart);
        $("#sufferMid").val(sufferMid);
	}
 	
 	function reportInput() {
		let reason = $("select[name=reason]").val();
		let contentIdx = $("#contentIdx").val();
		let contentPart = $("#contentPart").val();
		let sufferMid = $("#sufferMid").val();
		
		if(reason == '') {
			alert("신고사유를 선택해주세요");
			return false;
		}
		
 		$.ajax({
 			url : "${ctp}/community/reportInput",
 			type : "post",
 			data : {reportMid : '${sMid}', sufferMid:sufferMid, contentPart:contentPart, contentIdx:contentIdx, reason:reason},
 			success : function() {
 				alert("신고가 정상접수 되었습니다!");
 				closePopup('report');
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
		
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
	<div class="container newsviewContainer">
		<div class="more" onclick="javascript:history.back();"><i class="fa-solid fa-chevron-left fa-sm"></i>&nbsp;&nbsp;뒤로가기</div>
		<div class="newsTitle">${cmVO.newsTitle}</div>
		<hr/>
		<div style="display:flex;justify-content: space-between;">
			<div style="display:flex; align-items:center; gap:10px;">
				<div>
					<img src="${ctp}/member/${cmVO.memImg}" alt="프로필" class="reply-pic">
					<span style="font-weight:bold;">${cmVO.nickname}</span>
				</div>
				<div style="color:#b2bdce; font-size:12px;">|
					<c:if test="${cmVO.hour_diff < 1}">${cmVO.min_diff}분 전</c:if>
					<c:if test="${cmVO.hour_diff < 24 && cmVO.hour_diff >= 1}">${cmVO.hour_diff}시간 전</c:if>
					<c:if test="${cmVO.hour_diff >= 24}">${fn:substring(cmVO.cmDate, 0, 10)}</c:if>
				</div>
			</div>
			<div style="display:flex; align-items:center; gap:10px;">
				<div><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;${cmVO.likeCnt}</div>
				<div><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;${cmVO.replyCount}</div>
				<div class="deleteEditNewsPC ml-2">
					<c:if test="${sMid == cmVO.mid}"><span class="mr-2" style="cursor: pointer;" onclick="location.href='${ctp}/news/${cmVO.cmIdx}/edit';">수정</span></c:if>
					<c:if test="${sMid == cmVO.mid || sLevel == 0}"><span style="cursor: pointer;" onclick="contentDelete(${cmVO.cmIdx})">삭제</span></c:if>
				</div>
			</div>
		</div>
		<hr/>
		<div class="deleteEditNewsMB text-right">
			<c:if test="${sMid == cmVO.mid}"><span class="mr-2" style="cursor: pointer;" onclick="location.href='${ctp}/news/${cmVO.cmIdx}/edit';">수정</span></c:if>
			<c:if test="${sMid == cmVO.mid || sLevel == 0}"><span style="cursor: pointer;" onclick="contentDelete(${cmVO.cmIdx})">삭제</span></c:if>
		</div>
		<div class="community-content" style="margin-bottom: 100px;">
			${cmVO.cmContent}
		</div>
		<c:if test="${sMid != null}">
			<hr/>
			<div class="community-footer">
				<span id="cm-like${cmVO.cmIdx}">
					<c:if test="${cmVO.likeSW == 0}"><span onclick="likeAdd(${cmVO.cmIdx})"><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요</span></c:if>
					<c:if test="${cmVO.likeSW == 1}"><span style="color:#00c722;" onclick="likeDelete(${cmVO.cmIdx})"><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요</span></c:if>
				</span>
				<span onclick="replyPreview(${cmVO.cmIdx})"><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;댓글</span>
			</div>
			<hr/>
		</c:if>
		<div id="replyList${cmVO.cmIdx}" class="replyList">
			<c:if test="${cmVO.replyCount > 2}"><div id="moreReply${cmVO.cmIdx}" onclick="parentReplyMore(${cmVO.cmIdx})" class="moreReply">${cmVO.replyCount}개의 댓글 모두 보기</div></c:if>
			<c:forEach var="parentReply" items="${cmVO.parentsReply}">
				<div style="display:flex; align-items:flex-start;" class="mb-4">
					<img src="${ctp}/member/${parentReply.memImg}" alt="프로필" class="reply-pic">
					<div>
						<c:if test="${parentReply.title != '없음'}"><div style="font-size:12px;">${parentReply.title}</div></c:if>
						<div style="font-weight:bold;">${parentReply.nickname}</div>
						<div>${fn:replace(parentReply.replyContent, newLine, "<br/>")}</div>
						<div style="color:#b2bdce; font-size:12px;" class="mt-2">
							<c:if test="${parentReply.hour_diff < 1}">${parentReply.min_diff}분 전</c:if>
							<c:if test="${parentReply.hour_diff < 24 && parentReply.hour_diff >= 1}">${parentReply.hour_diff}시간 전</c:if>
							<c:if test="${parentReply.hour_diff >= 24}">${fn:substring(parentReply.replyDate, 0, 10)}</c:if>
							<c:if test="${sMid != null}">
								<div class="replymenu">
									<span class="mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">답글</span>
									<c:if test="${sMid == parentReply.replyMid}"><span class="mr-2" onclick="replyEditPopup(${parentReply.replyIdx}, '${parentReply.replyContent}')">수정</span></c:if>
									<c:if test="${(sMid == parentReply.replyMid && sLevel != 0) || sLevel == 0}"><span class="mr-2" onclick="replyDelete(${parentReply.replyIdx}, 0)">삭제</span></c:if>
									<span class="mr-2" onclick="reportPopup(${parentReply.replyIdx}, '댓글', '${parentReply.replyMid}')">신고</span>
								</div>
							</c:if>
						</div>
					</div>
				</div>
				<div id="rreplyList${parentReply.replyIdx}" class="rreplyList">
					<c:if test="${parentReply.childReplyCount > 1}"><div id="moreRReply${parentReply.replyIdx}" onclick="childReplyMore(${parentReply.replyIdx},${cmVO.cmIdx})" class="moreReply"> ──&nbsp;&nbsp;${parentReply.childReplyCount}개의 답글 모두 보기</div></c:if>
					<c:forEach var="childReply" items="${cmVO.childReply}">
						<c:if test="${childReply.replyParentIdx == parentReply.replyIdx}">
							<div style="display:flex; align-items:flex-start;" class="mb-4">
								<img src="${ctp}/member/${childReply.memImg}" alt="프로필" class="reply-pic">
								<div>
									<c:if test="${childReply.title != '없음'}"><div style="font-size:12px;">${childReply.title}</div></c:if>
									<div style="font-weight:bold;">${childReply.nickname}</div>
									<div>${fn:replace(childReply.replyContent, newLine, "<br/>")}</div>
									<div style="color:#b2bdce; font-size:12px;" class="mt-2">
										<c:if test="${childReply.hour_diff < 1}">${childReply.min_diff}분 전</c:if>
										<c:if test="${childReply.hour_diff < 24 && childReply.hour_diff >= 1}">${childReply.hour_diff}시간 전</c:if>
										<c:if test="${childReply.hour_diff >= 24}">${fn:substring(childReply.replyDate, 0, 10)}</c:if>
										<c:if test="${sMid != null}">
											<div class="replymenu">
												<span class="mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">답글</span>
												<c:if test="${sMid == childReply.replyMid}"><span class="mr-2" onclick="replyEditPopup(${childReply.replyIdx}, '${childReply.replyContent}')">수정</span></c:if>
												<c:if test="${(sMid == childReply.replyMid && sLevel != 0) || sLevel == 0}"><span class="mr-2" onclick="replyDelete(${childReply.replyIdx}, 1)">삭제</span></c:if>
												<span class="mr-2" onclick="reportPopup(${childReply.replyIdx}, '댓글', '${childReply.replyMid}')">신고</span>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<div id="rreplyWrite${parentReply.replyIdx}" style="display:none; justify-content: center;">
					<div style="display:flex;">
						<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
						<textarea id="rreplyContent${parentReply.replyIdx}" name="rreplyContent" rows="2" placeholder="답글을 작성해 보세요." class="form-control textarea" style="background-color:#484f58;"></textarea>
					</div>
					<div style="display:flex; justify-content: flex-end; margin-top: 5px;">
						<div class="replyno-button mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">취소</div>
						<div class="replyok-button" onclick="rreplyInput(${parentReply.replyIdx}, ${cmVO.cmIdx})">작성</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<c:if test="${sMid != null}">
			<div id="replyPreview${cmVO.cmIdx}" style="display:flex; align-items: center; justify-content: center;">
				<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
				<div class="text-input" style="background-color:#484f58;" onclick="replyPreview(${cmVO.cmIdx})">댓글을 작성해 보세요.</div>
			</div>
			<div id="replyWrite${cmVO.cmIdx}" style="display:none; justify-content: center;">
				<div style="display:flex;">
					<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
					<textarea id="replyContent${cmVO.cmIdx}" name="replyContent" rows="2" placeholder="댓글을 작성해 보세요." class="form-control textarea" style="background-color:#484f58;"></textarea>
				</div>
				<div style="display:flex; justify-content: flex-end; margin-top: 5px;">
					<div class="replyno-button mr-2" onclick="replyCancel(${cmVO.cmIdx})">취소</div>
					<div class="replyok-button" onclick="replyInput(${cmVO.cmIdx})">작성</div>
				</div>
			</div>
		</c:if>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-replyedit" class="hide">
  <div class="popup-replyedit-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">댓글 수정</span>
    		<div style="cursor:pointer;" onclick="closePopup('replyedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
 		<div><input type="text" id="replyedit" name="replyedit" class="forminput mb-3" style="width:100%" placeholder="수정할 댓글을 입력하세요"></div>
 		<input type="hidden" id="replyIdx" name="replyIdx" />
 		<input type="hidden" id="replyMid" name="replyMid" value="${sMid}" />
	 	<div class="text-right"><button class="edit-button" onclick="replyEdit()">수정하기</button></div>
    </div>
</div>
<div id="popup-report" class="hide">
  <div class="popup-report-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">신고하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('report')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="mb-3">확실히 신고사유가 되는지 확인하고 신고하여 주십시오 무분별한 신고 시 <b style="color:red;">신고자가 제재</b>를 당할 수 있습니다</div>
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
 		<input type="hidden" id="contentIdx" name="contentIdx" />
 		<input type="hidden" id="contentPart" name="contentPart" />
 		<input type="hidden" id="sufferMid" name="sufferMid" />
	 	<div class="text-center"><button class="btn btn-danger" onclick="reportInput()">신고하기</button></div>
    </div>
</div>
</body>
</html>