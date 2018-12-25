package Servlet;

import Beans.User;
import Mysql.SQL;
import Reptile.Atcoder;
import Reptile.Codeforces;
import Reptile.Newcoder;
import Tools.Changing;
import Tools.Checking;
import com.sun.org.apache.bcel.internal.classfile.Code;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "ServletUser",urlPatterns = {"/ServletUser"})
public class ServletUser extends HttpServlet {

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

    private void work(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException, JSONException {
        String type=request.getParameter("type");
        if("login".equals(type)){
            login(request,response);
        }else if("logout".equals(type)){
            logout(request,response);
        }else if("register".equals(type)){
            register(request,response);
        }else if("modify".equals(type)){
            modify(request,response);
        }else if("changeAlow".equals(type)){
            changeAlow(request,response);
        }else if("deleteUser".equals(type)){
            deleteUser(request,response);
        }else if("changePower".equals(type)){
            changePower(request,response);
        }else if("changeStatus".equals(type)){
            changeStatus(request,response);
        }
    }


    private boolean loginSession(HttpServletRequest request,String userName){
        //执行登录
        HttpSession session=request.getSession();
        User user=new User(userName);
        if(user.isExist()){
            session.setAttribute("user",user);
            session.setMaxInactiveInterval(60*30);
/*
            new Thread(() -> {
                Codeforces.updateUser(userName);
            }).start();
            new Thread(() -> {
                Newcoder.updateUser(userName);
            }).start();
            new Thread(() -> {
                Atcoder.updateUser(userName);
            }).start();
            */
            return true;
        }

        return false;
    }

    private void login(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
//        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");

        JSONObject ret=new JSONObject();
        try {
            if(User.isLegal(userName,password)&&loginSession(request,userName)){
                ret.put("result",true);
                ret.put("msg","登录成功");
            }else{
                ret.put("result",false);
                ret.put("msg","账号或密码错误!");
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void logout(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        request.getSession().invalidate();
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print("{\"result\":true}");
    }

    private void register(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException, JSONException {

        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("userName");
        String nickName = request.getParameter("nickName");
        String password1 = request.getParameter("password1");
        String password2 = request.getParameter("password2");
        String className=request.getParameter("className");
        String school=request.getParameter("school");
        String email=request.getParameter("email");
        String motto=request.getParameter("motto");
        String blog=request.getParameter("blog");
        String codeforcesid=request.getParameter("codeforcesid");
        String newcoderid=request.getParameter("newcoderid");
        String atcoderid=request.getParameter("atcoderid");
        String vjudgeid=request.getParameter("vjudgeid");
        String upcojid=request.getParameter("upcojid");

        password1=Changing.strTransfer(password1);
        password2=Changing.strTransfer(password2);

        motto=Changing.strTransfer(motto);
        className=Changing.strTransfer(className);
        school=Changing.strTransfer(school);
        blog=Changing.strTransfer(blog);

        JSONObject ret=new JSONObject();

        ret.put("result",false);
        User regUser=new User(userName);
        if(userName.length()<4||userName.length()>16||password1.length()<4||password1.length()>16||password2.length()<4){
            ret.put("msg","账号或密码的长度必须介于4~16");  //账号密码不能短于4个字符
            ret.put("flag",1);
        }else if(!password1.equals(password2)){
            ret.put("msg","两次输入密码不一致");  //两密码不一致
            ret.put("flag",2);
        }else if(regUser.isExist()){
            ret.put("msg","用户名已存在，请更换");  //账号已存在
            ret.put("flag",3);
        }else{
            SQL mysql=new SQL();
            //此处插入有待优化
            String sql = "insert into users(userName,password,nickName,className,school,email,motto,blog,codeforcesid,newcoderid,atcoderid,vjudgeid,upcojid)";
            sql+=" values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')";
            sql= String.format(sql,userName,User.encode(password1),nickName,className,school,email,motto,
                    blog,codeforcesid,newcoderid,atcoderid,vjudgeid,upcojid);
            System.out.println(sql);
            if(mysql.update(sql)==0) {
                ret.put("msg","数据库更新失败，请稍后重试"); //注册失败
                ret.put("flag",4);
            }else {
                //插入数据库成功，注册成功
                if(loginSession(request,userName)){
                    ret.put("result",true);
                    ret.put("msg","注册成功！");
                    ret.put("flag",0);
                }
            }
            mysql.close();
        }

        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void modify(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {

        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String password1 = request.getParameter("password1");
        String password2 = request.getParameter("password2");

        password= Changing.strTransfer(password);
        password1=Changing.strTransfer(password1);
        password2=Changing.strTransfer(password2);

        response.setContentType("text/html;charset=utf-8");
        JSONObject ret=new JSONObject();
        try {
            ret.put("result",false);

            User user= (User) request.getSession().getAttribute("user");
            User aimUser=user;
            if(userName==null||userName.equals("")){
                userName=user.getString("userName");
            }
            if(user==null||!user.isExist()){
                ret.put("msg","用户已掉线，请重新登录");
                ret.put("flag",1);
                response.getWriter().print(ret);
                return;
            }else if(!userName.equals(user.getString("userName"))){
                aimUser=new User(userName);
                Integer aimPower= aimUser.getInt("power");
                Integer userPower= user.getInt("power");
                if(userPower<=aimPower){
                    ret.put("msg","用户"+user.getString("userName")+"的权限不足");
                    ret.put("flag",2);
                    response.getWriter().print(ret);
                    return;
                }
            }else if(!user.getString("password").equals(User.encode(password))){
                ret.put("msg","原始密码错误");
                ret.put("flag",3);
                response.getWriter().print(ret);
                return;
            }

            if(password1==null||password2==null){
                //正常情况不会进来
            }else if((password1.length()>0||password2.length()>0)&&!password1.equals(password2)){
                ret.put("msg","两次输入密码不一致");
                ret.put("flag",4);
                response.getWriter().print(ret);
                return;
            }else{
                String sql=null;
                SQL mysql=new SQL();
                if(password1.length()>=4){
                    sql="update users set password='"+User.encode(password1)+"' where userName='"+userName+"'";
                    System.out.println(sql);
                    mysql.update(sql);
                }else if(password1.length()>0){
                    ret.put("msg","密码长度必须介于4~16");
                    ret.put("flag",5);
                    response.getWriter().print(ret);
                    return;
                }
                String motto=request.getParameter("motto");
                motto=Changing.strTransfer(motto);
                sql="update users set motto='"+motto+"' where userName='"+userName+"'";
                mysql.update(sql);

                if(user.getInt("power")>aimUser.getInt("power")
                        ||aimUser.getInt("alowModify")==1){
                    String nickName = request.getParameter("nickName");
                    String className=request.getParameter("className");
                    String school=request.getParameter("school");
                    String email=request.getParameter("email");
                    String blog=request.getParameter("blog");
                    String codeforcesid=request.getParameter("codeforcesid");
                    String newcoderid=request.getParameter("newcoderid");
                    String atcoderid=request.getParameter("atcoderid");
                    String vjudgeid=request.getParameter("vjudgeid");
                    String upcojid=request.getParameter("upcojid");
                    String lduojid=request.getParameter("lduojid");

                    className=Changing.strTransfer(className);
                    school=Changing.strTransfer(school);
                    blog=Changing.strTransfer(blog);

                    sql="update users set nickName='%s',className='%s',school='%s',email='%s',blog='%s',codeforcesid='%s',newcoderid='%s',atcoderid='%s',vjudgeid='%s',upcojid='%s',lduojid='%s' where userName='%s'";
                    sql=String.format(sql,nickName,className,school,email,blog,codeforcesid,newcoderid,atcoderid,vjudgeid,upcojid,lduojid,userName);
                    mysql.update(sql);
                }
                System.out.println(sql);
                mysql.close();
                if(user.equals(aimUser)){
                    request.getSession().removeAttribute("user");
                    loginSession(request,userName);
                    ret.put("result",true);
                    ret.put("msg","更新成功");
                    ret.put("flag",6);
                }else{
                    ret.put("result",true);
                    ret.put("msg","更新成功");
                    ret.put("flag",7);
                }
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        response.getWriter().print(ret);
    }

    private void changeAlow(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        request.setCharacterEncoding("UTF-8");
        String userName=request.getParameter("userName");
        User aimUser=new User(userName);
        User user= (User) request.getSession().getAttribute("user");
        JSONObject ret=new JSONObject();
        if(user==null||user.getInt("power")<=aimUser.getInt("power")){
            try {
                ret.put("result",false);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }else{
            int alow=1-aimUser.getInt("alowModify");
            String sql= String.format("update users set alowModify=%s where userName='%s'", alow, userName);
            new SQL().update(sql);
            try {
                ret.put("result",true);
                ret.put("msg","成功");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void deleteUser(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{

        request.setCharacterEncoding("UTF-8");
        String userName=request.getParameter("userName");
        User aimUser=new User(userName);
        User user= (User) request.getSession().getAttribute("user");
        JSONObject ret = new JSONObject();
        if(user==null||user.getInt("power")<=aimUser.getInt("power")){
            try {
                ret.put("result",false);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }else{
            String sql= String.format("delete from users where userName='%s'", userName);
            new SQL().update(sql);
            try {
                ret.put("result",true);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void changePower(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{

        JSONObject ret = new JSONObject();
        request.setCharacterEncoding("UTF-8");
        String userName=request.getParameter("userName");
        String changePower=request.getParameter("changePower");
        User aimUser=new User(userName);
        User user= (User) request.getSession().getAttribute("user");
        if(user==null||user.getInt("power")<2||!Checking.strIsNumber(changePower)){
            try {
                ret.put("result",false);
                ret.put("msg","权限不足！");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }else{
            int now=aimUser.getInt("power");
            if("1".equals(changePower)&&now<2)now++;
            if("0".equals(changePower)&&now>0)now--;
            String sql= String.format("update users set power=%s where userName='%s'", now, userName);
            new SQL().update(sql);
            try {
                ret.put("result",true);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

    private void changeStatus(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{

        JSONObject ret = new JSONObject();
        request.setCharacterEncoding("UTF-8");
        String userName=request.getParameter("userName");
        String change=request.getParameter("change");
        User aimUser=new User(userName);
        User user= (User) request.getSession().getAttribute("user");
        if(user==null||user.getInt("power")<2||!Checking.strIsNumber(change)){
            try {
                ret.put("result",false);
                ret.put("msg","权限不足！");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }else{
            int now=aimUser.getInt("status");
            if("1".equals(change)&&now<2)now++;
            if("0".equals(change)&&now>0)now--;
            String sql= String.format("update users set status=%d where userName='%s'", now, userName);
            SQL mysql=new SQL();
            mysql.update(sql);
            mysql.close();
            try {
                ret.put("result",true);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().print(ret);
    }

}
