package me.ahacross.mylord.bbs.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BbsReply {
	private Integer bbs_id;
	private Integer seq;
	private String reply_text;
	private Integer member_id; 
	private String u_date;
}
