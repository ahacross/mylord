<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<h3>기타 정보</h3>
	<div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">회비 계좌 번호</div>
        <div style="flex: auto;" id="account"></div>
    </div>
	<br/>
	<br/>    
    <div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">페이스북</div>
        <div style="flex: auto;" id="account">
    		<a href="https://www.facebook.com/groups/mylordchoir/" target="_blank">페이스북 마이로드</a>    
        </div>
    </div>
    <br/>
	<br/>
    <div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">연습실</div>
        <div style="flex: auto;" id="account">
    		<a href="http://ahacross.woobi.co.kr/choir/" target="_blank">마이로드 연습실</a>
	
			<div id="practiceManage" class="hide">
				<a href="http://ahacross.woobi.co.kr/choir/song_manage.html" target="_blank">마이로드 연습실 관리</a>
			</div>    
        </div>
    </div>
</div>
<script>
ajax.run({url:"officer", data:{role:"임원(회계)"}}, function(after){
	$("#account").html(after.first().etc);
});

if(cookie.get("mylordAuth").indexOf("임원") > -1){
	$("#practiceManage").show();
}
</script>
