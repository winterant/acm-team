package Reptile;

import Mysql.SQL;
import Tools.Changing;
import com.gargoylesoftware.htmlunit.html.HtmlButton;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import com.gargoylesoftware.htmlunit.html.HtmlPasswordInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Upc extends HtmlunitURL{
    public Upc(){ super(); }
    public void login() { //登录Upc
        String userName="ldu_sc03";  //登录账号才能看见网页内容
        String password="zhaojinglong";
        final HtmlPage page;
        try {
            page = webClient.getPage("http://icpc.upc.edu.cn/loginpage.php");//打开一个登录页面
            HtmlTextInput inputUserName= (HtmlTextInput) page.getElementsByName("user_id").get(0);
            HtmlPasswordInput inputPasswd= (HtmlPasswordInput) page.getElementsByName("password").get(0);
            inputUserName.click();
            inputUserName.setText(userName);
            inputPasswd.click();
            inputPasswd.setText(password);

            HtmlButton btnLogin= (HtmlButton) page.getElementsByName("submit").get(0);
            btnLogin.click(); //点击登录，返回值为登陆成功页面
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int updateContest() {
        String url="http://icpc.upc.edu.cn/running.php";
        String html=super.getHtml(url);
        String aim="<tr[\\s\\S]*?</tr>"; //按行匹配
        Pattern pattern=Pattern.compile(aim);
        Matcher matcher=pattern.matcher(html);

        SQL mysql=new SQL();
        String sql,contestNames="";  //构造已存在竞赛，用于比对不存在竞赛
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        while(matcher.find()){
            System.out.println("-------开始正则匹配一条tr："+matcher.group());
            String words="<a href='running.php\\?cid=(\\d+)'>([\\s\\S]*?)</a></td><td>[\\s\\S]*?开始于@([\\s\\S]*?)</span>[\\s\\S]*?总赛时(\\d+)小时(\\d*)[\\s\\S]*?</span>";
            Pattern pat=Pattern.compile(words);
            Matcher mat=pat.matcher(matcher.group());

            if(!mat.find()){
                System.out.println("********本条tr信息未匹配！跳过********");
                continue;
            }
            String cid=mat.group(1);
            String title=mat.group(2);
            String startTime=mat.group(3);
            int hours=Changing.strToNumber(mat.group(4));
            int minutes=Changing.strToNumber(mat.group(5));
            System.out.println("******************************************");
            System.out.println("查询到一条竞赛：cid="+cid+"   "+title+"  开始:"+startTime+" 时长:"+hours+":"+minutes);
            if(contestNames.length()>0)contestNames+=",";
            contestNames+=String.format("'%s'",title);

            String endTime= null;
            try {
                endTime = sdf.format( new Date(sdf.parse(startTime).getTime()+hours*1000*60*60+minutes*1000*60) );
            } catch (ParseException e) {
                System.out.println("startTime: "+startTime+" 格式无效");
                e.printStackTrace();
            }
            System.out.println("结束时间："+endTime);

            sql="select id from contests where platform=5 and startTime>'"+sdf.format(new Date())+"' and title='"+title+"'";
            Map curContest=mysql.queryFirst(sql);
            if(curContest.isEmpty()){
                //不存在
                sql="insert into contests(title,platform) values('"+title+"',5)";
                System.out.println("竞赛不存在，先插入："+sql);
                mysql.update(sql);
                curContest=mysql.queryFirst("select max(id) id from contests");
            }
            System.out.println("竞赛id："+curContest.get("id"));
            sql=String.format("update contests set startTime='%s',endTime='%s',url='%s' where id="+curContest.get("id"),startTime,endTime,url+"?cid="+cid);
            System.out.println("更新竞赛"+sql);
            mysql.update(sql);
            System.out.println("*******************************************");
        }

        //下面删除数据库中失效的竞赛
        sql="delete from contests where platform=5 and startTime>'"+sdf.format(new Date())+"'";
        if(contestNames.length()>0)sql+=" and title not in ("+contestNames+")";
        System.out.println("删除无效竞赛："+sql);
        mysql.update(sql);
        return 0;
    }

}
