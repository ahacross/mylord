package me.ahacross.mylord.enrollment;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="memberEnrollmentMapper")
public interface MemberEnrollmentMapper {
	public Map<String, Object> getOne(MemberEnrollment memberEnrollment) throws Exception;
	public int insert(MemberEnrollment memberEnrollment) throws Exception;
}
