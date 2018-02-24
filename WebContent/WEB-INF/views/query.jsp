<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>        
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta charset="UTF-8">
	<title>마이로드</title>
	
	<spring:url value="/resources/css/loadWrap.css" var="loadWrapCSS" />
	<link rel="stylesheet" type="text/css" href="${loadWrapCSS }">
	
	<spring:url value="/resources/plugins/jquery/jquery.js" var="jqueryJS" />
	<script type="text/javascript" src="${jqueryJS }"></script>
	
	<spring:url value="/resources/plugins/LAB/LAB.js" var="LABJs" />
	<script type="text/javascript" src="${LABJs }"></script>
	
	<spring:url value="/resources/js/loadWrap.js" var="loadWrapJS" />
	<script type="text/javascript" src="${loadWrapJS }"></script>
	
	<spring:url value="/resources/js/html5/html5shiv.js" var="html5shivJs" />
	<spring:url value="/resources/js/html5/respond.min.js" var="respondJs" />
	<!--[if lt IE 9]>
	<script type="text/javascript" src="${html5shivJs}"></script>
	<script type="text/javascript" src="${respondJs }"></script>
	<![endif]-->
	<script>
	$.wait = function(time) {
		var defer = $.Deferred();
		setTimeout(defer.resolve, time);   
		return defer.promise();
	}
 
	// 재귀함수  // 사용예제는 bomTable.js 에 있음.
	var fnRecursive = function(delayTime, checkFn, actionFn, target){
		if(checkFn(target)){
			return actionFn(target);
		}else{
			$.wait(delayTime).then(function(){
				fnRecursive(delayTime, checkFn, actionFn, target);
			});
		}
	}
	</script>
</head>
<body>
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
            <textarea name="header" rows="2" style="width: 100%;" disabled="disabled"></textarea>
            <textarea name="query" rows="10" style="width: 100%;"></textarea>    
        </div>
		<div style="width: 5rem;position: relative;top: 100px;left: 15px;">
            <button class="button raised" id="run">실행</button>
        </div>
    </div>	
	<div id="resultArea"></div>
<script>
	$(document).ready(function(){
		$("#run").on("click", function(){
			ajax.run({url:"query", method:"insert", data:{query:$("[name=query]").val()}}, function(after, before){
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