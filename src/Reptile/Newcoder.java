package Reptile;

import Beans.User;
import Mysql.SQL;
import Tools.Changing;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Newcoder extends HtmlunitURL{
    public Newcoder(){super(); }

    public int updateUser(User user){
        String userName=user.getString("userName");
        String nkName=user.getString("newcoderid");
        if(nkName==null||nkName.length()<1)return 0;
        try { //对中文进行编码
            nkName=URLEncoder.encode(nkName, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        //获取页面html
        String html=super.getHtml("https://ac.nowcoder.com/acm/contest/rating-index?searchUserName="+nkName);

        //正则表达式匹配分数
        Pattern pattern=Pattern.compile("<span class=\"rate-score\\d\">[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="0";
        if(matcher.find()){
            int s=matcher.group().lastIndexOf(">");
            score=matcher.group().substring(s+1);
        }
        System.out.println("获得牛客分数 "+nkName+" : "+score);
        if(score.equals("0"))return 0;

        //数据库更新分数
        String sql="update users set newcoderRating="+score+" where userName='"+userName+"'";
        SQL mysql=new SQL();
        int ret1=mysql.update(sql);

        //下面把总rating更新一下
        sql="update users set rating="+User.computeRating(userName)+" where userName='"+userName+"'";
        int ret2=mysql.update(sql);
        mysql.close();
        System.out.println("牛客更新成功 "+nkName+" rating: "+score);
        return ret1+ret2;
    }

    //爬虫获取用户的牛客分数
    public int getRating(String nkName){
        try { //对中文进行编码
            nkName=URLEncoder.encode(nkName, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        //获取页面html
        String html=super.getHtml("https://ac.nowcoder.com/acm/contest/rating-index?searchUserName="+nkName);

        //正则表达式匹配分数
        Pattern pattern=Pattern.compile("<span class=\"rate-score\\d\">[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="0";
        if(matcher.find()){
            int s=matcher.group().lastIndexOf(">");
            score=matcher.group().substring(s+1);
        }
        return Changing.strToNumber(score);
    }

    public int updateContest(){
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
        sql="delete from contests where platform=5 and startTime>'"+sdf.format(new Date())+"' and title not in ("+contestNames+")";
        System.out.println("删除无效竞赛："+sql);
        mysql.update(sql);

        return 0;
    }
}
