package me.ahacross.mylord.enrollment;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberEnrollmentService")
public class MemberEnrollmentServiceImpl implements MemberEnrollmentService{
	@Autowired 
	SqlSessionTemplate session;
	
	@Override
	public Map<String, Object> getOne(MemberEnrollment memberEnrollment) throws Exception {
		MemberEnrollmentMapper mapper = session.getMapper(MemberEnrollmentMapper.class);
		return mapper.getOne(memberEnrollment);
	}
	
	@Override
	public int insert(MemberEnrollment memberEnrollment) throws Exception {
		MemberEnrollmentMapper mapper = session.getMapper(MemberEnrollmentMapper.class);
		return mapper.insert(memberEnrollment);
	}
}
