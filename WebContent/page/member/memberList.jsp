<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">
	<div class="head">
		<ul class="tab top">
			<li><a data-value="all">전체</a></li>
			<li class="active"><a data-value="s">소프라노</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">베이스</a></li>
			<li><a data-value="e">지휘자 &amp; 반주자</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
		<div style="margin-bottom: 5px;">
			<div style="display:inline;">상태 : </div>
			<div style="display:inline;" id="statusArea"></div>
		</div>
		<table id="partTable" class="table classic hover width100">
			<thead>
				<tr>			
					<th style="width:10%;">이름</th>
					<th style="width:10%;">폰번호</th>
					<th style="width:10%;">생일</th>
					<th style="width:25%;">이메일</th>
					<th style="width:10%;">상태</th>
					<th style="width:20%;">최근 출석일</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="enrollment"></div>
	</div>
</div>
<script>
(function(){
	var getAge = function(birthday){
		var age = '';
		if(birthday){
			age = birthday.yyyymmdd("-") + " / " + (new Date().getFullYear() - Number(birthday.yyyymmdd("-").split("-")[0]) + 1) + "세";	
		}
		
		return age;		
	}
	userVars.statusMap = {};
	userVars.statusMap["Y"] = "활동중";
	userVars.statusMap["R"] = "장기결석";
	userVars.statusMap["N"] = "회원탈퇴";
	
	var statusHtml = '';
	_.keys(userVars.statusMap).forEach(function(item){
		statusHtml += '<label style="cursor:pointer;"><input type="checkbox" checked="checked" value="'+item+'"> '+userVars.statusMap[item]+'</label> &nbsp;';
	});
	$("#statusArea").html(statusHtml).on("click", ":checkbox", function(){
		setTab($("#partTab").find(".active a").data("value"));
	});
	
	
	var makeLastAttend = function(last_attend){
		if(last_attend !== ""){
			last_attend = new Date(last_attend.yyyymmdd("-")).format('yyyy년 MM월 dd일');
		}
		return last_attend;
	}
	
	var tableInfos = table.initTable({
		table : $("#partTable"),
		template : function(row, index){
			var trHtml = "";
		    trHtml += '<tr>';
		    trHtml += '<td class="center link" id="mod">'+ row.name +'</td>';
		    trHtml += '<td class="center">'+ (row.phone||"") +'</td>';
		    trHtml += '<td class="center">'+ getAge(row.birthday) +'</td>';
		    trHtml += '<td class="center">'+ (row.email||"") +'</td>';
		    trHtml += '<td class="center">'+ userVars.statusMap[row.status] +'</td>';
		    trHtml += '<td class="center">'+ makeLastAttend(row.last_attend||"") +'</td>';
		    trHtml += '</tr>';
		    return trHtml;
		},
		tdCnt : 6,
		rowData : []
	});
	
	var setTab = function(part){
		ajax.run({url:"member", data:{part:part}}, function(after, before){
			var statusArr = [],
				list;
			
			$("#statusArea").find(":checkbox:checked").each(function(item){
				statusArr.push($(this).val());
			});
			
			list = after.filter(function(item){
				if(_.indexOf(statusArr, item.status) > -1){
					return item;
				}
			});

			if(part === "all"){
				list.sort(compare.part("part"));
			}
			
			tableInfos.updateRows(list);
			$("#enrollment").text("파트별 재적 수 : " + list.length);
		});
	}
	userFns.setTab = setTab;
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	tableInfos.table.find("tbody").on("click", "#mod", function(){
		userVars.memberWindow.init({type:"mod", row: tableInfos.getData($(this))});
		windowDialog.show(userVars.memberWindow, 400, 430);
	});
	
	setTab($("#partTab").find(".active a").data("value"));
}());
</script>