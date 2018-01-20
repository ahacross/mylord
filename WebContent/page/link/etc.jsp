<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="etc">
	<h3>기타 정보</h3>
	<div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">정관</div>
        <div style="flex: auto;">
        	<a href="/files/mylord/마이로드 정관.pdf" target="_blank">마이로드 정관 PDF (176KB)</a>
        </div>
    </div>
	<br/>
	<br/>
	<div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">회비 계좌 번호</div>
        <div style="flex: auto;" id="account"></div>
    </div>
	<br/>
	<br/>
    <div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">페이스북</div>
        <div style="flex: auto;">
    		<a href="https://www.facebook.com/groups/mylordchoir/" target="_blank">페이스북 마이로드</a>
        </div>
    </div>
    <br/>
	<br/>
	<div id="photoNdrive" style="display:none">
		<div style="display: flex;flex-direction: row;">
	        <div style="flex: auto;">
	    		<a href="https://drive.google.com/open?id=1HNJ2uEDva410uuzwyRE6lo6IH0xqvqaQ" target="_blank">마이로드 포토 및 드라이브 계정 접속 방법</a>
	        </div>
	    </div>
		우선 '임원들'만 로그인 계정으로 접속을 하고 <br/>
		다른 분들은 폴더를 공유해서 업로드 하는 걸로 하려고 합니다.<br/>
		<a href="https://drive.google.com/open?id=1a48EaXb-xQdP3hF5k_A6JxnCkq8rs1FR" target="_blank">폴더 공유 방법(관리자용)</a><br/>
		<a href="https://drive.google.com/open?id=1PlBW2b1_2Vmtc6g_Jz7a-gbOL89i18-D" target="_blank">폴더 업로드 방법(사용자용)</a>
    </div>
    <br/>
	<br/>
    <div style="display: flex;flex-direction: row;">
        <div style="width: 10rem;">고전성가곡집2</div>
        <div style="flex: auto;" >
    		<a href="/choir2/" target="_blank">고전 성가곡집 mp3 파일들</a>
        </div>
    </div>
    <br/>
	<br/>
    <div style="display: flex;flex-direction: column;">
        <div>주를 경배하라(송영) <button id="areaHide" class="button raised bg-blue-500 color-white" style="padding: 0 0 0 8px;"><i class="fa fa-caret-left" aria-hidden="true"></i></button></div>
        <div class="hide" style="flex: auto;">
			<table style="flex:1">
				<tr>
					<td>sop</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%A3%BC%EB%A5%BC%20%EA%B2%BD%EB%B0%B0%ED%95%98%EB%9D%BC/%EC%86%8C%ED%94%84%EB%9D%BC%EB%85%B8.m4a" controls loop="loop" mediagroup="aaa"></audio>
					</td>
				</tr>
				<tr>
					<td>alt</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%A3%BC%EB%A5%BC%20%EA%B2%BD%EB%B0%B0%ED%95%98%EB%9D%BC/%EC%95%8C%ED%86%A0.m4a" controls loop="loop" mediagroup="aaa"></audio>
					</td>
				</tr>
				<tr>
					<td>ten</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%A3%BC%EB%A5%BC%20%EA%B2%BD%EB%B0%B0%ED%95%98%EB%9D%BC/%ED%85%8C%EB%84%88.m4a" controls loop="loop" mediagroup="aaa"></audio>
					</td>
				</tr>
				<tr>
					<td>bas</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%A3%BC%EB%A5%BC%20%EA%B2%BD%EB%B0%B0%ED%95%98%EB%9D%BC/%EB%B2%A0%EC%9D%B4%EC%8A%A4.m4a" controls loop="loop" mediagroup="aaa"></audio>
					</td>
				</tr>
			</table>
        </div>
    </div>
    <br/>
	<br/>
    <div style="display: flex;flex-direction: column;">
        <div>8성부 아멘 <button id="areaHide" class="button raised bg-blue-500 color-white" style="padding: 0 0 0 8px;"><i class="fa fa-caret-left" aria-hidden="true"></i></button></div>
        <div class="hide" style="flex: auto;">
			<table style="flex:1">
				<tr>
					<td>sop1</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EC%86%8C%ED%94%84%EB%9D%BC%EB%85%B81.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>sop2</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EC%86%8C%ED%94%84%EB%9D%BC%EB%85%B82.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>alt1</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EC%95%8C%ED%86%A01.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>alt2</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EC%95%8C%ED%86%A02.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>ten1</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%ED%85%8C%EB%84%881.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>ten2</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%ED%85%8C%EB%84%882.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>bas1</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EB%B2%A0%EC%9D%B4%EC%8A%A41.m4a" controls loop="loop"></audio>
					</td>
				</tr>
				<tr>
					<td>bas2</td>
					<td>
						<audio src="https://ahacross.me/files/mylord/practice/%EC%95%84%EB%A9%988%EC%84%B1%EB%B6%80/%EB%B2%A0%EC%9D%B4%EC%8A%A42.m4a" controls loop="loop"></audio>
					</td>
				</tr>
			</table>
        </div>
    </div>
</div>
<script>
ajax.run({url:"officer", data:{role:"임원(회계)", year:new Date().getFullYear()}}, function(after){
	$("#account").html(after.first().etc);
});

if(cookie.get("mylordAuth").indexOf("임원") > -1){
	$("#practiceManage").show();
	$("#photoNdrive").show();
}

$("#etc.panel").on("click", "#areaHide", function(){
	if( $(this).find(".fa-caret-left").length === 1) {
		$(this).parent().next().show();
		$(this).html('<i class="fa fa-caret-down" aria-hidden="true"></i>');
	}else{
		$(this).parent().next().hide();
		$(this).html('<i class="fa fa-caret-left" aria-hidden="true"></i>');
	}
});
</script>
