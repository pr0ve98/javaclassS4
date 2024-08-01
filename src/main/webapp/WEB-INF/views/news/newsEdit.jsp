<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>뉴스 수정 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let initialImages = [];
	let currentImages = [];
	let isWriteButtonClicked = false;
	let initialContent = '';
	

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		$('#summernote').summernote({
	        lang: 'ko-KR',
	        tabsize: 2,
	        height: 700,
	        toolbar: [
	            ['fontsize', ['fontsize']],
	            ['font', ['bold', 'underline', 'clear']],
	            ['color', ['forecolor', 'color']],
	            ['para', ['ul', 'ol', 'paragraph']],
	            ['insert', ['picture', 'link', 'video']],
	            ['view', ['codeview']]
	        ],
	        fontSizes: ['10', '11', '12', '14', '16', '18', '20', '22', '24'],
	        callbacks: {
	            onInit: function() {
	                // 초기 내용 저장
	                initialContent = $('#summernote').summernote('code');
	                $('.note-editable').css({
	                	'font-family':'SUITE-Regular',
	                	'color':'#b2bdce',
	                	'max-width':'1000px',
	                	'background-color':'rgb(96 104 116 / 41%)',
	                	'cursor':'text'
	                });
	            },
	            onImageUpload: function(files) {
	                if (files.length > 0) {
	                    for (let i = 0; i < files.length; i++) {
	                        uploadImage(files[i]);
	                    }
	                }
	            }
	        }
	    });
		
        $('#summernote').next('.note-editor').find('.note-editable img').each(function() {
            let src = $(this).attr('src');
            if (src.indexOf('http') === -1) {
            	initialImages.push(src);
            }
        });
	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
		
        if (localStorage.getItem('formSubmitted') == 'true') {
            resetForm();
            localStorage.removeItem('formSubmitted'); // 상태 제거
        }
	});
	
	function newsInput() {
		let cmIdx = $('#cmIdx').val();
        let content = $('#summernote').summernote('code').trim();
        if(content.indexOf('<p>') == -1) content = '<p>'+content+'</p>';
        let part = $('#part').val();
        let newsTitle = $('#newsTitle').val();

        if (newsTitle == '') {
            alert("글 제목을 입력하세요!");
            $('#newsTitle').focus();
            return false;
        }
        
        if (part == '') {
            alert("카테고리를 선택하세요!");
            return false;
        }
        
        if (content == '' || content == '<p><br></p>') {
            alert("글 내용을 입력하세요!");
            $('#summernote').focus();
            return false;
        }

        $.ajax({
            url: "${ctp}/community/communityEdit",
            type: "post",
            data: {
                cmIdx: cmIdx,
                cmContent: content,
                part: part,
                section: '뉴스',
                newsTitle: newsTitle,
                publicType: '전체'
            },
            success: function(res) {
                if (res != "0") {
                    currentImages = getCurrentImages();
                    detectDeletedImages(initialImages, currentImages);
                    initialImages = [...currentImages];
                	isWriteButtonClicked = true;
                    location.href='${ctp}/news/'+cmIdx;
                }
                else {
					alert("작성 실패...");
                }
            },
            error: function() {
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
	<div class="container">
		<form id="postForm">
			<div class="newsBody">
				<div class="newsSN">
					<input type="text" id="newsTitle" name="newsTitle" placeholder="제목을 입력하세요" value="${vo.newsTitle}" class="forminput mb-3" style="width:100%; font-size: 20px;" />
					<textarea id="summernote" name="content">${vo.cmContent}</textarea>
					<!-- Summernote JS -->
					<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
					<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
					<script>
						// 이미지 업로드
					    function uploadImage(file) {
							let fileSize = file.size;
							let maxSize = 1024 * 1024 * 15;
							
							const imgType = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'];
							if(imgType.indexOf(file.type) == -1){
								alert("이미지 파일만 업로드 해주세요!");
				                return;
							}
							if(fileSize > maxSize) {
								alert("파일의 최대 크기는 15MB입니다");
				                return;
							}
							
					        let data = new FormData();
					        data.append("file", file);
				
					        $.ajax({
					            url: '${ctp}/community/imageUpload',
					            cache: false,
					            contentType: false,
					            processData: false,
					            data: data,
					            type: "POST",
					            success: function(response) {
				                    $('#summernote').summernote('insertImage', response, function($image) {
				                        initialImages.push(response);
				                    });
					            },
					            error: function() {
					                alert("전송오류!");
					            }
					        });
					    }
				
					    // 현재 창에 있는 이미지 가져오기
					    function getCurrentImages() {
					        return $('#summernote').next('.note-editor').find('.note-editable img').map(function() {
					            return $(this).attr('src');
					        }).get();
					    }
				
					    // 이미지 삭제 실행함수
					    function detectDeletedImages(initialImages, currentImages) {
					        initialImages.forEach(function(src) {
					            if (!currentImages.includes(src)) {
					                deleteImage(src);
					            }
					        });
					    }
				
					    // 이미지 삭제 ajax
					    function deleteImage(src) {
					        $.ajax({
					            url: '${ctp}/community/deleteImage',
					            type: 'POST',
					            data: { src: src },
					            error: function() {
					                console.log('이미지 삭제 실패');
					            }
					        });
					    }
					    
				        // 페이지 떠날 때 작성하지 않은 파일들 삭제
						window.onbeforeunload = function() {
				 	    	if(isWriteButtonClicked == false) {
				 	    		currentImages = getCurrentImages();
				                detectDeletedImages(currentImages, initialImages);
				 	    	}
						};
					</script>
				</div>
				<div style="flex-grow:1" class="text-center">
			        <div><select class="dropdown-btn mt-2 mb-2" id="part" name="part" style="width: 100%;">
		                <option value="">카테고리</option>
		                <option ${vo.part == '뉴스' ? 'selected' : ''}>뉴스</option>
		                <option ${vo.part == '취재' ? 'selected' : ''}>취재</option>
		                <option ${vo.part == '예판' ? 'selected' : ''}>예판</option>
		            </select></div>
		            <input type="hidden" id="cmIdx" name="cmIdx" value="${vo.cmIdx}" />
		            <div><input type="button" class="post-button mt-2" value="게시하기" onclick="newsInput()"></div>
				</div>
			</div>
		</form>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>