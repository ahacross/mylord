<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div>
	<div class="row" id="searchBar" style="padding:15px 0;">
		<div class="col-xs-6 col-md-6" style="background-color: #FFF!important;border:none;">
			<select class="form-control" style="width:30%;" name="search_category_id"></select>
		</div>
		<div class="col-xs-6 col-md-6" style="text-align: right;background-color: #FFF!important;border:none;">
			<button type="button" id="addBbs" class="btn btn-primary">글쓰기</button>
		</div>
	</div>
		
	<div id="bbsFormArea"></div>
	<div class="panel panel-default">
		<div class="panel-body">
		    <div class="table-responsive">
		        <table id="bbsTable" class="table table-hover">  		
					<thead>
						<tr>				
							<th class="center" style="width:10%;">순번</th>
							<th class="center" style="width:20%;">카테고리명</th>
							<th class="center" style="width:40%;">제목</th>
							<th class="center" style="width:10%;">작성자</th>
							<th class="center" style="width:10%;">조회수</th>
							<th class="center" style="width:10%;">등록일</th>
						</tr>				
					</thead>
			  		<tbody></tbody>
				</table>
			</div>
		</div>
	</div>		
</div>
<script>
	var filepath = "page/bbs/";
	
	var setCategoryName = function(){
		setSelectBox({
			url:"bbs/category",
			defaultName:"전체",
			name:"category_name",
			value:"category_id",
			selected: $("[name=search_category_id]").val(),
			target: $("#searchBar [name=search_category_id]") 
		})
	}
	setCategoryName();
	userFns.setCategoryName = setCategoryName;
	
	
	$("#categoryManage").on("click", function(){
		windowDialog.show(userVars.categoryWindow);
	});
	
	$("#addBbs").on("click", function(){
		$("#searchBar").hide();
		$("#bbsFormArea")
			.empty()
			.load(filepath+"bbsForm.jsp");
	});
	
	var bbsTableInfos = table.initTable({
		table : $("#bbsTable"),
		template : function(row, index){
			var trHtml = "";
		    trHtml += '<tr>';
		    trHtml += '<td class="center">'+index+'</td>';
		    trHtml += '<td class="center">'+row.category_names+'</td>';
		    trHtml += '<td class="link" id="detail">'+row.title+'</td>';
		    trHtml += '<td class="center">'+ row.regi_member_name +'</td>';
		    trHtml += '<td class="center">'+ row.count +'</td>';
		    trHtml += '<td class="center">'+row.regi_date+'</td>';
		    trHtml += '</tr>';
		    return trHtml;
		},
		tdCnt : 6,
		rowData : []
	});

	var reloadTable = function(bbs_id){
		var datas = {url:"bbs"},
		search_category_id = $("[name=search_category_id]").val();

		console.log(bbs_id + " : " + typeof bbs_id);
		if(typeof bbs_id === "number"){
			datas.data = {bbs_id: bbs_id};	
		}
		
		if(search_category_id !== ""){
			if(datas.data){			
				datas.data.search_category_id = search_category_id;
			}else{
				datas.data = {search_category_id : search_category_id};
			}	
		}
		
		ajax.run(datas, function(after, before){
			bbsTableInfos.updateRows(after.list);
		});
	}
	reloadTable();
	userFns.reloadBbsList = reloadTable;
	
	$("#searchBar [name=search_category_id]").on("change", reloadTable);
	
	bbsTableInfos.table.find("tbody").on("click", "#detail", function(){
		var row = bbsTableInfos.getData($(this));
		
		userVars.detail_bbs_id = row.bbs_id;
		ajax.run({url:"bbs/"+row.bbs_id+"/count",method:"update", data:{bbs_id:row.bbs_id, count:1, u_member_id: cookie.getMylord("member_id")}}, function(after, before){
			bbsTableInfos.updateRows(after.cnt);
		});
		
		$("#bbsFormArea")
			.empty()
			.load(filepath+"bbsDetail.jsp");
		$("#searchBar").hide();
	});
	
	
</script>
