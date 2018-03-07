Cours de Compilation Avancée (M2 Informatique)
==============================================

Projet du cours de 2017 de Compilation Avancée du
M2 Langages et Programmation à Paris 7 - Diderot. 

Le but est de faire un compilateur d'un langage
fonctionnel ("fopix") vers la JVM (utilisation de Jasmin).

2 chemins :
1/ fopix -> javix :
- compilation direct sans optimisation
- possibilité d'explosion de la pile

2/
fopix  -> jakix  : mis en forme A-normal (ANF)
jakix  -> kontix : continuation passing style
kontix -> jakix  : compilation vers jasmin avec optimisation

cf doc/ pour les explications du projet

Utilisation
==============================================
$ make // compilation du projet 
$ ./test.sh // test - vérification des valeurs 

