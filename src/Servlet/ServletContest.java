package Servlet;

import Mysql.SQL;
import Tools.Changing;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "ServletContest",urlPatterns = {"/ServletContest"})
public class ServletContest extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type=request.getParameter("type");
        try {
            if("add".equals(type)||"update".equals(type)){
                    add(request,response);
            }else if("delete".equals(type)){
                delete(request,response);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        return;
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        response.setContentType("text/html;charset=utf-8");
        String type=request.getParameter("type");
        String platform=request.getParameter("platform");
        String title=request.getParameter("title");
        String mainText=request.getParameter("mainText");
        String start=request.getParameter("startTime");
        String[] length=request.getParameter("length").split(":");

        String url=request.getParameter("url");

        title=Changing.strTransfer(title);
        mainText=Changing.strTransfer(mainText);
        mainText=mainText.replace("\n","<br>");
        url=Changing.strTransfer(url);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        JSONObject ret=new JSONObject();
        if(length.length!=2||Changing.strToNumber(length[0],-1)<0){
            ret.put("result",false);
            ret.put("msg","请您输入合法的时长，例如：5:00（5小时0分钟）");
        }else if(title.length()<1){
            ret.put("result",false);
            ret.put("msg","请您输入竞赛标题");
        }else{
            try {
                Date startTime=sdf.parse(start);
                long endT=startTime.getTime();
                endT+=1000L*Changing.strToNumber(length[0])*60*60;
                if(length.length>1)endT+=1000L*Changing.strToNumber(length[1])*60;
                Date endTime=new Date(endT);

                System.out.println("开始操作数据库...");
                String sql=null;
                SQL mysql=new SQL();
                if("update".equals(type)){
                    int id= Changing.strToNumber(request.getParameter("cid"));
                    sql=String.format("update contests set platform='%s',title='%s',mainText='%s',startTime='%s'," +
                            "endTime='%s',url='%s' where id=%d",platform,title,mainText,start,sdf.format(endTime),url,id);

                }else{
                    sql= String.format("insert into contests(platform,title,mainText,startTime,endTime,url) " +
                            "values('%s','%s','%s','%s','%s','%s')",platform,title,mainText,start,sdf.format(endTime),url);
                }
                System.out.println(sql);
                if(mysql.update(sql)>0){
                    ret.put("result",true);
                    ret.put("msg","更新成功");
                }else{
                    ret.put("result",false);
                    ret.put("msg","数据库更新失败");
                }
                mysql.close();
            } catch (ParseException e) {
                e.printStackTrace();
                ret.put("result",false);
                ret.put("msg","请您输入合法的开始时间，例如：2018-12-31 12:00:00");
            }
        }

        response.getWriter().print(ret);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        String cid=request.getParameter("cid");
        SQL mysql=new SQL();
        String sql= "delete from contests where id="+cid;
        JSONObject ret=new JSONObject();
        if(mysql.update(sql)>0){
            ret.put("result",true);
            ret.put("msg","删除成功");
        }else{
            ret.put("result",false);
            ret.put("msg","删除失败");
        }
        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }
}
