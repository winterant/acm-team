package Tools;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Changing {

    public static Integer strToNumber(String str,int defaultNumber){
        //将str强制转换成Integer，如果失败，返回默认的num
        if(Checking.strIsNumber(str))
            return Integer.parseInt(str);
        return defaultNumber;
    }
    public static Integer strToNumber(String str){
        return strToNumber(str,0);
    }

    public static String strTransfer(String oldStr){
        System.out.println("原始串："+oldStr);
        if(oldStr==null)return "";
        oldStr=oldStr.replace("\\","\\\\");
        oldStr=oldStr.replace("\'","\\\'");
        oldStr=oldStr.replace("\"","\\\"");
        System.out.println("格式化："+oldStr);
        return oldStr;
    }

    public static Date strToDate(String dateTime){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            return sdf.parse(dateTime);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }


}
