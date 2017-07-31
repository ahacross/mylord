<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">
	<div class="body">
		<table style="width:100%;" id="bbsForm">		
			<tr class="hide">
				<td class="center" style="width:20%;">카테고리</td>
				<td style="width:auto" id="categoryTd">
				</td>
			</tr>
			<tr>
				<td colspan="2" style="width:auto;font-size:15px;font-weight: 700;" id="titleTd"></td>
			</tr>
			<tr>
				<td colspan="2"  id="contentTd"></td>
			</tr>
			<tr>
				<td class="center" style="width:100px;background-color: gray;">파일첨부</td>
				<td id="filesTd"></td>
			</tr>
			<tr>
				<td class="center" colspan="2">
					<a class="btn" id="update">수정</a>
					<a class="btn" id="delete">삭제</a>
					<a class="btn" id="cancelBbs">취소</a>
				</td>
			</tr>
		</table>
		<div id="replyDiv">
			<div id="replyWrite">
				<table class="width100">
					<tr>
						<td style="width:auto;">
							<textarea rows="5" class="input width100"></textarea>							
						</td>
						<td style="width:50px;">
							<a class="btn" id="saveReply">저장</a>
						</td>
					</tr>
				</table>
				
			</div>
			<div id="replyRead">
			</div>
			
		</div>
	</div>
</div>
<script>
$("#bbsForm #cancelBbs").on("click", function(){
	$("#bbsFormArea").empty();	
	userFns.reloadBbsList();
	delete userVars.detail_bbs_id;
	delete userVars.bbsData;
	$("#searchBar").show();
});

$("#bbsForm #update").on("click", function(){
	$("#bbsFormArea")
		.empty()
		.load(filepath+"bbsForm.jsp");
});

$("#bbsForm #delete").on("click", function(){
	ajax.run({url:"bbs/"+userVars.detail_bbs_id, method:"delete", data:{bbs_id: userVars.detail_bbs_id}}, function(after, before){
		if(after.cnt > 0){
			msg.alert("삭제 되었습니다.");
			$("#bbsForm #cancelBbs").click();
		}
	});
});
console.log(111);
//상세 조회
ajax.run({url:"bbs/"+userVars.detail_bbs_id, data:{bbs_id: userVars.detail_bbs_id}}, function(after, before){
	var bbsForm = $("#bbsForm");
	userVars.bbsData = after.one;
	
	bbsForm.find("#titleTd").html(userVars.bbsData.title);
	bbsForm.find("#contentTd").html(userVars.bbsData.content);	
	
	//파일 목록 조회
	ajax.run({url:"bbs/files", data:{bbs_id: userVars.detail_bbs_id}}, function(after, before){
		var fileDatas = after.list,
			files = [],
			fileTd = $("#filesTd"),
			html = '';
		
	
		userVars.uploadFiles = {};
		fileDatas.forEach(function(item){
			html += '<div id="download" data-maskname="'+item.mask_name+'" data-oriname="'+item.ori_name+'">'+(item.ori_name +' ('+byteCalculation(item.size)+')')+'</div>'
			files.push(JSON.parse(item.file_info));
			userVars.uploadFiles[item.ori_name] = item;
		});
		
		fileTd.html(html);
		fileTd.find("> #download").css({"cursor":"pointer"});	
		userVars.bbsData.files = files;
	});
});

$("#filesTd").on("click", "#download", function(){
	ajax.down({mask_name: $(this).data("maskname"), ori_name:$(this).data("oriname")});
});
// 관련 게시글 목록 조회

userFns.reloadBbsList(userVars.detail_bbs_id);

var reloadReply = function(){
	var datas = {
		url:"/bbs/reply", 
		data:{
			bbs_id: userVars.detail_bbs_id 
		}		
	};
	ajax.run(datas, function(after, before){
		after.list
		var html = '';
		
		after.list.forEach(function(item){
			html += '<div style="padding: 10px;" class="reply" data-seq="'+item.seq+'">';
			html += '<div>'+item.name;
			if(item.member_id === cookie.getMylord("member_id")){
				html += '<span>';
				html += '&nbsp;&nbsp;&nbsp;'+item.u_date;
				html += '&nbsp;&nbsp;&nbsp;<i class="fa fa-pencil" id="modReply" aria-hidden="true"></i>';
				html += '&nbsp;&nbsp;&nbsp;<i class="fa fa-times"  id="delReply" aria-hidden="true"></i>';
				html += '</span>';
			}
			html += '</div>';
			html += '<div style="padding: 5px;" class="text">'+item.reply_text+'</div>';
			html += '</div>';
		});
		
		$("#replyRead").html(html);
	});
}
reloadReply();

$("#saveReply").on("click", function(){	
	var datas = {
		url:"/bbs/reply", 
		method:"insert", 
		data:{
			bbs_id: userVars.detail_bbs_id, 
			reply_text : $("#replyWrite textarea").val(), 
			member_id : cookie.getMylord("member_id")
		}		
	};
	
	if(userVars.editReply){
		datas.method = "update";
		datas.data.seq = $(userVars.editReply).parents(".reply").data("seq");	
		delete userVars.editReply;
	}
	
	ajax.run(datas, function(after, before){
		if(after.cnt === 1){
			$("#replyWrite textarea").val("");
			reloadReply();
		}
	});
	
});
$("#replyRead").on("click", "#modReply", function(){	
	$("#replyWrite textarea").val($(this).parents(".reply").find(".text").text());
	userVars.editReply = this;
});

$("#replyRead").on("click", "#delReply", function(){
	var that = this;
	msg.confirm("삭제하시겠습니까?", function(){
		var datas = {
			url:"/bbs/reply", 
			method:"delete", 
			data:{
				bbs_id: userVars.detail_bbs_id, 
				seq : $(that).parents(".reply").data("seq")
			}		
		};
		ajax.run(datas, function(after, before){
			if(after.cnt === 1){				
				reloadReply();
			}
		});	
	});
});

</script>
