var msg = (function(){
	var init = function(){
		var options = {
			'autoReset':true,
			'resizable':false,
			'movable':true,
			'closable':false,
			'pinnable':false,
			'transition':'zoom'		
			};
		
		alertify.alert().setting( $.extend({'label':'확인'}, options));
		$(alertify.alert().elements.header).remove();
		$(alertify.alert().elements.modal).css("z-index", "6000");
		$(alertify.alert().elements.dimmer).css("z-index", "6000");
		
		alertify.confirm().setting($.extend({'labels':{ok:'확인', cancel:'취소'}}, options));
		$(alertify.confirm().elements.header).remove();
		$(alertify.confirm().elements.modal).css("z-index", "6000");
		$(alertify.confirm().elements.dimmer).css("z-index", "6000");
		
		alertify.prompt().setting($.extend({'labels':{ok:'확인', cancel:'취소'}}, options));
		$(alertify.prompt().elements.header).remove();
		$(alertify.prompt().elements.modal).css("z-index", "6000");
		$(alertify.prompt().elements.dimmer).css("z-index", "6000");
	}
	
	var alert = function(msg, callback, params, isNoModal){
		if(isNoModal){
			alertify.alert("", msg, callback).set({'modal':false, 'pinnable':false}) ;
		}else if(params){
			alertify.alert("", msg, callback).set(params) ;	
		}else{
			alertify.alert("", msg, callback).set({'modal':true}) ;
		}
	}

	var confirm = function(msg, callback, params){
		alertify.confirm(msg, callback) ;
    }
	
	var prompt = function(msg, callback, cancelCallback, params){
		alertify.prompt(msg, '', callback, cancelCallback) ;
    }
	
	return {
		init:init,
		alert : alert,
		confirm : confirm,
		prompt : prompt
	}
}());

$(document).ready(msg.init);