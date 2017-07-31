package me.ahacross.mylord.file;

import javax.servlet.http.HttpServletRequest;

@SuppressWarnings("unused")
public class FilePath {	
	private final String UPLOAD_LOCATION_SERVER ="/home/nginxRoot/files/mylord/";
	private final String UPLOAD_LOCATION_SERVER_FILE ="/home/nginxRoot/files/";
    private final String UPLOAD_LOCATION_DEV = "D:/workspaces/boot/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Mylord/files/";
    private final String UPLOAD_LOCATION_COM = "C:/Users/test/Desktop/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Mylord/files/";
    
    public String getUploadLocation () {    	
   		return UPLOAD_LOCATION_SERVER;
    }
    public String getUploadLocationFile () {
    	return UPLOAD_LOCATION_SERVER_FILE;
    	
    }
}

