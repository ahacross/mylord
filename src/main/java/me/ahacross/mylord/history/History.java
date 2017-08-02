package me.ahacross.mylord.history;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class History {
	private String singed_date;
	private String title;
	private String link;
	private String source;
	private String scanning;
	private String practice; 
	private String etc;
}
