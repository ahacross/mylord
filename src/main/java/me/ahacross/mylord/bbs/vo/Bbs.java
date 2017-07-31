package me.ahacross.mylord.bbs.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Bbs {
	private Integer	bbs_id		; 
	private String	title		; 
	private String	content		;
	private String	i_date		;
	private Integer	i_member_id	;
	private String	u_date		;
	private Integer	u_member_id	;
	private Integer	count		;
	private String 	p_bbs_id	;
	private String search_category_id;
}
		