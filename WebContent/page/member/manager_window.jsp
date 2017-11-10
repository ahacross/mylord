<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="managerWindow" class="window jui">
	<div class="head hide">
		<div class="left">마이로드 임원 추가</div>
	</div>
	<div class="body">		
		<table id="managerTable" class="width100">
			<tr>
				<td class="thB" style="width:25%;">이름</td>
				<td><input type="text" class="input width100" name="name"/></td>
			</tr>
			<tr>
				<td class="thB">역할</td>
				<td>
					<select  class="input width100" name="role">
						<option value="">선택</option>
						<option value="팀장">팀장</option>
						<option value="임원">임원</option>
						<option value="구역장">구역장</option>
						<option value="파트장">파트장</option>
						<option value="악보복사">악보복사</option>
						<option value="악보스캔">악보스캔</option>
						<option value="간식준비">간식준비</option>
					</select>
				</td>			
			</tr>
			<tr>
				<td class="thB">임기시작일</td>
				<td><input type="date" class="input width100" name="term_range_s" /></td>
			</tr>
			<tr>
				<td class="thB">임기종료일</td>
				<td><input type="date" class="input width100" name="term_range_e" /></td>				
			</tr>
		</table>
	</div>
	<div class="foot hide">
		<a id="save" class="focus btn">임원 추가</a>	
        <a id="close" class="btn">닫기</a>
	</div>
</div>

<script>
setTimeout(function(){ 
	var targetWindow = userVars.managerWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	var close = function(){
		targetWindow.userVars = {};
		targetWindow.close();
	}
	
	Footer.find("#close").on("click", close);
	//Footer.find("#save").on("click", areaInit);
}, 1000);
</script>