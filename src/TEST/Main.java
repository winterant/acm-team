package TEST;

import java.math.BigInteger;
import java.util.Scanner;

public class Main {

    public static void main(String[] args){
        Scanner in=new Scanner(System.in);
        int n;
        BigInteger X;
        n=in.nextInt();
        X=in.nextBigInteger();

        int[] a=new int[n];
        BigInteger[] num=new BigInteger[n];

        for(int i=0;i<n;i++)
        {
            a[i]=in.nextInt();
            num[i]=in.nextBigInteger();
        }
        for(int i=n-1;i>=0;i--)
        {
            if(a[i]==1)X=X.subtract(num[i]);
            else if(a[i]==2)X=X.add(num[i]);
            else if(a[i]==3)X=X.divide(num[i]);
            else X=X.multiply(num[i]);
        }
        System.out.println(X);
    }
}
