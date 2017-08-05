<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">
	부른 음원 목록 
	<div id="gridHistory"></div>
</div>
<script>

console.log(window.innerHeight);

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
			name:"singed_date"
		},{
			title:"제목",
			name:"title"
		},{
			title:"부른 영상",
			name:"link",
			formatter:function(value) {
				return (value === undefined)?'':'<a href="'+value+'" target="_blank">'+value+'</a>';
			}
		/* },{
			title:"출처",
			name:"source"
		},{
			title:"악보자료",
			name:"scanning"
		},{
			title:"연습",
			name:"practice"
		},{
			title:"절기",
			name:"etc" */
		}
	];
}

var gridHistory;
ajax.run({url:"history"}, function(after){
	gridHistory = makeGrid({el:$('#gridHistory'), data:after, columns:getColumns()});	
});


setTimeout(function(){
	gridHistory.refreshLayout();	
}, 500);


</script>