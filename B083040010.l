%{
#include<stdio.h>
unsigned charCount = 1, lineCount = 1;
%}

%option caseless
reserved absolute|and|begin|break|case|const|continue|do|else|end|for|function|if|mod|nil|not|object|of|or|program|then|to|var|while|array|integer|double|write|writeln|string|float|read|array|integer|double|write|writeln|string|float
space [ ]
eol \n
a :=
b ==
c <=
d >=
symbol {a}|{b}|{c}|{d}|[;|\(|\)|:|>|<|=|\[|\]|+|-|*|/|.|,]
identifiers [a-z|_](?:[a-z0-9_]{0,14})
invalid_identifiers [0-9|^|#|$|@|!|`|%|^|&|/][0-9a-z_|^|#|$|@|!|`|%|^|&|/]*|[a-z|_][0-9a-z_]{15,}|[a-z_][a-z0-9#$@!`%^&/]*[#$@!`%^&/][a-z0-9#$@!`%^&/]*
valid_R -?(?:[0-9]+[.]?[0-9]*)(?:[Ee][+|-][1-9]+)?
invalid_R [0][0][.][0-9]+|[0-9]+[.][0-9]*[0][0]|[0][0-9]+[.][0-9+]|[.][0-9]+|[0-9]+[.]|[0][0][0-9]*
quoted_string '([^'\n]|''){0,30}'
invalid_quoted_string ('([^'\n; ])*)|([^'\n; ]*')|('([^'\n]|''){31,}')
comment \(\*([^\(]*)\*\)
one_side_comment (\(\*[^\n \*\);]*)|([^\n \(\*]*\*\))
%%

{reserved} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"reserved word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{space} {
	charCount++;
}
{eol} {
	lineCount++; 
	charCount = 1;
}
{symbol} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"symbol\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_R} {
	printf("Line: %d, 1st char: %d, \"%s\" is a invalid \"real constant\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{valid_R} {
	printf("Line: %d, 1st char: %d, \"%s\" is an valid \"real constant\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_identifiers} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{identifiers} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{quoted_string} {
	printf("Line: %d, 1st char: %d, \"%s\" is a valid \"string\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_quoted_string} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"string\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{comment} {
	int i, flag = 0;
	for (i = 0; i <= yyleng-3; i++)
	{
		if (yytext[i] == '*' && yytext[i+1] == ')')
			flag = 1;
	}
	if (flag == 1)
		printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"comment\".\n", lineCount, charCount, yytext);
	else
		printf("Line: %d, 1st char: %d, \"%s\" is a valid \"comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{one_side_comment} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}

%%

int main()
{
	yylex(); 
	return 0;
}
