package Tools;

public class Checking {

    public static boolean strIsNumber(String str){
        //检查str是否能转化成数字
        if(str==null||str.isEmpty())return false;
        for(int i=0;i<str.length();i++){
            if(str.charAt(i)<'0'||str.charAt(i)>'9')
                return false;
        }
        return true;
    }
}
