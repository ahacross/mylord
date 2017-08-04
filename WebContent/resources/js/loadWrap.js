var pathname = location.pathname;
$LAB.setGlobalDefaults({AllowDuplicates:true})
	.script("resources/plugins/material-framework-3.0/dist/material.min.js")
	.script("resources/plugins/crypto/sha256.js")
	.script("resources/plugins/jquery-ui/jquery-ui.min.js")
	.script("resources/plugins/jqueryForm/jquery.form.js")
	.script("resources/plugins/lodash/lodash.js")
	.script("resources/plugins/tinymce/tinymce.min.js")
	.script("resources/plugins/c3/d3-3.5.6.min.js")
	.script("resources/plugins/c3/c3.min.js")
	.script("resources/plugins/alertify/alertify.js")
	.script("resources/js/alertWrap.js")
	.script("resources/plugins/jQuery.filer/js/jquery.filer.min.js")
	.script("resources/js/table.js")
	.script("resources/js/windowDialog.js")
	.script("resources/js/common.js").wait(function(){
		jsLodingComplate = true;
	});