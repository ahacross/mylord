var tuiGrid = (function(tuiGrid, $, undefined){
	
	tuiGrid.grids = {};
	
	var addGridMethods = function(grid) {
		grid.saveDatas = function(datas){
			grid.datas = deepCopy(datas);
		}
	}
	
	tuiGrid.makeGrid = function(params) {
		const gridId = params.gridId || params.el.selector.split(" ").last().substr(1);
		
		let grid = tuiGrid.grids[gridId];
		if(grid) {
			grid.destroy();
		}

		var gridOptions = {
		    el: params.el,
		    data: params.data || [],
		    bodyHeight:window.innerHeight - 130,	    
		    columns: params.columns
		};
		
		if(params.rowHeaders) {
			gridOptions.rowHeaders = ['rowNum']; 
		}
		
		grid = new tui.Grid(gridOptions);
		tuiGrid.grids[gridId] = grid;
		addGridMethods(grid);
		
		setTimeout(function(){
			grid.refreshLayout();	
		}, 500);
		
		return grid;
	}
	
	tuiGrid.getGrid = function(name){
		return tuiGrid.grids[name];
	}
	
	return tuiGrid;
}(window.tuiGrid || {}, jQuery));
