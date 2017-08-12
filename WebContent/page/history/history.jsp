<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
			부른 음원 목록
        </div>
		<div style="width: 7rem;">
			<span id="switchTxt">심플 필드</span>
            <div class="switch">
				<input type="checkbox" id="switch"/>
				<label for="switch"></label>
			</div>
        </div>
    </div> 
	<div id="gridHistory"></div>
</div>
<script>

if(cookie.get("mylordAuth").indexOf("임원") > -1){
	// load 하는거
	userWindows.historyWindow = loadWindow("page/link/history_window.jsp");
}


const makeGrid = function(params) {
	var grid = new tui.Grid({
	    el: params.el,
	    data: params.data,
	    bodyHeight:window.innerHeight -110,	    
	    columns: params.columns
	});
	return grid;
}

const getColumns = function(){
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
			title:"출처",
			name:"source"
		},{
			title:"악보자료",
			name:"scanning",
			formatter:function(value) {
				return (value === undefined)?'':'<a href="'+value+'" target="_blank">'+value+'</a>';
			}
		},{
			title:"연습",
			name:"practice"
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
		}
	];
}

var gridHistory;

var setGrid = function(){
	ajax.run({url:"history"}, function(after){
		const txtDom = $("#switchTxt");
		let columns;
		if($("#switch").prop("checked")){
			txtDom.text("상세필드");
			columns = getColumns();
		}else{
			txtDom.text("간단필드");
			columns = getSimpleColumns();
		}
		
		if(gridHistory) {
			gridHistory.destroy();
		}
		gridHistory = makeGrid({el:$('#gridHistory'), data:after, columns: columns});	
	});
}
setGrid();

$("#switch").on("change", setGrid);

setTimeout(function(){
	gridHistory.refreshLayout();	
}, 500);


</script>