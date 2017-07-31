<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">
	<div class="body">
		<div  id="btnsArea">
			<a class="btn" id="addMember">대원추가</a>&nbsp;&nbsp;&nbsp;
			<a class="btn" id="partList">파트별 대원관리</a>&nbsp;&nbsp;&nbsp;
			<a class="btn" id="partCheck_attendance">파트별 출석</a>&nbsp;&nbsp;&nbsp;
			<a class="btn" id="birthdayBtn">생일 월별</a>&nbsp;&nbsp;&nbsp;
			<a class="btn" id="duesBtn">회비 현황</a>&nbsp;&nbsp;&nbsp;
			<a class="btn" id="statsBtn">출석 통계</a>&nbsp;&nbsp;&nbsp;
		</div>
		<div id="spaceArea" style="margin-top: 10px;"></div>
		
	</div>
</div>
<script>
	var filepath = "page/member/";
	userVars.memberWindow = loadWindow(filepath + "member_window.jsp");
	
	$("#addMember").on("click", function(){
		userVars.memberWindow.init({type:"add"});
		windowDialog.show(userVars.memberWindow, 400, 430);
	});
	
	$("#partList").on("click", function(){
		$("#spaceArea")
			.empty()
			.load(filepath+"memberList.jsp");
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	});
	
	$("#partCheck_attendance").on("click", function(){
		$("#spaceArea")
			.empty()
			.load(filepath+"attendance.jsp");
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	});
	
	$("#birthdayBtn").on("click", function(){
		$("#spaceArea")
			.empty()
			.load(filepath+"birthday.jsp");
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	});
		
	$("#duesBtn").on("click", function(){
		$("#spaceArea")
			.empty()
			.load(filepath+"dues.jsp");
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	});
	
	$("#statsBtn").on("click", function(){
		$("#spaceArea")
			.empty()
			.load(filepath+"stats.jsp");
		
		userVars.showMenu = $(this).attr("id");
		focusChange($(this));
	});
		
	
	var focusChange = function(that){
		$("#btnsArea").find(".focus").removeClass("focus");
		that.addClass("focus");
	}

		
	
</script>