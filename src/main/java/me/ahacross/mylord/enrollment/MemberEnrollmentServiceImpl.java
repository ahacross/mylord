package me.ahacross.mylord.enrollment;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberEnrollmentService")
public class MemberEnrollmentServiceImpl implements MemberEnrollmentService{
	@Autowired 
	SqlSessionTemplate session;
	
	@Override
	public int insert(MemberEnrollment memberEnrollment) {
		MemberEnrollmentMapper mapper = session.getMapper(MemberEnrollmentMapper.class);
		return mapper.insert(memberEnrollment);
	}
}
