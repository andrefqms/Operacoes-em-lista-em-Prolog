%----------------------------------------------------                                           	    	                	                                             		
%   Biblioteca de Predicados Prolog      		                                             		
%   OPERANDO EM LISTAS      	                                              		 
%----------------------------------------------------

lista([]).			%  Um termo é uma lista se unifica  
lista([_|_]).            		%  com uma destas duas estruturas.

cons(X,Y,[X|Y]).		%  Constroi (ou decompõe) uma lista.

membro(X,[X|_]).   		%  X é membro de uma lista se X é a 
membro(X,[_|Y]):-		%  cabeça da lista.  Ou então se X é
	membro(X,Y).	%  membro do corpo da lista.

conc([],L,L).      		%  A lista vazia concatenada com qualquer lista resulta
conc([X|L1],L2,[X|L3]):-	%  nesta propria lista.  A concatenação de duas listas
	conc(L1,L2,L3).   	%  não vazias é a cabeça da primeira lista seguida da
			%  concatenação de seu corpo com a segunda lista.
membro1(X,L):-
	conc(_,[X|_],L).	%  membro/2 em função de conc/3.
	
remover(X,[X|C],C).	%  É possível remover um elemento X de uma lista onde
remover(X,[Y|C],[Y|D]):-	%  X é a cabeça.  Se X não é a cabeça da lista, então
	remover(X,C,D).   	%  X deve ser removido do corpo da lista.

inserir(X,L,L1):-		%  inserir/3 em função de remover/3.
	remover(X,L1,L).	%  A inserção é sempre feita na cabeça de L.

membro2(X,L):-     		%  membro/2 em função de remover/3.
	remover(X,L,_).	

inverter([],[]).		%  A inversão de uma lista vazia é a prória lista vazia.
inverter([X|Y],Z):-		%  A inversão de uma lista não-vazia é a inversão de seu
	inverter(Y,Y1),    	%  corpo e a concatenação deste corpo invertido com a
	conc(Y1,[X],Z).    	%  cabeça da lista original.

invert(X,Y):-            		%  invert/2 é uma variante mais eficiente do predicado
	inv([],X,Y).       	%  inverter/2.  Este apresenta complexidade quadrática,
inv(L,[],L).             		%  enquanto que invert/2 possui complexidade linear.
inv(L,[X|Y],Z):-         	%  Esta maior eficiência é obtida com o uso do predicado
	inv([X|L],Y,Z).     	%  auxiliar inv/3.

sublista(S,L):-           	%  S é sublista de L se L pode ser decomposta em duas
	conc(_,L1,L),     	%  listas, uma das quais é L1, e L1 pode ser decomposta
     	conc(S,_,L1).       	%  em outras duas listas, uma das quais é S.

permutar([],[]).		%  A permutação da lista vazia é a própria lista vazia.
permutar([X|L],P):-      	%  A permutação de uma lista não-vazia é a inserção da
	permutar(L,L1),    	%  cabeça desta lista na lista obtida pela permutação  
	inserir(X,L1,P).   	%  de seu corpo.

tamanho([],0).           	%  O tamanho de uma lista vazia é zero.  O tamanho de
tamanho([_|R],N):-		%  uma lista não-vazia é obtido acrescentando-se uma
	tamanho(R,N1),     	%  unidade ao tamanho de seu corpo.
	N is N1 + 1.

prop(X,[X|_]):- 		%  Este predicado identifica em uma lista um elemento
	p(X).   	  	%  que apresenta uma determinada propriedade, aqui dada
prop(X,[_,Y]):-          	%  por p(X).  
	prop(X,Y).

enesimo(1,X,[X|_]).      	%  Este predicado devolve em X o enésimo elemento de
enesimo(N,X,[_|Y]):-      	%  uma lista.  Pode ser usado no sentido inverso para
	enesimo(M,X,Y),   	%  informar a posição de um determinado elemento
	N is M + 1.        	%  na lista.

soma([],0).              		%  A soma dos elementos de uma lista de números é 
soma([X|Y],S):-          	%  obtida somando o valor da cabeça á soma dos 
	soma(Y,R),         	%  elementos do corpo da lista.
	S is R + X.   

produto([],0).           		%  O produto de uma lista é obtido com o uso de
produto([X],X).          	%  um predicado auxiliar, prod/2, necessario para
produto(L,P):-            	%  isolar a aplicação do elemento neutro da
	prod(L,P).         	%  multiplicação do caso em que se pede diretamente
prod([],1).               		%  o produto de uma lista vazia.
prod([X|Y],P):-
	prod(Y,Q),
	P is Q * X.

intersec([X|Y],L,[X|Z]):- 	%  Este predicado computa a intersecção de duas
	membro(X,L),       	%  listas, resultando numa terceira que contém os
	intersec(Y,L,Z).    	%  elementos que estão presentes simultaneamente
intersec([_|X],L,Y):-     	%  nas duas primeiras listas.
	intersec(X,L,Y).
intersec(_,_,[]).

corr(X,Y,[X|_],[Y|_]).    	%  Este predicado é verdadeiro se X e Y ocupam
corr(X,Y,[_|U],[_|V]):-   	%  a mesma posição em suas respectivas listas.
	corr(X,Y,U,V).

ultimo(X,[X]).           		%  Este predicado fornece em X o último elemento 
ultimo(X,[_|Y]):-       		%  de uma lista.
	ultimo(X,Y).

segue(X,Y,[X,Y|_]).      	%  X e Y estão em seqüência em uma lista se são 
segue(X,Y,[_|L]):-       	%  respectivamente o primeiro e segundo elentos da
	segue(X,Y,L).      	%  lista ou se estão em seqüência no corpo da lista.

normal(X,Y):-             	%  Produz a versão "plana" de uma lista que pode
	norm(X,[],Y).       	%  conter recursivamente outras listas como elementos.
                         		%  Por exemplo:
norm([],L,L).             	%
norm(A,L,[A|L]):-         	%   	?-normal([a,[b,c],[[d],e]],X).
	var(A),!.          	%  	X = [a,b,c,d,e]
norm(A,L,[A|L]):-         	%
	not (lista(A)).     	%  normal/2 chama o predicado auxiliar norm/3, que é
norm([H|T],Aux,Res):-     	%  quem faz realmente todo o trabalho.
	norm(T,Aux,Aux1),
	norm(H,Aux1,Res).

subst(_,[],_,[]).         		%  Substitui todas as ocorrência de um elemento X em 
subst(X,[X|CX],Y,[Y|CY]):-	%  uma lista por outro elemento Y, gerando uma nova  
	!, subst(X,CX,Y,CY).%  lista com essa substituição feita.
subst(X,[N|CX],Y,[N|CY]):-
	subst(X,CX,Y,CY).

max([X],X).               	%  Calcula o maior elemento de uma lista numérica.
max([X|Y],M):-            	%  Notar a semelhança com o predicado min/2, a 
	max(Y,N),          	%  seguir, e o emprego da construção "if then else" 
     	(X>N -> M=X; 	%  dada por (A -> B ; C).
	M=N). 	

min([X],X).              		%  Calcula o menor elemento de uma lista.
min([X|Y],M):-
	min(Y,N),
	(X<N -> M=X; M=N).

merg([],X,X).           		%  Intercala duas listas aleatoriamente, resultando 
merg([X|Y],[],[X|Y]).     	%  em uma terceira lista.  Por exemplo, a consulta
merg([X|Y],[U|V],[X|Z]):- 	%  ?-merg([1,2,3],[a,b],X) irá produzir os resultados
	merg(Y,[U|V],Z).    	%  X = [1,a,2,3,b]; X = [a,1,2,b,3]; ...
merg([X|Y],[U|V],[U|Z]):-
	merg([X|Y],V,Z).
