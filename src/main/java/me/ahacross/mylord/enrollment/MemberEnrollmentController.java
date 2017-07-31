package me.ahacross.mylord.enrollment;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles requests for the application home page.
 */
@RequestMapping("/enroll")
@RestController
public class MemberEnrollmentController {	
	private static final Logger logger = LogManager.getLogger(MemberEnrollmentController.class);
	
	@Autowired
	MemberEnrollmentService memberEnrollmentService;
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Object post(@RequestBody MemberEnrollment memberEnrollment) {
		return memberEnrollmentService.insert(memberEnrollment);
	}
}