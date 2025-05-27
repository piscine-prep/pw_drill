Exercice 018 : Division avec pointeurs

Structure attendue du dossier:

```
ex018/
└── pw_divide.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend trois pointeurs vers des float en paramètres
- Le premier paramètre (a) est le dividende
- Le deuxième paramètre (b) est le diviseur
- Le troisième paramètre (r) est où stocker le résultat de la division a / b
- La fonction doit calculer *a / *b et stocker le résultat dans \*r
- La fonction retourne 0 si l'opération s'est bien déroulée
- La fonction retourne 1 si un des pointeurs est NULL
- La fonction retourne 1 si la valeur pointée par b est égale à 0.0 (division par zéro)
- Dans les cas d'erreur, la valeur pointée par r ne doit pas être modifiée

Prototype:

```c
int pw_divide(float *a, float *b, float *r);
```

Resultat attendu:

```
$> ./a.out
Division 10.0 / 2.0 = 5.000000 (retour: 0)
Division 7.5 / 3.0 = 2.500000 (retour: 0)
Division par zéro: retour = 1
Pointeur NULL: retour = 1
Division -8.0 / 2.0 = -4.000000 (retour: 0)
$>
```
