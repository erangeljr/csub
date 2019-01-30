% cs 300 : an example of using the Prolog inference engine in language
% processing

% filename: scan.pl
% run by:
% prolog
% [scan].
% go.
 
% donna meyers  2/2006   
% this is a scanner for a simple programming language
% the axioms and rules are derived from the syntax of the language (see BNF.txt)
% thus, the scanner is a BNF grammar expressed in logical inference rules
% logical inference determines if a given program satisfies the grammar or not
%
% the scanner will recognize:
%    a) character strings of the form "abcde"   (string literals)
%    b) character constants of the form 'a' or #\a  (character literals)
%    c) fixed point numerals of the form 123.45  (floating point)
%     <= and >= can be entered as =< and =>.
%------------------------------------------------------------------------------

go :- nl,write('>>> A Simple Scanner <<<'), nl, nl,
      write('Enter name of source file:  '), nl, getfilename(File), nl, 
      see(File), scan(Tokens), seen, write('Scan successful'), nl, nl, 
      write(Tokens), nl.

% a Prolog rule is a predicate clause, ex:
% this rule:
% lower(C) :- 97=<C,C=<122.  
% means this in predicate logic:
% Ec P(c) ^ Q(c) -> lower(c), where  P: c >= 97 ,  Q: c =< 122 , universe: 0-127
 

% the inference engine attempts to satisfy the rules one at a time until all 
% are satisfied, in which case the syntax of the program is verified correct
 
% if, before this occurs a rule cannot be satisfied, the program fails

% thus, a Prolog program is one big proof using logical rules of inference
 
lower(C) :- 97=<C,C=<122.       % a-z
upper(C) :- 65=<C,C=<90.        % A-Z
digit(C)  :- 48=<C,C=<57.       % 0-9

% Prolog facts are the axioms

space(32).     tabch(9).      period(46).      slash(47).     
endline(10).   endfile(26).   endfile(-1).     linefeed(13).
dquote(34).    squote(39).    pound(35).       backslash(92).

% a Prolog rule is an inference of the form : p1 ^ p2 ^ p3 ... p4 -> p0 
% where p0 is the head; e.g.  (whitespace(c)  
% if the consequent is satisfied then p0 is true by modus ponens 
whitespace(C) :- space(C) ; tabch(C) ; endline(C) ; linefeed(C).

idchar(C) :- lower(C) ; digit(C).
strchar(C) :- lower(C).  

filechar(C) :- lower(C) ; upper(C) ; digit(C) ; period(C) ; slash(C).

%------------------------------------------------------------------------------

getfilename(W) :- get0(C),restfilename(C,Cs),name(W,Cs).
  restfilename(C,[C|Cs]) :- filechar(C),get0(D),restfilename(D,Cs).
  restfilename(C,[]).

%---------  Scanner  ----------------------------------------------------------

scan([T|Lt]) :- tab(4), getch(C), gettoken(C,T,D), restprog(T, D, Lt), !.

getch(C) :- get0(C), (endline(C),nl,tab(4) ; endfile(C),nl ; linefeed(C); put(C)).

restprog(eop, C, []).        % end of file reached with previous character
restprog(T,   C, [U|Lt]) :- gettoken(C, U, D), restprog(U, D, Lt).

restid(C, [C|Lc], E) :- idchar(C), getch(D),restid(D,Lc,E).
restid(C, [],     C).    % end identifier if C is not id character

%   note: will accept character strings of the form "abcde"  
reststr(C, [C|Lc], E) :- strchar(C), getch(D),reststr(D,Lc,E).
reststr(C, [],    D) :- dquote(C), getch(D).

%  note: will accept floating point numbers of the form 123.345
restnum(C, [C|Lc], E) :- digit(C), getch(D), restnum(D, Lc, E).
restnum(C, [C|Lc], E) :- period(C), getch(D), restnum(D, Lc, E).
restnum(C, [],     C).    % end number if C is not digit

gettoken(C, eop, 0) :- endfile(C).  
gettoken(C, T, E) :- double(C,U),getch(D),(pair(C,D,T),getch(E) ; T=U,E=D).
gettoken(C, T, D) :- single(C,T), getch(D).

%  note: will accept character constants of the form #\a 
gettoken(C,T,F) :-  pound(C), getch(D), backslash(D), getch(E), 
                    strchar(E), getch(F), name(I,[E]),(T=chr(I)).

%   note: will accept single character constants of the form 'a'   
gettoken(C,T,F) :-  squote(C), getch(D), strchar(D), strchar(D),getch(E), 
                    getch(F), name(I,[D]),(T=chr(I)).

%  note: will accept character strings of the form "abcde"   
gettoken(C,T,F) :-  dquote(C), getch(D), getch(E),reststr(E, Lc, F),
                   name(I,[D|Lc]),(T=str(I)).

gettoken(C, T, E) :- lower(C), getch(D), restid(D, Lc, E),   
                     name(I, [C|Lc]), (reswd(I),T=I ; T=ide(I)).

%  note: will accept fixed point numerals of the form 123.45 
gettoken(C, num(N), E) :- digit(C), getch(D), restnum(D, Lc, E),  
                          name(N, [C|Lc]). 

gettoken(C, T, E) :- whitespace(C), getch(D), gettoken(D,T,E).
gettoken(C, T, E) :- write('Illegal charater: '), put(C), nl, abort.

% these are axioms also

reswd(program).  reswd(is).       reswd(begin).    reswd(end).   
reswd(var).      reswd(integer).  reswd(boolean).  reswd(read). 
reswd(write).    reswd(while).    reswd(do).       reswd(if).    
reswd(then).     reswd(else).     reswd(skip).     reswd(or).  
reswd(and).      reswd(true).     reswd(false).    reswd(not). 
reswd(repeat).    reswd(until).   reswd(return). 

single(40,lparen).   single(41,rparen).    single(42,times).
single(43,plus).     single(44,comma).     single(45,minus).
single(47,divides).  single(59,semicolon). single(61,equal).

% note: "<=" and ">=" can also be entered as "=<" and "=>".
double(58,colon).    double(60,less).      double(62,grtr).  
double(58,colon).    double(60,less).      double(62,grtr).  
double(61,equal).

pair(58,61,assign).       % :=
pair(60,61,lteq).         % <=
pair(61,60,lteq).         % =<
pair(60,62,neq).          % <>
pair(62,61,gteq).         % >=
pair(61,62,gteq).         % =>

%-----------------------------------------------------------------------
