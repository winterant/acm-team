package Servlet;

import Beans.User;
import Mysql.SQL;
import Tools.Changing;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Result;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "ServletSpeaks",urlPatterns = {"/ServletSpeaks"})
public class ServletSpeaks extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type=request.getParameter("type");
        try {
            if("speak".equals(type)){
                    speak(request,response);
            }else if("delete".equals(type)){
                deleteSpeaks(request,response);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }



    private void speak(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        User user= (User) request.getSession().getAttribute("user");
        String mainText=request.getParameter("mainText");
        String author=request.getParameter("author");

        mainText=mainText.replace("\\","\\\\");
        mainText=mainText.replace("\'","\\\'");
        mainText=mainText.replace("\"","\\\"");
        mainText=mainText.replace("\n","<br>");
        System.out.println("发言："+mainText);
        author= Changing.strTransfer(author);

        response.setContentType("text/html;charset=utf-8");
        JSONObject ret=new JSONObject();
        if(mainText.length()<1||mainText.length()>50){
            ret.put("result",false);
            ret.put("msg","发言太短啦");
            if(mainText.length()>50)ret.put("msg","留言不要超过50个字哦");
            response.getWriter().print(ret);
            return;
        }

        if(author==null||author.equals("")){
            author="匿名";
        }
        int isUser= user==null?0:1;
        if(isUser==1){
            author=user.getString("userName");
        }
        String Time=new SimpleDateFormat("YYYY-MM-dd HH:mm:ss").format(new Date());
        String sql=String.format("insert into speaks(mainText,author,publishTime,isUser) values('%s','%s','%s','%s')",mainText,author,Time,isUser);
        SQL mysql=new SQL();
        if(mysql.update(sql)>0){
            ret.put("result",true);
            ret.put("msg","发言成功");
        }else{
            ret.put("result",false);
            ret.put("msg","数据库更新失败");
        }
        response.getWriter().print(ret);
    }

    private void deleteSpeaks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        response.setContentType("text/html;charset=utf-8");
        User user= (User) request.getSession().getAttribute("user");
        JSONObject ret=new JSONObject();
        if(user==null||user.getInt("power")==0){
            ret.put("result",false);
            ret.put("msg","权限不足");
            return;
        }
        String sid=request.getParameter("sid");

        String sql=String.format("delete from speaks where id='%s'",sid);
        new SQL().update(sql);
        ret.put("result",true);
        ret.put("msg","成功");
        response.getWriter().print(ret);
    }
}
