<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="categoryWindow" class="window jui">
	<div class="head hide">
		<div class="left">카테고리 관리</div>
	</div>
	<div class="body" style="padding:10px">
		<div class="form-group input-group">
		    <input type="text" class="form-control" placeholder="카테고리 추가." name="category_name" />
		    <span class="input-group-btn">
			    <button class="btn btn-primary" type="button" id="categoryAdd">추가</button>
			</span>
		</div>
		<div class="panel panel-default">
			<div class="panel-body">
			    <div class="table-responsive">
			        <table id="categoryTable" class="table table-hover">
						<thead>
							<tr>
				  				<th style="width:auto">카테고리 이름</th>	  				
				  				<th style="width:20%;">삭제</th>
			  				</tr>				
						</thead>    
						<tbody></tbody>
					</table>
					<div class="pager hide"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="foot hide">
        <button type="button" id="close" class="btn btn-primary">닫기</button>
	</div>
</div>
<script>
$(document).ready(function(){
	var targetWindow = userWindows.categoryWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);

	windowDialog.setSize(targetWindow, 400, 500);
	
	var saveCategory = function(){
		var category_name = Content.find("[name=category_name]").val();
		if(category_name === ""){
			msg.alert("카테고리 이름이 비어 있습니다.");
			return false;
		}
		
		var datas = {
			url:"bbs/category", 
			method:"insert", 
			data:{
				category_name: Content.find("[name=category_name]").val()
			}
		};
		
		ajax.run(datas, function(after, before){
			if(after.cnt > 0){
				msg.alert("추가 되었습니다.");
				reloadTable();
				Content.find("[name=category_name]").val("");
			}			
		});
	}
	Content.find("#categoryAdd").on("click", saveCategory);
	Content.find("[name=category_name]").on("keydown", function(e){
		if(e.keyCode === 13){
			saveCategory();
		}
	})
	
	var categoryTableTableInfos = table.initTable({
		table : Content.find("#categoryTable"),
		template : function(row){
			var trHtml = "";
		    trHtml += '<tr>';
		    trHtml += '<td class="center">'+ row.category_name +'</td>';
		    trHtml += '<td class="center"><a class="btn" id="deleteCategory">삭제</a></td>';
		    trHtml += '</tr>';
		    return trHtml;
		},
		tdCnt : 2,
		rowData : []
	});
	
	var reloadTable = function(){
		var datas = {url:"bbs/category"};
		ajax.run(datas, function(after, before){
			categoryTableTableInfos.updateRows(after);
		});
	}
	reloadTable();
	
	categoryTableTableInfos.table.find("tbody").on("click", "#deleteCategory", function(){
		var row = categoryTableTableInfos.getData($(this));
		
		var datas = {
			url:"bbs/category",
			method : "delete",
			data : {
				category_id :row.category_id 
			}
		};
		
		msg.confirm("삭제하시겠습니까?", function(){
			ajax.run(datas, function(after, before){
				if(after.cnt > 0){
					msg.alert("삭제 되었습니다.");
				}			
				reloadTable();
			});	
		});
	});
		
		
	Footer.on("click", "#close", function(){
		targetWindow.userVars = {};
		targetWindow.close();
		if(window.userFns && userFns.setCategoryName){
			userFns.setCategoryName();	
		}
	});	
});
</script>