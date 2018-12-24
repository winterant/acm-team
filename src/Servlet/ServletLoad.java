package Servlet;

import Mysql.SQL;
import Tools.Changing;
import Tools.Checking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Map;

@WebServlet(name = "ServletLoad",urlPatterns = {"/ServletLoad"})
public class ServletLoad extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type=request.getParameter("type");
        System.out.println("开始读取文件，类型是："+type);
        if("photo".equals(type)){
            getImage(request,response);
        }else if("newsImg".equals(type)){
            getNewsImg(request,response);
        }else if("memberPhoto".equals(type)){
            getMemberPhoto(request,response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    protected void getImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName=request.getParameter("userName");
        SQL mysql=new SQL();
        String sql= String.format("select path from files where id in (select max(fileid) from photoes where userName='%s')", userName);
        String path= getUploadPath(request) + mysql.queryFirst(sql).get("path"); //获得绝对路径
        String fileName= (String) mysql.queryFirst(sql).get("realName");
        if(path==null||!new File(path).exists()){  //默认
            path=request.getServletContext().getRealPath("/images/smallPic/defaultphoto.jpg");
            fileName="defaultphoto.jpg";
        }
        System.out.println("读取路径："+path);
        outFile(path,fileName,"image/*",response);
    }

    protected void getNewsImg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int fileid= Changing.strToNumber(request.getParameter("fileid"),-1);
        System.out.println("fileid="+fileid);
        if(fileid<0){
            return;
        }
        SQL mysql=new SQL();
        String sql= String.format("select path from files where id=%s",fileid);
        Map item=mysql.queryFirst(sql);
        String path= getUploadPath(request) + item.get("path"); //获得绝对路径

        System.out.println("读取路径："+path);
        outFile(path, (String) item.get("realName"),"image/*",response); //输出文件
        mysql.close();
    }

    protected void getMemberPhoto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int mid=Changing.strToNumber(request.getParameter("mid"),-1);
        int fid=Changing.strToNumber(request.getParameter("fileid"),-1);
        SQL mysql=new SQL();

        if(mid==-1){
            if(fid==-1){
                String path=request.getServletContext().getRealPath("/images/smallPic/defaultphoto.jpg");
                System.out.println("读取路径："+path);
                outFile(path,"defaultphoto.jpg","image/*",response);
            }else {
                //按文件编号读取
                String sql= String.format("select path from files where id=%d", fid);
                System.out.println(sql);
                String path= getUploadPath(request) + mysql.queryFirst(sql).get("path"); //获得绝对路径
                String fileName= (String) mysql.queryFirst(sql).get("realName");
                if(path==null||!new File(path).exists()){  //默认
                    path=request.getServletContext().getRealPath("/images/smallPic/defaultphoto.jpg");
                    fileName="defaultphoto.jpg";
                }
                System.out.println("按文件编号读取路径："+path);
                outFile(path,fileName,"image/*",response);
            }
            mysql.close();
            return;
        }
        String sql= String.format("select path from files where id in (select photo from members where id=%d)", mid);
        System.out.println(sql);
        String path= getUploadPath(request) + mysql.queryFirst(sql).get("path"); //获得绝对路径
        String fileName= (String) mysql.queryFirst(sql).get("realName");
        if(path==null||!new File(path).exists()){  //默认
            path=request.getServletContext().getRealPath("/images/smallPic/defaultphoto.jpg");
            fileName="defaultphoto.jpg";
        }
        System.out.println("读取路径："+path);
        outFile(path,fileName,"image/*",response);
        mysql.close();
    }


    private void outFile(String path,String fileName,String contentType,HttpServletResponse response) throws IOException {
        FileInputStream fileInputStream = new FileInputStream(new File(path));
        byte data[]=new byte[fileInputStream.available()]; //临时数组保存数据流
        fileInputStream.read(data); //把文件流读到data数组内

//        response.setContentType(contentType); //设置文件类型
//        response.setContentType("html"); //设置文件类型
//        response.setHeader("Content-disposition","attachment;filename="+fileName);
        OutputStream outputStream=response.getOutputStream(); //输出文件
        outputStream.write(data);  //输出数据
        outputStream.flush();   //   记得关闭喔
        outputStream.close();   //   记得关闭喔
        fileInputStream.close();
        System.out.println("现在向前台输出数据...");
    }

    private String getUploadPath(HttpServletRequest request){
        String path = request.getServletContext().getRealPath("");
        path=path.replace("\\","/");//一定要加上，不然路径在插入数据库时会出错
        path=path.substring(0,path.length()-1);
        path=path.substring(0,path.lastIndexOf("/"));
        return path;
    }
}
