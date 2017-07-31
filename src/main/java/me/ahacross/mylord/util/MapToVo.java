package me.ahacross.mylord.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MapToVo {
	private String setMethodName(String str) {
		return "set" + str.substring(0, 1).toUpperCase() + str.substring(1, str.length());
	}
	  
	public Object getObject(Map<String, Object> map, Class<?> cls) {
		Object returnObj = null;
	    
		try {
			Method[] methods = cls.getMethods();
			
			returnObj = cls.newInstance(); 
			
			for (String key : map.keySet()) {
				String methodName = setMethodName(key);
				for (int i = 0, n=methods.length ; i < n; i++) {
					Method method = methods[i];
					if (method.getName().matches("^" + methodName + "$")) {
						method.invoke(returnObj, new Object[] { map.get(key) });
						break;
					}
				}
			}
	    }
	    catch (InstantiationException | IllegalAccessException |
	    		SecurityException | InvocationTargetException |IllegalArgumentException e)
	    {
	      e.printStackTrace();
	    }
	    return returnObj;
	}
	
	@SuppressWarnings("unchecked")
	public Object getList(Map<String, Object> map, Class<?> cls, String key) {
		List<Map<String, Object>> objList = (List<Map<String, Object>>) map.get(key);
		List<Object> resultList = new ArrayList<>();
		
		if(objList.size() > 0) {
			for(int i=0,n=objList.size(); i<n; i++){
				resultList.add(getObject(objList.get(i), cls));
			}
		}
		
		return resultList;
	}
}
