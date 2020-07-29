rhyme(X,X).
poem([]):-write("Unknown Poem").
poem([H|T]):-count_words([H|T],N),
             (mod(N,7)=\=0->write("Unknown poem");
             (N=:=7->(haiku([H|T])->write("Haiku");write("Unknown Poem.")));
             (N=:=14->(doha([H|T])->write("Doha");write("Unknown Poem"));
             (N=:=28->(quartet([H|T])->write("Quartet");(fusion_sonnet([H|T],N)->write("Fusion Sonnet");write("Unknown Poem"))));
             (fusion_sonnet([H|T],N)->write("Fusion Sonnet");write("Unknown Poem")))).



/*count_words predicate counts the number of words in a given list*/
count_words([],0).
count_words([_|T],N):-count_words(T,N1),N is N1+1.


/*haiku predicate checks if given list is haiku*/
haiku([]).
haiku([H|T]):-check_rhyme(H,T),haiku(T).

/*check_rhyme predicate checks if the first argument does not rhyme with any word in the second argument, which is a list*/
check_rhyme(_,[]).
check_rhyme(X,[H|T]):-not(rhyme(X,H)),not(rhyme(H,X)),check_rhyme(X,T).

/*doha predicate checks if given list is doha*/
doha([H|T]):-leng([H|T],N),N=14,get_word([H|T],4,X1),get_word([H|T],7,X2),get_word([H|T],11,X3),get_word([H|T],14,X4),rhyme(X1,X3),rhyme(X2,X4).

/*quartet predicate checks if given list is quartet*/
quartet([H|T]):-leng([H|T],N),N=28,get_word([H|T],1,X1),get_word([H|T],14,X2),get_word([H|T],15,X3),get_word([H|T],28,X4),rhyme(X1,X3),rhyme(X2,X4).

/*get_word predicate stores in the third argument the Nth(second argument) word in the given list(first argument)*/
get_word([H|_],1,H).
get_word([_|T],N,X):-N1 is N-1,get_word(T,N1,X).

/*leng predicate stores the length of the list(first argument) in the second argument*/
leng([],0).
leng([_|T],N):-leng(T,N1),N is N1+1.

/*sublist predicate finds the sublist of the list(first argument) from N1(second argument) of length N2(third argument) and stores it in the fourth argument*/
sublist([X|_],1,1,[X]).
sublist([],_,_,[]).
sublist([H|T1],1,L,[H|T2]):-
       L>1,
       L1 is L-1,
       sublist(T1,1,L1,T2).
sublist([_|T1],S,L,T2):-
       S > 1,
       S1 is S-1,
       sublist(T1,S1,L,T2).

/*fusion_sonnet predicate checks if given list is a fusion_sonnet. For a list of odd number of lines,it checks wether the last line is a haiku and then checks the rest lines(which will be even in number) through fusion_sonnet2 predicate.If the list has even number of lines,it directly checks through fusion_sonnet2 predicate*/
fusion_sonnet([H|T],N):-(mod(N,2)=:=1->N1 is N-6,N2 is N-7,sublist([H|T],N1,7,X),haiku(X),sublist([H|T],1,N2,Y),fusion_sonnet2(Y,N2);fusion_sonnet2([H|T],N)).


/*fusion_sonnet2 predicate checks if given list which has even number of lines is a fusion_sonnet or not*/
fusion_sonnet2([H|T],28):-sublist([H|T],1,14,Y),sublist([H|T],15,14,Z),doha(Y),doha(Z).
fusion_sonnet2([H|T],56):-sublist([H|T],1,28,Y),sublist([H|T],29,28,Z),quartet(Y),quartet(Z).
fusion_sonnet2([H|T],42):-sublist([H|T],1,14,Y),sublist([H|T],15,28,Z),doha(Y),quartet(Z).
fusion_sonnet2([H|T],42):-sublist([H|T],1,28,Y),sublist([H|T],29,14,Z),quartet(Y),doha(Z).

fusion_sonnet2([H|T],N):-N1 is N-14,sublist([H|T],1,14,Y),doha(Y),sublist([H|T],15,N1,Z),fusion_sonnet2(Z,N1).
fusion_sonnet2([H|T],N):-N2 is N-28,sublist([H|T],1,28,Y),quartet(Y),sublist([H|T],29,N2,Z),fusion_sonnet2(Z,N2).







