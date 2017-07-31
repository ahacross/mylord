<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>쿼리 실행</title>
	<spring:url value="/resources/js/plugins/jui/jui.css" var="juiCss" />
	<spring:url value="/resources/js/plugins/jui/jennifer.theme.min.css" var="juiThemeCss" />
	<spring:url value="/resources/js/plugins/jquery-ui/jquery-ui.min.css" var="jqueryUiCss" />
	<spring:url value="/resources/js/plugins/font-awesome/css/font-awesome.css" var="fontawesomeCss" />
	<spring:url value="/resources/js/plugins/jQuery.filer/css/jquery.filer.css" var="filerCss" />
	<spring:url value="/resources/js/plugins/alertify/css/alertify.min.css" var="alertifyCss" />
	<spring:url value="/resources/js/plugins/alertify/css/themes/default.min.css" var="alertifyDefaultCss" />
	<spring:url value="/resources/css/main.css" var="mainCss" />
	<spring:url value="/resources/js/plugins/lodash/lodash.js" var="lodashJS" />
	<spring:url value="/resources/js/plugins/jquery/jquery.js" var="jqueryJS" />
	<spring:url value="/resources/js/plugins/alertify/alertify.js" var="alertifyJS" />
	<spring:url value="/resources/js/alertWrap.js" var="alertWrapJS" />
	<spring:url value="/resources/js/common.js" var="commonJS" />
	
	<link rel="stylesheet" type="text/css" href="${juiCss }">
	<link rel="stylesheet" type="text/css" href="${juiThemeCss }">
	<link rel="stylesheet" type="text/css" href="${jqueryUiCss }">
	<link rel="stylesheet" type="text/css" href="${fontawesomeCss }">
	<link rel="stylesheet" type="text/css" href="${alertifyCss }">
	<link rel="stylesheet" type="text/css" href="${alertifyDefaultCss }">
	<link rel="stylesheet" type="text/css" href="${mainCss }">
	
	<script type="text/javascript" src="${lodashJS }"></script>
	<script type="text/javascript" src="${jqueryJS }"></script>	
	<script type="text/javascript" src="${alertifyJS }"></script>
	<script type="text/javascript" src="${alertWrapJS }"></script>
	<script type="text/javascript" src="${commonJS }"></script>
	<style type="text/css">
		td {
		border : 1px solid;
		}
	</style>
</head>
<body class="jui" style="margin:5px;">
	<textarea name="header" rows="2" style="width:95%;" readonly="readonly"></textarea>
	<textarea name="query" rows="10" style="width:95%;"></textarea>
	<a class="btn" id="run">실행</a>	
	<div id="resultArea">
	</div>
<script>
	$(document).ready(function(){
		$("#run").on("click", function(){
			ajax.run({url:"", method:"insert", data:{query:$("[name=query]").val()}}, function(after, before){
				if(after.length > 0){
					var header = _.keys(after[0]);
					query.setDatas(header, after);
					$("[name=header]").val(header.join(", "));
					$("#resultArea").html(query.setHtml());	
				}else{
					$("#resultArea").html(query.noData());
				}
				
			});
		});
	});
	
</script>
</body>
</html>