<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="officerWindow" class="window">
	<div class="head hide">
		<div class="left">임원 등록</div>
	</div>
	<div class="body">		
		<table id="officerTable" style="width:98%;">
			<tr>
				<td class="thB" style="width:25%;">임기년도</td>
				<td>
					<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
                        <input type="text" id="datepicker-input" name="year" aria-label="Date-Time">
                        <span class="tui-ico-date"></span>
                    </div>
                    <div class="datepicker-cell" id="datepicker-year"></div>
				</td>
			</tr>
			<tr>
				<td class="thB">이름</td>
				<td>
					<input type="text" class="text-input noForm" name="name" style="width:100px;"/>
					<button id="searchName" class="button raised window">검색</button>
					<select name="member_id" class="dropdown-menu hide"></select>
				</td>			
			</tr>
			<tr>
				<td class="thB">역할</td>
				<td>
					<select class="dropdown-menu" name="role"></select>
					<input type="text" class="text-input noForm" name="addRoleText" style="width:100px;height: 21px;"/>
					<button id="addRole" class="button raised window">추가</button>
				</td>
			</tr>
			<tr>
				<td class="thB">임기 기간</td>
				<td>
					<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
			            <input id="startpicker-input" name="s_date" type="text" aria-label="Date">
			            <span class="tui-ico-date"></span>
			        </div>
			        <span style="position: relative;top: 8px;">to</span>
			        <div class="tui-datepicker-input tui-datetime-input tui-has-focus">
			            <input id="endpicker-input" name="e_date" type="text" aria-label="Date">
			            <span class="tui-ico-date"></span>
			        </div>
				</td>
			</tr>			
			<tr>
				<td class="thB">etc</td>
				<td><textarea class="text-input width100" rows="5" name="etc"></textarea></td>
			</tr>
		</table>
	</div>
	<div class="foot hide">		
        <button id="save" class="button raised bg-blue-500 color-white">저장</button>
        <button id="delete" class="button raised" style="margin:0 5px;">삭제</button>
        <button id="close" class="button raised">닫기</button>
	</div>
</div>

<script>
(function(){ 
	var targetWindow = userWindows.officerWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	let close = function(){
		targetWindow.userVars.picker.destroy();
		targetWindow.userVars = {};
		targetWindow.close();
	}
	
	
	let year = new tui.DatePicker('#datepicker-year', {
    	date: new Date(),
        language: 'ko',
        type: 'year',
        input: {
            element: '#datepicker-input',
            format: 'yyyy'
		}
    });
	
	const getRangePicker = function(sDate, eDate){
		const today = new Date();
		const picker = tui.DatePicker.createRangePicker({
			language: "ko",
			format: 'yyyy-MM-dd',
			startpicker: {
				date: sDate?new Date(sDate):today,
				input: '#startpicker-input',
				container: '#startpicker-container'
			},
			endpicker: {
				date: eDate?new Date(eDate):(sDate?new Date(sDate):today),
				input: '#endpicker-input',
				container: '#endpicker-container'
			}
		});
		targetWindow.userVars.picker = picker;
	}
	
	Content.on("click", "#searchName", function(){
		const name = Content.find("[name=name]").val();
		ajax.run({url:"member", data:{name:name, status:'Y'}}, function(datas){
			if(datas.length > 0){
				let optionsHtml = '<option value="">선택</option>';
				
				datas.forEach(function(data){
					optionsHtml += '<option value="'+data.member_id+'">'+ (data.name + ' ('+userVars.partMap[data.part]+')' ) +'</option>';	
				});
				Content.find("[name=member_id]").html(optionsHtml).show();
			}
		});
	});
	
	ajax.run({url:"officer"}, function(datas){
		let options = '<option value="">전체</option>';
		let values = _.sortBy(_.uniq(datas.map(data => data.role)));
		
		values.forEach(function(value){
			options += '<option value="'+value+'">'+value+'</option>';	
		});
		
		Content.find("[name=role]").html(options);
	});
	
	Content.on("click", "#addRole", function(){
		let value = Content.find("[name=addRoleText]").val();
		if(value !== "") {
			Content.find("[name=role]").append('<option value="'+value+'">'+value+'</option>');	
		}
	});
	
	targetWindow.init = function(params) {
		Content.find("[name=member_id]").empty().hide();
		let title = "임원 ";
		if(params.type === "update"){
			console.log(params.row);
			if(params.row.s_date) {
				params.row.s_date = params.row.s_date.yyyymmdd("-");	
			}
			if(params.row.e_date) {
				params.row.e_date = params.row.e_date.yyyymmdd("-");	
			}
			
			getRangePicker(params.row.s_date, params.row.e_date);			
			Content.find("[name=year],[name=name],[name=role]").attr("disabled", true);
			Content.find("#searchName, #addRole, [name=addRoleText]").hide();
			
			initMod(Content.find("#officerTable"), params.row);
			title += "수정";
		}else{
			getRangePicker();
			Content.find("[name=year],[name=name],[name=role]").attr("disabled", false);
			Content.find("#searchName, #addRole, [name=addRoleText]").show();
			title += "등록";
		}
		windowDialog.setTitle(targetWindow, title);
		targetWindow.userVars.params = params;
	}
	
	
	Footer.on("click", "#save", function(){
		let datas = $.extend(targetWindow.userVars.params.row || {}, makeFormDatas(Content.find("#officerTable").find("select, :text, [type=date], textarea").not(".noForm"))); 
		datas.s_date = datas.s_date.split("-").join("");
		datas.e_date = datas.e_date.split("-").join("");
		
		let url = "officer";
		if(targetWindow.userVars.params.type === "update") {
			url += ("/"+cookie.get("mylordId"));
		}
		
		ajax.run({url:url, method: targetWindow.userVars.params.type, data:datas}, function(result){
			if(result.cnt > 0) {
				msg.alert("저장 하였습니다.");
				userFns.setGridData();
				Footer.find("#close").click();
			}
		});
	});
	Footer.on("click", "#delete", function(){
		let datas = targetWindow.userVars.params.row; 
		
		ajax.run({url: "officer/"+cookie.get("mylordId"), method: "delete", data:datas}, function(result){
			if(result.cnt > 0) {
				msg.alert("삭제 하였습니다.");
				userFns.setGridData();
				Footer.find("#close").click();
			}
		});
	});
	Footer.on("click", "#close", close);	
}());
</script>