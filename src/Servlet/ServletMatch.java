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

@WebServlet(name = "ServletMatch",urlPatterns = {"/ServletMatch"})
public class ServletMatch extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opertype = request.getParameter("opertype");
        try {
            if ("add".equals(opertype) || "update".equals(opertype)) {
                add(request, response);
            } else if ("delete".equals(opertype)) {
                delete(request, response);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        return;
    }

    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        String opertype = request.getParameter("opertype");
        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String title = request.getParameter("title");
        String mainText = request.getParameter("mainText");
        String gold = request.getParameter("gold");
        String silver = request.getParameter("silver");
        String bronze = request.getParameter("bronze");
        String newsUrl = request.getParameter("newsUrl");
        if (gold == null || gold.length() < 1) gold = "0";
        if (silver == null || silver.length() < 1) silver = "0";
        if (bronze == null || bronze.length() < 1) bronze = "0";

        title = Changing.strTransfer(title);
        mainText = Changing.strTransfer(mainText);
        newsUrl = Changing.strTransfer(newsUrl);

        JSONObject ret = new JSONObject();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (title.length() < 1) {
            ret.put("result",false);
            ret.put("msg","赛事标题不能为空");
        } else {
            try {
                Date matchDate = sdf.parse(date); ///通过异常来试探，这是不是一个正确格式的日期
                int id = 1;
                String sql = null;
                SQL mysql = new SQL();
                if ("add".equals(opertype)) {
                    sql = "select MAX(id) from matches";
                    ResultSet rs = mysql.queryRS(sql);
                    if (rs != null && rs.next()) {
                        id = rs.getInt(1) + 1;
                    }
                    sql = String.format("insert into matches(id,title,date) values(%d,'%s','%s')", id, title, date);
                    mysql.update(sql);
                    System.out.println(sql);
                } else {
                    id = Changing.strToNumber(request.getParameter("mid"), 1);
                }

                sql = String.format("update matches set type='%s',date='%s',title='%s',mainText='%s',gold='%s'," +
                        "silver='%s',bronze='%s',newsUrl='%s' where id=%d", type, date, title, mainText, gold, silver, bronze, newsUrl, id);
                System.out.println(sql);
                if (mysql.update(sql) > 0) {
                    ret.put("result",true);
                    ret.put("msg","成功");
                } else {
                    ret.put("result",false);
                    ret.put("msg","数据库更新失败");
                }
                mysql.close();
            } catch(ParseException e){
                e.printStackTrace();
                ret.put("result",false);
                ret.put("msg","日期格式错误");
            } catch(SQLException e){
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {

        String mid=request.getParameter("mid");
        JSONObject ret = new JSONObject();
        SQL mysql=new SQL();
        String sql= "delete from matches where id="+mid;
        if(mysql.update(sql)>0){
            ret.put("result",true);
            ret.put("msg","成功");
        }else{
            ret.put("result",false);
            ret.put("msg","数据库更新失败");
        }
        mysql.close();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

}
