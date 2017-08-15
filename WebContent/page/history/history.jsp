<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
			<div class="text-input-container card">
				<i class="icon-search text-input-icon"></i>
				<input type="text" name="search" class="text-input" placeholder="음원 검색"/>
			</div>
        </div>
		<div style="width: 8.5rem;">
			<button id="addHistory" class="fab bg-blue-500 color-white small hide" style="width: 1.1em;height: 1.1em;line-height: 20px;padding: .1em .05em;"><i class="icon-add"></i></button>
			<span id="switchTxt">심플 필드</span>
            <div class="switch">
				<input type="checkbox" id="switch"/>
				<label for="switch"></label>
			</div>
        </div>
    </div> 
	<div id="gridHistory" style="margin-top:5px;"></div>
</div>
<script>
(function(){
	if(cookie.get("mylordAuth").indexOf("임원") > -1){
		// load 하는거
		userWindows.historyWindow = loadWindow("page/history/history_window.jsp");
		$("#addHistory").show();
	}
	
	if(Responsive.device !== "desktop"){
		$("[name=search]").css("width", "150px");
		
	}

	const makeGrid = function(params) {
		var grid = new tui.Grid({
		    el: params.el,
		    data: params.data,
		    bodyHeight:window.innerHeight -125,	    
		    columns: params.columns
		});
		return grid;
	}

	const getAddColumns = function(){
		return [
			{			
				title:"출처",
				name:"source"
			},{
				title:"악보자료",
				name:"scanning",
				formatter:function(value) {
					return (value === undefined)?'':'<a href="'+value+'" target="_blank">'+value+'</a>';
				}
			
			},{
				title:"절기",
				name:"etc"
			}
		];
	}

	const getSimpleColumns = function(){
		return [
			{
				title:"부른 날짜",
				name:"singed_date",
				width: 90
			},{
				title:"제목",
				name:"title"				
			},{
				title:"부른 영상",
				name:"link",
				formatter:function(value) {
					return (value === undefined)?'':'<a href="'+value+'" target="_blank">'+value+'</a>';
				}
			},{
				title:"연습",
				name:"practice",
				width:30,
				formatter:function(value) {
					return (value === undefined)?'':'<a href="http://ahacross.me/practice.html?url='+value+'" target="_blank">연습</a>'; 
				}
			}
		];
	}

	var historyGrid,
		historyGridData;
	
	var setGrid = function(){
		ajax.run({url:"history"}, function(after){
			const txtDom = $("#switchTxt");
			let columns;
			if($("#switch").prop("checked")){
				txtDom.text("상세필드");
				columns = getSimpleColumns().concat(getAddColumns());
			}else{
				txtDom.text("간단필드");
				columns = getSimpleColumns();
			}
			
			if(historyGrid) {
				historyGrid.destroy();
			}
			
			if(cookie.get("mylordAuth").indexOf("임원") > -1){
				columns[1].formatter = function(value) {
					return '<a class="pointer">'+value+'</a>';
				} 
			}
						
			historyGrid = makeGrid({el:$('#gridHistory'), data: after, columns: columns});
			historyGridData = deepCopy(historyGrid.getRows());
			
			historyGrid.on('click', function(e) {
				if(cookie.get("mylordAuth").indexOf("임원") > -1){
					if(e.columnName === "title") {
						historyWindowOpen("update", e.instance.getRow(e.rowKey));
					}
				}
		    });
			
		});
	}
	setGrid();
	userFns.setGridHistory = setGrid;
	
	$("#switch").on("change", setGrid);

	setTimeout(function(){
		historyGrid.refreshLayout();	
	}, 500);

	const historyWindowOpen = function(type, row) {
		const targetWindow = userWindows.historyWindow;
		let params = {type:type};
		
		if(row) {
			params.row = row;
		}
		targetWindow.init(params);
		windowDialog.show(targetWindow, 400, 430);
	}
	
	$("#addHistory").on("click", function(){
		historyWindowOpen("insert");
	});
	
	$("[name=search]").on("keyup", function(event){
		if(event.keyCode === 13){
			const search = $(this).val().trim();
			let rows = historyGridData.filter(row => (row.title+"").indexOf(search) > -1);
			historyGrid.resetData(rows);
		}		
	});
	
}());



</script>