windowDialog = (function(windowDialog, $, undefined){
	windowDialog.getNewWindowDialogNum = function(){
		var nameNum = 0;
		for(var name in alertify){
			if(name.indexOf("windowDialog") > -1){
				nameNum++;
			}
		}
		return nameNum + 1;
	} 
	
	var newWindowDialog = function(windowDialog, options){
		var defaultOptions = {
			transition:'fade',
            maximizable: false,
            closable: false,
            resizable: true,
            padding: false,
            pinnable : false,
            closableByDimmer: false
		};
		$.extend(defaultOptions, options);
		
		alertify[windowDialog] || alertify.dialog(windowDialog,function(){
		    return {
		        main:function(content){
		            this.setContent(content);
		        },
		        setup:function(){
		            return {
		                options: defaultOptions
		            };
		        },
		        settings:{
		        }
		    };
		});	
	}
	
	windowDialog.newWindow = function(target, options){
		var windowDialogName = 'windowDialog' + windowDialog.getNewWindowDialogNum();
		newWindowDialog(windowDialogName, options);
		var targetWindow = alertify[windowDialogName](target.show()[0]).close();
		targetWindow.userVars = {};
		targetWindow.options = options;	
		targetWindow.name = windowDialogName;
		targetWindow.displayToggle = function(){
			$(this.elements.dialog).css("display", ($(this.elements.dialog).css("display") === "none")?"block":"none");
		}		
		targetWindow.modalTrue = function(){			
			this.set('modal', true);
		}
		targetWindow.modalFalse = function(){
			this.set('modal', false);
		}
		targetWindow.resizableFalse = function(){
			this.set('resizable', false);
		}
		
		targetWindow.show2 = function(){
			console.log(this);
			this.resizeTo(this.offset.width, this.offset.height);
			this.show();
		}
		
		return targetWindow;
	};
	
	windowDialog.show = function(targetWindow, width, height, isMulti, windowName){
		//var targetWindow = alertify["windowDialog"+(windowDialog.getNewWindowDialogNum() - 1)]();
		//if(isMulti){
		if(false){
			var url = $(userVars.resourceWindow.elements.root).data("url");
			
			var multiWindow = loadWindow(url, targetWindow.options);			
			multiWindow.userVars = JSON.parse(JSON.stringify(targetWindow.userVars));
			multiWindow.isMulti = true;
			targetWindow = multiWindow;
		}

		targetWindow.resizeTo(width, height);
		targetWindow.show();
		
		if(width && height){
			windowDialog.setSize(targetWindow, width, height);
		}
		
		targetWindow.offset = {width:targetWindow.elements.dialog.offsetWidth, height:targetWindow.elements.dialog.offsetHeight};
		targetWindow.resizableFalse();
		return targetWindow;
	};
	
	windowDialog.moveToCenter = function(targetWindow, width, height){
		var top		= $(document).scrollTop() + Number(height),
			left	= Math.floor(window.innerWidth / 2) - Math.floor(Number(width) / 2);
		targetWindow.moveTo(left, top);
	};
	
	windowDialog.setSize = function(targetWindow, width, height){
		targetWindow.resizeTo(width, height);	
		targetWindow.offset = {width:width, height:height};
		return targetWindow;
	};
	
	windowDialog.setTitle = function(targetWindow, title){
		$(targetWindow.elements.header).text(title);
		return targetWindow;
	};
	
	windowDialog.getContent = function(targetWindow){
		return $(targetWindow.elements.content);
	}
	
	windowDialog.getFooter = function(targetWindow){
		return $(targetWindow.elements.footer);
	}
	
	windowDialog.getContentHeight = function(targetWindow){
		return Number($(targetWindow.elements.content).css("height").split("px")[0]);
	}
	
	windowDialog.close = function(targetWindow){
		if(targetWindow.isMulti){
			targetWindow.destroy();		
		}
		targetWindow.userVars = {};
		targetWindow.close();
	};
	
	return windowDialog;
}(window.windowDialog || {}, jQuery));
	
	
var loadUrlPromise = function(target, url){
	var defer = $.Deferred();
	setTimeout(function(){
		target.load(url, function(html) {
	        defer.resolve(html);
	    });
	}, 0);
	return defer.promise();
}

var loadWindowMulti = function(html, options){
	var areaId = "windowAreaDialog"+windowDialog.getNewWindowDialogNum();
	$(".content:eq(0)").append('<div class="windowArea" id='+areaId+' style="display:none;">'+html+'</div>');	
	return windowDialog.newWindow($(".content #"+areaId), options||{});
}

var loadWindow = function(url, options){
	var areaId = "windowAreaDialog"+windowDialog.getNewWindowDialogNum();
	$(".windowContent").append('<div class="windowArea" id='+areaId+' style="display:none;"></div>');	
	
	$.when(loadUrlPromise($(".windowContent #"+areaId),location.pathname.split("/").splice(0, 2).join("/")+"/"+url)).then(function(html){
		var targetWindow = $("#"+areaId),
			targetWindowDialog = targetWindow.parents(".alertify");
		
		targetWindowDialog.data("url", url);		
		targetWindowDialog.find(".ajs-header").text(targetWindow.find(".head").text());
		targetWindowDialog.find(".ajs-footer").css({"text-align":"center", "margin-top":"10px"}).html(targetWindow.find(".foot").html());
	});
	
	var returnWindow = windowDialog.newWindow($(".windowContent #"+areaId), options||{});
	/*if(window.userVars && url.indexOf("userInfo_window.html") === -1 ){ // userVars 가 있고 window id가 userInfoWindow가 아니면 추가.
		var windows = window.userVars.windows || [];
			windows.push(returnWindow);
			window.userVars.windows = windows;	
	}*/
	
	return returnWindow;
}