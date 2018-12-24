package TEST;


import Reptile.Upc;

import java.io.File;

public class Main {

    public static void main(String[] args){
        File file=new File("/index.jsp");
        System.out.println(file.exists());
        if(file.exists()){
            System.out.println(file.toString());
        }
        /*
        new Thread(()->{
            Upc upc=new Upc();
            upc.login();
            upc.updateContest();
        }).start();
*/
    }
}
