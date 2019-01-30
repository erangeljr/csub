% sample prolog program
% load with: 
% $ prolog
% [test].     <= DO NOT TYPE THE .pl FILE EXTENSION  
% exit with CTRL-D

/* a prolog program consists of predicate clauses of the form:

  P_0 := P_1, P_2, P_3 ... P_n

  P_0 , a single term, is the head of the clause.

  One or more terms to the right of := comprise the body of the clause.

  A headed clause is a rule: P_0 is true if P_1 ... P_n are true 
  To show P_0, show P_1 and show P_2 and show P_3 and ... and show P_n
 
  A headed Horn claus is a disjunction of literals with one positive literal:
     ~p v ~q v ... v ~t v u  
  which is equivalent to: 
     (p ^ q ^ ... ^ t) -> u.

  Such Horn clauses are called definite clauses.
  A bodyless Horn clause is a fact (empty right hand side).
  A headless Horn clause is a goal/query clause (empty left hand side).

  Definite clauses are useful in a logic language because the resolution of a
  goal clause (a query) and a definite clause (a rule) is again a goal clause.

  Prolog is based on the closed world assumption - anything that cannot be 
  proven true is false.

*/

% RULES
% Prolog rules are based on predicate logic

% Variables whose first appearance is on the left hand side of the clause have
% implicit universal quantifiers.
%
% Variables whose first appearance is on the right hand side of the clause
% have implicit existential quantifiers.
%
% The implication is read right to left, where the comma is interpreted as AND

teaches(P,S) :- instructor(P,C), enrolled(S,C).

% In implication form:
% if P is the instructor of class and S is enrolled in the
% class C then P teaches S.
% reads:
% There is an instructor P who teaches class C and there is a student S who
% is enrolled in class C such that professor P teaches student S.

%
% In predicate logic:
% p (professor), s (students),  c (classes)
% universe: all professors, all students, all classes
% T(p,s) : professor p teaches student s
% I(p,c) : professor p is the instructor of class c
% E(s,c) : student s is enrolled in class c

% Ap As Ec (I(p,c) ^ E(s,c))

% you also need some facts - i.e. bodyless clauses:
instructor(spade,ee300).
enrolled(joe,ee300).

% now you can run this query:
% |-? teaches (X, joe).

% will return all the teachers of the classes joe is enrolled in

/*
  Syntax and Technical Issues.
  It is possible to enter facts interactively; e.g.

  asserta(parent(chester,irvin)).

  But facts and rules are more easily entered from a file.
 
  The order in which facts and rules are listed is irrelevant, but like 
  predicates should be contiguous.

  Variables must be uppercase. Do not use dashes in predicate names.

  Rules are tested in the order entered (top to bottom). 
  After loading the facts and rules, run queries in the interactive interpretor.
  Queries must end with '.' and cannot have white spaces
  hit ';' to continue query
  hit [CR] to end query
 */

% This fact is read as "chester is the parent of irvin."
parent(chester,irvin).
parent(chester,clarence).
parent(chester,mildred).
parent(irvin,ron).
parent(irvin,ken).
parent(clarence,shirley).
parent(clarence,sharon).
parent(clarence,charlie).
parent(mildred,mary).
parent(ken,nora).
parent(ken,elizabeth).

sister(sally,elizabeth).


% THE RULES 

% you must define a NOT function since prolog by nature doesn't use not
not(P) :- ( call(P) -> fail ; true ).

% This rule is read as "X is Y's father if X is Y's parent AND X is male" 
father(X,Y):- parent(X,Y), male(X).

% this rule will make male the default unless explicitly true for female 
male(X) :- not(female(X)).

female(sharon).
female(nora).
female(elizabeth).
female(shirley).
female(mildred).

% enter male facts now... 
male(chester).
male(ron).
male(ken).
male(charlie).
male(irvin).


% this rule will be satisfied by "Ron is the sibling of Ron"
% sibling(X,Y) :- parent(Z,X), parent(Z,Y).

% this rule will be not allow Ron to be his own sibling
sibling(X,Y):- parent(Z,X), parent(Z,Y), \==(X,Y).


% This rule is read as: "X is Y's close relative if X is the parent of Y 
closeRelative(X,Y) :- parent(X,Y).
closeRelative(X,Y) :- parent(Y,X).
closeRelative(X,Y) :- sibling(X,Y).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).

% what would replacing the above rule with this rule do?
% ancestor(X,Y) :- ancestor(Z,Y), parent(X,Z).

% this rule returns Ron is a cousin of Ron 
cousin(X,Y) :- parent(W,X), parent(Z,Y).

% THE QUERIES
 
% Queries/goals are entered from the prolog interactive prompt:   |-? 
% After executing a query, press [Return] to end or ; to resume the inference
% engine and display more results

% Query examples:
% 
% This query is read as "Who is a female?"
% |-? female(X). 

% This query is read as "Is elizabeth a close relative of ken?"
% |-? closeRelative(elizabeth,ken).

% This query is read as "Who are the descendants of irvin?"
% |-? ancestor(irvin,Y).
