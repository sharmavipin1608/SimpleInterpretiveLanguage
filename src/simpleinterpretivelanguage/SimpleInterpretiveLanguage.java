/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package simpleinterpretivelanguage;

import java.io.FileInputStream;
import java.util.Scanner;
import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;

/**
 *
 * @author vipinsharma
 */
public class SimpleInterpretiveLanguage {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try
        {
            Scanner scan = new Scanner(System.in);
            System.out.println("Enter the name of the file : ");
            String fileName = scan.next();
            
            if(fileName.endsWith(".s")){
                ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(fileName));
                SILLexer lexer = new SILLexer(input);

                CommonTokenStream tokens = new CommonTokenStream(lexer);
                SILParser parser = new SILParser(tokens);
                parser.prog();
            }
            else{
                System.out.println("Invalid file extension");
                System.exit(0);
            }
            
        }
        catch(Exception Ex){
            System.out.println(Ex.getMessage());
        }
    }
    
}
