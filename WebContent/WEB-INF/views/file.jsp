<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>파일 업로드</title>
	<spring:url value="/resources/js/plugins/font-awesome/css/font-awesome.css" var="fontawesomeCss" />
	<spring:url value="/resources/js/plugins/jQuery.filer/css/jquery.filer.css" var="filerCss" />
	<spring:url value="/resources/js/plugins/alertify/css/alertify.min.css" var="alertifyCss" />
	<spring:url value="/resources/js/plugins/alertify/css/themes/default.min.css" var="alertifyDefaultCss" />
	<spring:url value="/resources/css/main.css" var="mainCss" />
	<spring:url value="/resources/js/plugins/jquery/jquery.js" var="jqueryJS" />
	<spring:url value="/resources/js/plugins/jqueryForm/jquery.form.js" var="formJS" />
	<spring:url value="/resources/js/plugins/jQuery.filer/js/jquery.filer.min.js" var="filerJS" />
	<spring:url value="/resources/js/plugins/alertify/alertify.js" var="alertifyJS" />
	<spring:url value="/resources/js/alertWrap.js" var="alertWrapJS" />
	<spring:url value="/resources/js/common.js" var="commonJS" />
	
	<link rel="stylesheet" type="text/css" href="${fontawesomeCss }">
	<link rel="stylesheet" type="text/css" href="${filerCss }">
	<link rel="stylesheet" type="text/css" href="${alertifyCss }">
	<link rel="stylesheet" type="text/css" href="${alertifyDefaultCss }">
	<link rel="stylesheet" type="text/css" href="${mainCss }">
	
	<script type="text/javascript" src="${jqueryJS }"></script>
	<script type="text/javascript" src="${formJS }"></script>
	<script type="text/javascript" src="${filerJS }"></script>
	<script type="text/javascript" src="${alertifyJS }"></script>
	<script type="text/javascript" src="${alertWrapJS }"></script>
	<script type="text/javascript" src="${commonJS }"></script>
</head>
<body>
	<form id="ajaxform">
  		<input type="file" name="files[]" id="filer_input" multiple="multiple"/>
  	</form>
<script>
	var userVars = {};
	
	userVars.uploadFiles = {};
	var options = {
		addMore : true,
		showThumbs: true,
		uploadFile:{
			url: location.pathname.split("/").removeLast().join("/")+"/upload",
			data: {"path":"file"},
			type: 'POST',
			success: function(data, el){
				console.log(123);
				
			    el.find(".jFiler-jProgressBar").fadeOut("slow", function(){});
			    msg.alert("업로드 끝!~", function(){
			    	location.reload();
			    });
			},
			error: function(el){
			    el.find(".jFiler-jProgressBar").fadeOut("slow", function(){});
			}		
		},
		dialogs: {
			alert: function(text) {
		        msg.alert(text);
		    },
		    confirm: function(text, callback) {
		        msg.confirm(text, callback);
		    }
		},

		captions: {
	        button: "파일 선택",
	        feedback: "업로드 할 파일 선택",
	        feedback2: "파일이 선택되었습니다.",
	        removeConfirmation: "이 파일을 제거 하시겠습니까?"
	    }
	};

	userVars.fileTarget = $('#filer_input').filer(options);
	
</script>
</body>
</html>