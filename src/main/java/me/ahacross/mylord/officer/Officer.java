package me.ahacross.mylord.officer;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class Officer {
	private Integer member_id;
	private String year;
	private String role;
	private String status;
	private String s_date; 
	private String e_date;
}
