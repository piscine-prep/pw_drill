Exercice 006 : Compter de N à 0

Structure attendue du dossier:

```
ex006/
└── pw_count_reverse.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui prend un unsigned int en paramètre
- La fonction doit compter de ce nombre jusqu'à 0 (inclus) dans l'ordre décroissant
- Chaque nombre doit être affiché sur une ligne séparée
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Chaque ligne doit se terminer par un retour à la ligne

Prototype:

```c
void pw_count_reverse(unsigned int n);
```

Resultat attendu:

```
$> ./a.out
3
2
1
0
$>
```

Avec d'autres nombres:

```
$> ./a.out
10
9
8
7
6
5
4
3
2
1
0
$>
```

```
$> ./a.out
0
$>
```
