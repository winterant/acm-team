package Servlet;

import Beans.User;
import Mysql.SQL;
import Reptile.Atcoder;
import Reptile.Codeforces;
import Reptile.Newcoder;
import Reptile.Upc;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Random;

@WebServlet(name = "ServletReptile",urlPatterns = {"/ServletReptile"})
public class ServletReptile extends HttpServlet {
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


//    采用线程方式，间隔3~10秒爬取一个人
    private void work(HttpServletRequest request, HttpServletResponse response) throws JSONException, IOException {
        String type=request.getParameter("type");
        System.out.println("收到指令："+type);
        JSONObject ret=new JSONObject();
        ret.put("result",false);
        ret.put("msg","操作失败");
        if("updateUpcContest".equals(type)){
            //更新upc竞赛
            new Thread(() -> {
                Upc upc=new Upc();
                upc.login();
                upc.updateContest();
            }).start();
            ret.put("result",true);
            ret.put("msg","爬虫已启动");
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().print(ret);
            return;
        }

        SQL mysql=new SQL();
        List<Map<String,Object>> list=mysql.queryList("select userName from users where status>0");

        Random random=new Random();
        new Thread(()->{
            for(Map<String,Object> i:list){
                User user=new User((String) i.get("userName"));
                if("updateCodeforcesRating".equals(type)){
                    new Codeforces().updateUser(user);
                }
                if("updateNewcoderRating".equals(type)){
                    new Newcoder().updateUser(user);
                }
                if("updateAtcoderRating".equals(type)){
                    new Atcoder().updateUser(user);
                }

                try {
                    Thread.sleep(random.nextInt(7000)+3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        System.out.println("爬虫已经启动");
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

}
