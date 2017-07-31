<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="memberWindow" class="window jui">
	<div class="head hide">
		<div class="left">성가대원 추가</div>
	</div>
	<div class="body">		
		<table id="memberTable" class="width100">
			<tr>
				<td class="thB" style="width:25%;">이름</td>
				<td><input type="text" class="input width100" name="name"/></td>
			</tr>
			<tr>
				<td class="thB">파트</td>
				<td>
					<select  class="input width100" name="part">
						<option value="s">소프라노</option>
						<option value="a">알토</option>
						<option value="t">테너</option>
						<option value="b">베이스</option>
						<option value="반주자">반주자</option>
						<option value="지휘자">지휘자</option>
						<option value="목사님">목사님</option>
					</select>
				</td>			
			</tr>
			<tr>
				<td class="thB">폰 번호</td>
				<td><input type="text"  class="input width100" name="phone" placeholder="01011112222" maxlength="13"/></td>
			</tr>
			<tr>
				<td class="thB">생일</td>
				<td><input type="date" class="input width100" name="birthday" /></td>
			</tr>
			<tr>
				<td class="thB">E-mail</td>
				<td><input type="text" class="input width100" name="email" placeholder="aaa@naver.com" /></td>				
			</tr>
			<tr>
				<td class="thB">상태</td>
				<td>
					<select name="status" class="input width100">
						<option value="Y">활동중</option>
						<option value="R">장기결석</option>
						<option value="N">기타(탈퇴)</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="thB">성가대 등록일</td>
				<td><input type="date" class="input width100" name="regi_date"/></td>				
			</tr>
			<tr>
				<td class="thB">비고</td>
				<td>
					<textarea rows="5" style="width:100%;"  class="input" name="comment"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<div class="foot hide">
		<button type="button" id="save" class="btn btn-primary">저장</button>
		<button type="button" id="close" class="btn btn-default">닫기</button>
		<!-- <button type="button" id="delete" class="btn btn-default">삭제</button> -->
	</div>
</div>

<script>
$(document).ready(function(){
	var targetWindow = userWindows.memberWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	windowDialog.setSize(targetWindow, 400, 430);
	
	Content.on("blur", "[name=phone]", function(){
		var value = $(this).val();
		if(value.split("-").length > 0){
		}else if(!/^[\d]{10,11}$/.test(value) || !/^01/.test(value)){
			msg.alert("휴대폰 번호 양식에 맞지 않습니다.");
			value = "";
		}else{
			value = value.toPhone();
		}
		$(this).val(value);
	});
	
	targetWindow.init = function(infos){
		targetWindow.userVars = infos;
		
		initAdd(Content);
		if(infos.type==="add"){
			Content.find("[name=part]").val("s");
			Content.find("[name=status]").val("Y");			
		}else if(infos.type === "mod"){
			if(infos.row.birthday && infos.row.birthday.length === 8){
				infos.row.birthday = infos.row.birthday.yyyymmdd("-");	
			}
			
			if(infos.row.regi_date && infos.row.regi_date.length === 8){
				infos.row.regi_date = infos.row.regi_date.yyyymmdd("-");	
			}
			
			initMod(Content, infos.row);
		}
	}
	
	console.log(Content);
	var save = function(){
		//if(Content.find("[name=phone]").){
			//Content.find("[name=phone]").blur();
		//}
		var fields = Content.find("#memberTable").find("[type=date], select, :text, textarea"),
			datas = {},
			ajaxData = {},
			tempField;
		
		for(var i=0, n=fields.length; i<n; i++){
			tempField = fields.eq(i);
			datas[tempField.attr("name")] = tempField.val();
		}
		
		if(targetWindow.userVars.type === "add"){
			ajaxData.url = "member";
			ajaxData.method = "insert";
		}else{
			datas.member_id = targetWindow.userVars.row.member_id;
			ajaxData.url = "member/"+ datas.member_id;
			ajaxData.method = "update";
		}
		if(datas.birthday){
			datas.birthday = datas.birthday.split("-").join("");
		}
		if(datas.regi_date){
			datas.regi_date = datas.regi_date.split("-").join("");
		}
		ajaxData.data = datas;
		
		ajax.run(ajaxData, function(rtnValue){
			if(rtnValue.cnt > 0){
				var text = "";
				if(rtnValue.type === "insert"){
					text = "추가";
				}else if(rtnValue.type === "update"){
					text = "수정";
				}
				reloadTab(datas.part);
				msg.alert(text+" 되었습니다.");
				Footer.find("#close").click();
			}
		});
	}
	
	var reloadTab = function(part){
		if(userVars.showMenu === "partList"){
			$("#partTab").find("[data-value="+part+"]").parent().click();
		}
	}
	
	Footer.on("click", "#close", function(){
		targetWindow.userVars = {};
		targetWindow.close();
	});
	
	Footer.on("click", "#save", save);
	Footer.on("click", "#delete", function(){
		ajax.run({url:"member/"+targetWindow.userVars.row.member_id, method:"delete"}, function(rtnValue){
			if(rtnValue.type === "delete"){
				msg.alert("삭제되었습니다.");
				reloadTab($("#partTab .active a").data("value"));
				Footer.find("#close").click();
			}
		});
	});
});
</script>