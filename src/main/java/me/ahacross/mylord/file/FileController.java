package me.ahacross.mylord.file;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import me.ahacross.mylord.bbs.vo.BbsFile;

/**
 * Handles requests for the application home page.
 */

@MultipartConfig 
(
	location = "/home/ahacross/temp/",		// 공용 파일을 통해 경로를 하나로 관리한다.
	fileSizeThreshold = 1024*1024*2048,		// 2GB : maxRequestSize 보다 높게 설정하여 임시파일을 하드디스크에 기록하지 않도록 만든다.
	maxRequestSize = 1024*1024*1024,		// 1GB : 연결이 끊어져도 될만한 충분한 용량을 설정한다. 다중파일을 받는다면 해당만큼 올려준다.
	maxFileSize = 1024*1024*500				// 500MB : 10메가 정도 받는다는 생각으로 12메가를 선언했다.	
)
@RestController
public class FileController {
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> fileUpload(HttpServletRequest request) throws IOException, ServletException {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	String uploadLocation = new FilePath().getUploadLocation();
    	boolean saveOri = false;
    	if(request.getParameter("path") != null){
    		
    		uploadLocation = request.getParameter("path");
    		saveOri = true;
    		if(uploadLocation.equals("file")){
    			uploadLocation = new FilePath().getUploadLocationFile();
    		}
    	}
    	Collection<Part> parts = request.getParts();
        List<Map<String, String>> fileInfos = new ArrayList<>();
        for(Part part : parts){
        	if(part.getSubmittedFileName() != null && !part.getSubmittedFileName().equals("")){
        		fileInfos.add(fileMove(part, uploadLocation, saveOri));
        	}
        }
        
   		resultMap.put("fileInfos", fileInfos);
        return resultMap;
    }
 
    @RequestMapping(value = "/download", method=RequestMethod.GET)
    @ResponseBody
    public void download(@ModelAttribute BbsFile bbsFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
    	String uploadLocation = new FilePath().getUploadLocation();
        File file = new File(uploadLocation+bbsFile.getMask_name());
                
        if(!file.exists()){
            String errorMessage = "Sorry. The file you are looking for does not exist";
            System.out.println(errorMessage);
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
            outputStream.close();
            return;
        }
        
        String encordedFilename = URLEncoder.encode(bbsFile.getOri_name(),"UTF-8").replace("+", "%20");
        
        response.setContentType("application/octet-stream");
        
        /* "Content-Disposition : inline" will show viewable types [like images/text/pdf/anything viewable by browser] right on browser 
            while others(zip e.g) will be directly downloaded [may provide save as popup, based on your browser setting.]*/
        System.out.println("download : "+bbsFile.getOri_name());
        //response.setHeader("Content-Disposition", String.format("attachment; filename=\"" + bbsFile.getOri_name() +"\""));
        response.setHeader("Content-Disposition", "attachment;filename=" + encordedFilename + ";filename*= UTF-8''" + encordedFilename);
        response.setHeader("Content-Transfer-Encoding", "binary;");
        /* "Content-Disposition : attachment" will be directly download, may provide save as popup, based on your browser setting*/
        //response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s\"", file.getName()));
         
        response.setContentLength((int)file.length());
 
        InputStream inputStream = new BufferedInputStream(new FileInputStream(file));
 
        //Copy bytes from source to destination(outputstream in this example), closes both streams.
        FileCopyUtils.copy(inputStream, response.getOutputStream());
    }
    
    private Map<String, String> fileMove (Part part, String uploadLocation, boolean saveOri) throws IOException{
    	Map<String, String> tempMap = new HashMap<>();
    	String filename = part.getSubmittedFileName();
		//filename = new String(filename.getBytes("8859_1"),"utf-8");
    	String fileext = filename.substring(filename.lastIndexOf(".") + 1);
		String maskname = UUID.randomUUID().toString() + "."+ fileext;
		String filesize = String.valueOf(part.getSize());
		String filepath = uploadLocation + "";
		
		//part.write(filepath + maskname);
		String tempName ;
		if(saveOri){
			tempName = filename;
		}else{
			tempName = maskname;
		}
		
		System.out.println(filepath + tempName);
		part.write(filepath + tempName);
		File tempFile = new File(filepath, tempName);
		if(saveOri){
			Runtime.getRuntime().exec("chmod 644 "+tempFile.getAbsolutePath());
		}
		
        //FileCopyUtils.copy(tempFile.getBytes(), new File(UPLOAD_LOCATION, maskname));
        tempMap.put("ori_name", filename);
        tempMap.put("mask_name", maskname);
        tempMap.put("filepath", filepath);
		tempMap.put("fileext", fileext);
		tempMap.put("size", filesize);
        
    	return tempMap;
    }
    
    @RequestMapping(value = "/file", method=RequestMethod.DELETE)
    @ResponseBody
    public void delete(@RequestBody BbsFile bbsFile) throws IOException {
    	String uploadLocation = new FilePath().getUploadLocation();
        File file = new File(uploadLocation+bbsFile.getMask_name());
        System.out.println(uploadLocation+bbsFile.getMask_name());
        if(file.exists()){
        	file.delete();
        }
        
    }
}