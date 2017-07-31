/*package me.ahacross.mylord.security;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import me.ahacross.mylord.member.Member;
import me.ahacross.mylord.member.MemberService;
import me.ahacross.mylord.util.MapToVo;

@Service
public class LoginUserDetailsService implements UserDetailsService{
	
	 @Autowired
	 private MemberService memberService;
	
	 @Override
	 public UserDetails loadUserByUsername(String phone) throws UsernameNotFoundException {
		 User user = new User();
		 Member member = new Member();
		 member.setPhone(phone);
		 Map<String, Object> map = memberService.login(member);
		 if(map == null){
	            throw new UsernameNotFoundException("UserPhone "+phone+" not found");
		 }else{
			 member = new Member();
			 member.setMember_id((Integer)map.get("member_id"));
			 member = (Member)new MapToVo().getObject(memberService.getOne(member), Member.class);
			 
			 user.setMember_id(member.getMember_id());
			 user.setPhone(member.getPhone());
			 user.setName(member.getName());
			 user.setRole((String)map.get("role"));
		 }
	     return new LoginUserDetails(user);
	 }
}
*/