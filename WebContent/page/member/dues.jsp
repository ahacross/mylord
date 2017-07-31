<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">	
	<div class="head" style="margin-top:10px;">
		<ul class="tab top">
			<li class="active"><a data-value="s">소프라노</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">베이스</a></li>
			<li><a data-value="e">지휘자 &amp; 반주자</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
		<table id="partTable" class="table classic hover width100">
			<thead>
				<tr>			
					<th style="width:30%;">이름</th>
					<th style="width:20%;">개월 수</th>
					<th style="width:50%;">회비내역 선택</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>

<script>
(function(){ 
	var filepath = "page/member/";
	
	var tableInfos = table.initTable({
		table : $("#partTable"),
		template : function(row, index){
			var trHtml = "";
		    trHtml += '<tr>';
		    trHtml += '<td class="center">'+ row.name +'</td>';
		    trHtml += '<td class="center"><input type="text" class="input" name="dues" value="'+row.dues+'" readonly="readonly" style="width:80%;"> 개월</td>';
		    trHtml += '<td class="center"><input type="range" value="'+row.dues+'" step="1" min="0" max="12" class="input width100"/></td>';
		    trHtml += '</tr>';
		    return trHtml;
		},
		tdCnt : 3,
		rowData : []
	});
	
	var setTab = function(part){
		ajax.run({url:"member", data:{part:part}}, function(after){			
			tableInfos.updateRows(after);
		});
	}
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	setTab($("#partTab").find(".active a").data("value"));

	var saveDues = function(that){
		that.parents("tr").find(":text").val(that.val());
		var	row = tableInfos.getData(that), 
			datas = {};
		datas.url = "member/"+row.member_id;
		datas.method = "update";
		datas.data = {dues : Number(that.val()), member_id:row.member_id};
		ajax.run(datas, function(after, before){
			if(after.cnt > 0){
				console.log("수정 되었습니다.");
			}
		});
	}
	
	tableInfos.table.find("tbody").on("change", "[type=range]", function(e){
		saveDues($(this));
		e.preventDefault();
		e.stopPropagation();
	});
}());
</script>