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

@WebServlet(name = "ServletNews",urlPatterns = {"/ServletNews"})
public class ServletNews extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            work(request,response);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    private void work(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        request.setCharacterEncoding("UTF-8");
        String type=request.getParameter("type");
        String id=request.getParameter("id");
        String title=request.getParameter("title");
        String mainText=request.getParameter("mainText");
        String updateDate=request.getParameter("updateDate");
        String author=request.getParameter("author");
        String publishTime=new SimpleDateFormat("YYYY-MM-dd HH:mm:ss").format(new Date());
        String status=request.getParameter("status");

        title= Changing.strTransfer(title);
        mainText=Changing.strTransfer(mainText);
        author=Changing.strTransfer(author);

        System.out.println(mainText);

        JSONObject ret=new JSONObject();
        SQL mysql=new SQL();
        String sql;

        if(Changing.strToNumber(id)==0){  //编号为0，则为添加新的新闻，先插入
            sql=String .format("insert into news(publishTime) values('%s')",publishTime);
            if(mysql.update(sql)==0){
                ret.put("result",false);
                ret.put("msg","数据库插入失败");
            }
            id=String.valueOf(mysql.queryFirst("SELECT LAST_INSERT_ID() id").get(0));
        }
        if("save".equals(type)){
            sql=String.format("update news set title='%s',mainText='%s',author='%s',status='%s'"
                    ,title,mainText,author,status);
            if("true".equals(updateDate)){
                sql+=",publishTime='"+publishTime+"'";
            }
            sql+=" where id="+id;
            System.out.println(sql);
            if(mysql.update(sql)>0){
                ret.put("result",true);
            }else{
                ret.put("result",false);
                ret.put("msg","保存失败");
            }

        }else if("delete".equals(type)){
            sql="delete from news where id='"+id+"'";
            if(mysql.update(sql)>0){
                ret.put("result",true);
            }else{
                ret.put("result",false);
                ret.put("msg","删除失败");
            }
        }else if("query".equals(type)){
            sql="select * from news where id="+id;
            Map re=mysql.queryFirst(sql);
            System.out.println(sql+"结果是\n"+re.toString());
            if(!re.isEmpty()){
                ret.put("result",true);
                ret.put("news",re);
            }else{
                ret.put("result",false);
                ret.put("msg","新闻不存在");
            }
        }

        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }
}
