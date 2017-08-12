<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<a href="http://ahacross.woobi.co.kr/choir/" target="_blank">마이로드 연습실</a>
	
	<div id="practiceManage" class="hide">
		<a href="http://ahacross.woobi.co.kr/choir/song_manage.html" target="_blank">마이로드 연습실 관리</a>
	</div>
</div>
<script>
if(cookie.get("mylordAuth").indexOf("임원") > -1){
	$("#practiceManage").show();
}
</script>
