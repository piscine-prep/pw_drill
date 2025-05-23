Exercice 005 : Compter de 0 à N

Structure attendue du dossier:

```
ex005/
└── pw_count_to_n.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui prend un unsigned int en paramètre
- La fonction doit compter de 0 jusqu'à ce nombre (inclus)
- **IMPORTANT: Le paramètre n est toujours compris entre 0 et 9 (n < 10)**
- Chaque nombre doit être affiché sur une ligne séparée
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Chaque ligne doit se terminer par un retour à la ligne

Prototype:

```c
void pw_count_to_n(unsigned int n);
```

Resultat attendu:

```
$> ./a.out
0
1
2
3
$>
```

Avec d'autres nombres:

```
$> ./a.out
0
1
2
3
4
5
6
7
8
9
$>
```

```
$> ./a.out
0
$>
```
