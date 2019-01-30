% a sample prolog program  
% start prolog: 
% prolog 
% load with:
% [test].
% to exit Prolog hit CTRL-D
% hit ';' to view all possibilities
% hit [Return] to quit query

/* prolog relies on a subset of first order predicate logic with an inference 
   engine based on simple backward-chaining

   a prolog program consists of predicates in the form of definite clauses
   called rules (or goals):

  P_0 := P_1, P_2, P_3 ... P_n

  The single term P_0 is the head of the clause (the consequence).

  Predicate(s) to the right of := comprise the body (the antecedent).

  Thus, for a definite clause: 
  P_0 is true if all predicates are true; i.e. 
  (p and q and ... and t) implies u.

  which, by Implication Elimination:
  not(p and q and ... and t) or u.

  which, by de Morgan's Law:
  (not p) or (not q) or  ... (not t) or u.

  The above statement is a Horn clause, which is a disjuntion of literals with 
  at most one positive literal. A Prolog program is a series of Horn clauses:
  (not p) or (not q) or  ... (not t) or u.

  A Prolog program is a series of goals that the underlying inference engine 
  attempts to satisfy. For each goal, when all P_1 ... P_n are true, then P_0 
  is true.

  Prolog uses resolution to reduce the goals. Resolution is applied in order, 
  from the first to the last goal:

     p v q
    ~p v r
    -----------
    :   q v r


  A goal that cannot be proven is assumed false (closed world assumption).

  A clause without a body is a fact (i.e. a single predicate).

  A clause without a head is a query.

  It is possible to enter facts interactively; e.g.

      asserta(parent(chester,irvin)).

  But facts are more easily entered from a file.
 
  The order in which facts are listed is irrelevant, but like facts (predicates)
  should be contiguous.

  Rules, however, are tested in the order entered (top to bottom). 

  Prolog variables must be upper-case and predicates must begin with a
  lower-case letter  */


% THE FACTS 

% all male predicates should be entered together
% This fact is read as "chester is a male."
male(chester).
male(ron).
male(ken).
male(charlie).
male(irvin).

female(sharon).
female(nora).
female(elizabeth).
female(mildred).
female(shirley).

% predicates with two variables are read left to right
% this fact is read as "chester is the parent of irvin."
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

% RULES are implications with variables 
% This rules reads: "If X is the parent of Y and X is male then X is Y's father"
% OR: "X is Y's father if X is Y's parent AND X is male" 
father(X,Y):- parent(X,Y), male(X).

% These rules read as: "X is Y's close relative if X is the parent of Y 
closeRelative(X,Y) :- parent(X,Y).
closeRelative(X,Y) :- sibling(X,Y).

% This combined rule is logically equivalent.  
% closeRelative(X,Y) :- parent(X,Y);parent(Y,X);sibling(X,Y).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).

% what would replacing the above rule with this rule do?
% ancestor(X,Y) :- ancestor(Z,Y), parent(X,Z).

% sibling
sibling(X,Y) :- parent(Z,X), parent(Z,Y).

% this does not return dups since sibling sibling(A,A) returns false
cousin(X,Y) :- parent(W,X), parent(Z,Y), sibling(W,Z).

% the ; is a disjunction 
human(X) :- female(X);male(X).

% THE QUERIES
 
% Queries are entered from the prolog interactive prompt:   |-? 
% After executing a query, press [Return] to end or ; to display more results
% Query examples:
% 
% This query is read as "Who is a female?"
% |-? female(X). 

% This query is read as "Is elizabeth a close relative of ken?"
% |-? closeRelative(elizabeth,ken).

% This query is read as "Who are the descendants of irvin?"
% |-? ancestor(irvin,Y).
