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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

@WebServlet(name = "ServletMember",urlPatterns = {"/ServletMember"})
public class ServletMember extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type=request.getParameter("type");
        try {
            if("add".equals(type)||"update".equals(type)){
                add(request,response);
            }else if("changeStatus".equals(type)){
                System.out.println("changStatus");
                changeStatus(request,response);
            }else if("delete".equals(type)){
                delete(request,response);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        request.setCharacterEncoding("UTF-8");
        String type=request.getParameter("type");
        String id=request.getParameter("mid");
        String name=request.getParameter("name");
        String grade=request.getParameter("grade");
        String major=request.getParameter("major");
        String email=request.getParameter("email");
        String blog=request.getParameter("blog");
        String work=request.getParameter("work");
        String introduce=request.getParameter("introduce");
        String fileid=request.getParameter("fileid");
        String identity=request.getParameter("identity");

        introduce=Changing.strTransfer(introduce);

        JSONObject ret=new JSONObject();
        SQL mysql=new SQL();
        System.out.println("修改或添加队员信息.."+type);
        String sql="";
        if("add".equals(type)){
            sql="insert into members() values()";
            mysql.update(sql);
            id=String.valueOf(mysql.queryFirst("select MAX(id) id from members").get("id"));
            System.out.println("just id="+id);
        }

        System.out.println("更新id："+id);
        sql=String.format("update members set name='%s',grade='%s',major='%s',email='%s',blog='%s',work='%s',introduce='%s',photo='%s',identity='%s' where id="+id
                ,name,Changing.strToNumber(grade,2018),major,email,blog,work,introduce,Changing.strToNumber(fileid),identity);

        System.out.println(sql);
        if(mysql.update(sql)>0){
            ret.put("result",true);
            ret.put("msg","数据写入数据库");
        }else{
            ret.put("result",false);
            ret.put("msg","数据库插入失败");
        }
        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        int mid=Changing.strToNumber(request.getParameter("mid"),-1);
        JSONObject ret=new JSONObject();
        SQL mysql=new SQL();
        if(mid==-1){
            ret.put("result",false);
            ret.put("msg","该队员不存在，请刷新页面");
        }else{
            String sql="update members set status=1-status where id="+mid;
            if(mysql.update(sql)==0){
                ret.put("result",false);
                ret.put("msg","数据库更新失败");
            }else{
                ret.put("result",true);
                ret.put("msg","修改成功");
            }
        }

        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        int mid=Changing.strToNumber(request.getParameter("mid"),-1);
        JSONObject ret=new JSONObject();
        SQL mysql=new SQL();
        if(mid==-1){
            ret.put("result",false);
            ret.put("msg","该队员不存在，请刷新页面");
        }else{
            String sql="delete from members where id="+mid;
            if(mysql.update(sql)==0){
                ret.put("result",false);
                ret.put("msg","数据库更新失败");
            }else{
                ret.put("result",true);
                ret.put("msg","删除成功");
            }
        }

        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

}
