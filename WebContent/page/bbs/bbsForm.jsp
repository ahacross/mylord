<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="row">
	<div class="col-lg-12">
    	<div class="panel panel-default">
        	<div class="panel-body">
            	<div class="row">
                	<div class="col-lg-12" id="bbsForm">
						<div class="form-group">
                           	<label>카테고리</label>
                           	<div id="categoryTd"></div>
                           </div>
                           <div class="form-group">
							<label>제목</label>
                               <input type="text" class="form-control" name="title" />
						</div>
						<div class="form-group">
							<label>내용</label>
                               <textarea rows="20" class="form-control noValid" name="contentText"  id="contentText"></textarea>
						</div>
						<div class="form-group">
							<label>파일첨부</label>
							<form id="ajaxform">
								<input type="file" name="files[]" id="filer_input" class="form-control" multiple="multiple"/>
					    	</form>
						</div>
						<div class="form-group" style="text-align: center;">
							<button type="button" id="saveBbs" class="btn btn-primary">저장</button>
							<button type="button" id="cancelBbs" class="btn btn-default">취소</button>	
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
if(userVars.editor){
	userVars.editor.destroy();
	delete userVars.editor;
	$("#contentText").val("");
}

var initEditor = function(){
	var defer = $.Deferred();
	var id = "contentText";
	if(userVars.editor){
		userVars.editor.destroy();
		delete userVars.editor;
	}

	tinymce.init({
		selector: '#'+id,
		height: 500,
		menubar: true,
		language: "ko_KR",
		automatic_uploads: true,
	// URL of our upload handler (for more details check: https://www.tinymce.com/docs/configure/file-image-upload/#images_upload_url)
	// here we add custom filepicker only to Image dialog
		file_picker_types: 'image', 
	// and here's our custom image picker
		file_picker_callback: function(cb, value, meta) {
		    var input = document.createElement('input');
		    input.setAttribute('type', 'file');
		    input.setAttribute('accept', 'image/*');
		    
		    // Note: In modern browsers input[type="file"] is functional without 
		    // even adding it to the DOM, but that might not be the case in some older
		    // or quirky browsers like IE, so you might want to add it to the DOM
		    // just in case, and visually hide it. And do not forget do remove it
		    // once you do not need it anymore.

		    input.onchange = function() {
		      var file = this.files[0];
		      
		      // Note: Now we need to register the blob in TinyMCEs image blob
		      // registry. In the next release this part hopefully won't be
		      // necessary, as we are looking to handle it internally.
		      var id = 'blobid' + (new Date()).getTime();
		      var blobCache = tinymce.activeEditor.editorUpload.blobCache;
		      var blobInfo = blobCache.create(id, file);
		      blobCache.add(blobInfo);
		      
		      // call the callback and populate the Title field with the file name
		      cb(blobInfo.blobUri(), { title: file.name });
		    };
		    
		    input.click();
		},
		images_upload_handler: function (blobInfo, success, failure) {
		    var xhr, formData;

		    xhr = new XMLHttpRequest();
		    xhr.withCredentials = false;
		    xhr.open('POST', location.pathname+"upload");

		    xhr.onload = function() {
		      var json;

		      if (xhr.status != 200) {
		        failure('HTTP Error: ' + xhr.status);
		        return;
		      }

		      json = JSON.parse(xhr.responseText);

		      if (!json || typeof json.location != 'string') {
		        failure('Invalid JSON: ' + xhr.responseText);
		        return;
		      }
console.log(json);
		      success(json.location);
		    };

		    formData = new FormData();
		    formData.append('file', blobInfo.blob(), blobInfo.filename());

		    xhr.send(formData);
		  },

		plugins: "autolink autosave code link media image table textcolor autoresize",
		toolbar: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image'
	});
	defer.resolve(tinymce.get(id));
	return defer.promise();
}

var initFile = function(files){
	var fileIdx = 0;
	if(userVars.bbsData){
		userVars.uploadFiles = userVars.uploadFiles;	
	}else{
		userVars.uploadFiles = {};
	}
	var options = {
		addMore : true,
		showThumbs: true,
		uploadFile:{
			url: location.pathname+"upload",
			data: {},
			type: 'POST',
			beforeSend : function(){
				fileIdx = 0;
			},
			success: function(data, el){
				var infos = data.fileInfos[0],
					fileObj = {},
					fileInfos = arguments[5].prop("files"),// 여기 좀 고쳐.
					fileInfo = fileInfos[fileIdx++];
				
				fileObj.name = fileInfo.name;
				fileObj.type = fileInfo.type;
				fileObj.size = fileInfo.size;
				infos.file_info = JSON.stringify(fileObj);
				userVars.uploadFiles[infos.ori_name] = infos;
			    el.find(".jFiler-jProgressBar").fadeOut("slow", function(){});
			},
			error: function(el){
			    el.find(".jFiler-jProgressBar").fadeOut("slow", function(){});
			}
		},
		onRemove : function(item, file_data){ // 파일 삭제 기능 추가해야 함.
			var datas = userVars.uploadFiles[file_data.name];
			
			var ajaxDatas = {
				url : "file",
				method: "delete",
				data: datas
			};
			
			ajax.run(ajaxDatas, function(){
				delete userVars.uploadFiles[file_data.name];	
			});
		},
		dialogs: {
			alert: function(text) {
		        msg.alert(text);
		    },
		    confirm: function(text, callback) {
		        msg.confirm(text, callback);
		    }
		},

		captions: {
	        button: "파일 선택",
	        feedback: "업로드 할 파일 선택",
	        feedback2: "파일이 선택되었습니다.",
	        removeConfirmation: "이 파일을 제거 하시겠습니까?"
	    }
	}

	if(files){
		options.files = files;
	}

	userVars.fileTarget = $('#filer_input').filer(options);
}


var setDatas = function(data){
	var datas = {};

	if(userVars.bbsData){
		datas.url = "bbs/"+userVars.bbsData.bbs_id;
		datas.method = "update";
		data.bbs_id = userVars.bbsData.bbs_id;
		data.u_member_id = cookie.getMylord("member_id");
	}else{
		datas.url = "bbs";
		datas.method = "insert";
		data.i_member_id = cookie.getMylord("member_id");
	}
	
	data.categorys = [];
	$("#bbsForm [name=category_id]:checked").each(function(){
		data.categorys.push({"category_id":Number($(this).val())});
	});
	data.content = userVars.editor.getContent();

	datas.data = data;
	return datas;
}

$("#bbsForm #saveBbs").on("click", function(){
	var data = validate($("#bbsForm"));
	if(data === true){
		return false;
	}
	
	var fileInfos = [];
	_.keys(userVars.uploadFiles).forEach(function(item){
		fileInfos.push(userVars.uploadFiles[item]);	
	});

	if(fileInfos.length === 0){
		data.fileInfos = [];
	}else{
		data.fileInfos = fileInfos;
	}
	var datas = setDatas(data);
	
	if(datas.data.categorys.length === 0){
		msg.alert("카테고리를 선택해 주세요.");
		return false;
	}
	
	console.log(datas);
	
	ajax.run(datas, function(after, before){
		if(after.cnt > 0){
			msg.alert(((after.type==="insert")?"추가":"수정")+" 되었습니다.");
			$("#bbsForm #cancelBbs").click();
		}
	});
});

$("#bbsForm #cancelBbs").on("click", function(){
	$("#bbsFormArea").empty();
	userFns.reloadBbsList();
	$("#searchBar").show();
});

ajax.run({url:"bbs/category"}, function(after, before){
	var html = '';
	after.forEach(function(item){
		html += '<label style="cursor:pointer;"><input type="checkbox" name="category_id" class="input noValid" value="'+item.category_id+'"/> '+item.category_name+'</label>&nbsp;&nbsp;&nbsp;';
	});

	$("#bbsForm #categoryTd").html(html);
	
	initEditor().then(function(editor){
		userVars.editor = editor;

		if(userVars.bbsData){
			var bbsData = userVars.bbsData,
				bbsForm = $("#bbsForm");

			bbsData.category_ids.split(",").forEach(function(item){
				bbsForm.find(":checkbox[value="+item+"]").prop("checked", true);
			});

			bbsForm.find("[name=title]").val(bbsData.title);
			setTimeout(function(){
				userVars.editor.setContent(bbsData.content);
			}, 200);
			
			initFile(bbsData.files);
		}else{
			initFile();		
		}
	});
});
</script>
