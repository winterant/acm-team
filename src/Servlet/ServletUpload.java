package Servlet;

import Beans.User;
import Mysql.SQL;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "ServletUpload",urlPatterns = {"/ServletUpload"})
public class ServletUpload extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            uploadFiles(request,response);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        return;
    }

    private void uploadFiles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=utf-8");
        User user= (User) request.getSession().getAttribute("user");

        JSONObject ret=new JSONObject();

        try {
            // 配置上传参数
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            // 解析请求的内容提取文件数据
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(request);

            //获取普通参数
            Map<String ,String> field=new HashMap<>();
            for (FileItem item : formItems){
                if(item.isFormField()){
                    field.put(item.getFieldName(),item.getString());
                }
            }
            String type=field.get("type"); //上传类型。上传子目录
            if(type==null||type.length()<1)type=request.getParameter("type");
            System.out.println("type="+type);

            // 迭代表单数据
            for (FileItem item : formItems) {
                // 处理不在表单中的字段，即文件
                if (!item.isFormField()) {
                    String fileName = item.getName(); //获取上传的文件名
                    String path="/upload/"+type+"/"+getSaveName(request,fileName);//上传文件的存放路径

                    String realPath = getUploadHome(request)+path;//文件完整绝对路径
                    File storeFile = new File(realPath);
                    if(!storeFile.getParentFile().exists()){//如果父目录不存在，就创建他
                        storeFile.getParentFile().mkdirs();
                    }
                    System.out.println(realPath);// 在控制台输出文件的上传路径
                    item.write(storeFile);// 保存文件到硬盘

                    //下面把这个文件路径插入数据库 表files
                    SQL mysql=new SQL();
                    String sql=String.format("insert into files(realName,path,author,time,type) " +
                                    "values('%s','%s','%s','%s',%d)",fileName,path,user==null?"匿名":user.getString("userName"),
                            new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()),0);

                    if(mysql.update(sql)>0){
                        System.out.println("files成功插入一个文件");
                    }else{
                        System.out.println("文件路径插入数据库失败");
                    }
                    String id= mysql.queryFirst("SELECT LAST_INSERT_ID() id").get("id").toString();



                    //关系表更新
                    if("photo".equals(type)){
                        //是头像,原有头像依然存在
                        String aimUserName=user.getString("userName");
                        sql=String.format("insert into photoes(userName,fileid) values('%s',%d)",aimUserName,id);
                        if(mysql.update(sql)>0){
                            System.out.println("设为头像成功");
                        }
                        ret.put("path",path);
                    }


                    if("newsImg".equals(type)){
                        ret.put("errno",0);
                        JSONArray arr=new JSONArray();
                        arr.put(path); //添加新闻图片，给前台返回图片地址
                        ret.put("data",arr);
                    }

                    if("memberPhoto".equals(type)){
                        ret.put("fileid",id);
                        ret.put("path",path);
                    }

                    mysql.close(); //关闭数据库连接
                }
            }
        } catch (FileUploadException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        ret.put("result",true);
        ret.put("msg","上传成功");
        response.getWriter().print(ret);
    }


    private String getUploadHome(HttpServletRequest request){
        //获取上传文件的父目录的绝对路径，通俗的说就是upload目录放在哪
        //下面获得本项目的父目录，即/upload与项目是兄弟文件夹
        String path=request.getServletContext().getRealPath(""); //项目根目录的绝对路径
        path=new File(path).getParent(); //向上一级
        return path.replace("\\","/");
    }
    private String getSaveName(HttpServletRequest request,String fileName){
        //生成一个文件名:date_time_ms_userName.*
        String fileType=fileName.substring(fileName.lastIndexOf(".")); //获取后缀
        String fileSaveName = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()).toString();
        fileSaveName+="_"+new Date().getTime()%1000;
        User user= (User) request.getSession().getAttribute("user");
        if(user!=null)fileSaveName+="_"+user.getString("userName");
        return fileSaveName+fileType; //+后缀
    }
}
