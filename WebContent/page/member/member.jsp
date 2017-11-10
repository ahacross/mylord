<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">
	<div class="body">
		<div style="display: flex;">
			<div style="flex: 1;">
				관리 메뉴 : 
				<select name="manageMembers" class="dropdown-menu">
					<option value="partList">대원관리</option>
					<option value="attendance">출석관리</option>
					<option value="birthday">월별 생일</option>
					<option value="dues">회비 관리</option>
				</select>
			</div>
			<div style="width:55px;">
				<button id="addMember" class="button raised bg-blue-500 color-white" title="대원추가" style="padding: 4px 0 4px 15px;"><i class="fa fa-user-plus" aria-hidden="true"></i></button>
			</div>
		</div>
		<div id="spaceArea" style="margin-top: 10px;"></div>
	</div>
</div>
<script>
(function() {
	if(cookie.get("mylordAuth").indexOf("파트장") > -1){
		$("[name=manageMembers]").parent().empty();
	}
	userWindows.memberWindow = loadWindow("page/member/member_window.jsp");
	$("#addMember").on("click", function(){
		userWindows.memberWindow.init({type:"add"});
		windowDialog.show(userWindows.memberWindow, 400, 430);
	});
	
	var getMenuPath = function(selectedMenu){
		var tabMenuMap = {};
		tabMenuMap.partList = "memberList.jsp";
		tabMenuMap.attendance = "attendance.jsp";
		tabMenuMap.birthday = "birthday.jsp";
		tabMenuMap.dues = "dues.jsp";
		
		return "page/member/" + tabMenuMap[selectedMenu];
	}
	
	var changeTabMenu = function(selectedMenu){
		$("#spaceArea").empty().load(getMenuPath(selectedMenu));
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	}

	var focusChange = function(that){
		$("#btnsArea").find(".focus").removeClass("focus");
		that.addClass("focus");
	}
 
	$("[name=manageMembers]").on("change", function(){
		var value = $(this).val();
		if(value === ""){
			return false;
		}else{
			changeTabMenu(value);
		}
	});
	changeTabMenu("partList");
}());
		
	
</script>