package me.ahacross.mylord.bbs.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class BbsFile {
	private Integer bbs_id;
	private Integer seq; 
	private String ori_name;
	private String mask_name;
	private String size;
	private String file_info;
}
