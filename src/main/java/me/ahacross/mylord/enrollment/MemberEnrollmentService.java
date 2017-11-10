package me.ahacross.mylord.enrollment;

import java.util.Map;

public interface MemberEnrollmentService {
	public Map<String, Object> getOne(MemberEnrollment memberEnrollment) throws Exception;
	public int insert(MemberEnrollment memberEnrollment) throws Exception;
}
