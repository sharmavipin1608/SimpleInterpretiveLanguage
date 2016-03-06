grammar SIL;

@header {
	package simpleinterpretivelanguage;
	import java.util.HashMap;
	import java.util.Scanner;
}

@lexer::header {
	package simpleinterpretivelanguage;
}

@members {
	HashMap memory = new HashMap();
}

prog:   stat+ ;
                
stat	:	COMMENT NEWLINE
	|	'PRINT' print NEWLINE
	|	'PRINTLN' {System.out.println();} print  NEWLINE
	|	'INTEGER' integer NEWLINE
	|	'INPUT' input NEWLINE
	|	'LET' let NEWLINE
	|	'END' { System.exit(0); } 
	;
	
print	:	expr {System.out.print($expr.value);}
	|	STRING {System.out.print($STRING.text);}
	;

integer	:	identifier (',' identifier)* 	
	;

identifier
	:	ID 
		{
			Integer v = (Integer)memory.get($ID.text);
			if ( v==null ){
				memory.put($ID.text,new Integer(0));
			}
			else{
				System.err.println("Duplicate INTEGER : "+$ID.text);
			}
		}
	;
	
let	:	ID '=' expr 
		{
			Integer v = (Integer)memory.get($ID.text);
			if ( v!=null ){
				memory.put($ID.text, new Integer($expr.value));
			}
			else{
				System.err.println("Undefined variable "+$ID.text);
			}
		}
	;
	
input	:	inputidentifier (',' inputidentifier)*
	;
	
inputidentifier
	:	ID 
		{
			Integer v = (Integer)memory.get($ID.text);
			if ( v!=null ){
				Scanner scanner = new Scanner(System.in);
				System.out.println("Enter value for "+$ID.text+" : ");
				Integer val = scanner.nextInt();
				memory.put($ID.text,val);
			}
			else{
				System.err.println("Undefined variable "+$ID.text);
			}
		}	
	;
	
expr returns [int value]
    :   e=multExpr {$value = $e.value;}
        (   '+' e=multExpr {$value += $e.value;}
        |   '-' e=multExpr {$value -= $e.value;}
        )*
    ;

multExpr returns [int value]
    :   e=atom {$value = $e.value;} 
    	(	'*' e=atom {$value *= $e.value;}
    	|	'/' e=atom {$value /= $e.value;}
    	)*
    ; 

atom returns [int value]
    :   INT {$value = Integer.parseInt($INT.text);}
    |   ID
        {
        Integer v = (Integer)memory.get($ID.text);
        if ( v!=null ) $value = v.intValue();
        else System.err.println("Undefined variable "+$ID.text);
        }
    |   '(' e=expr ')' {$value = $e.value;}
    ;

ID  :   ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ;

INT :   '0'..'9'+ ;

NEWLINE:'\r'? '\n' ;

WS  :   (' '|'\t')+ {skip();} ;

STRING
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;
    
COMMENT
    :   '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}
    |   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;
