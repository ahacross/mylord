/*package me.ahacross.mylord.security;

import org.springframework.security.core.authority.AuthorityUtils;

public class LoginUserDetails extends org.springframework.security.core.userdetails.User {

	private static final long serialVersionUID = 7831776826145416314L;
	private Integer member_id;

	
	public LoginUserDetails(User user){
		super(
			user.getName(),
			user.getPhone(),
			AuthorityUtils.createAuthorityList(user.getRole())			
		);
		
		this.member_id = user.getMember_id();
	}
}
*/