Exercice 019 : Division et modulo ultimes

Structure attendue du dossier:

```
ex019/
└── pw_ultimate_div_mod.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend deux pointeurs vers des int en paramètres
- La fonction doit diviser la valeur pointée par le premier paramètre par la valeur pointée par le second paramètre
- Le résultat de la division entière doit être stocké dans l'int pointé par le premier paramètre
- Le résultat du reste de la division (modulo) doit être stocké dans l'int pointé par le second paramètre
- La fonction ne doit pas retourner de valeur
- La fonction doit modifier directement les valeurs aux adresses données
- Pas besoin de vérifier si les pointeurs sont NULL ou si le diviseur est zéro

Prototype:

```c
void pw_ultimate_div_mod(int *a, int *b);
```

Resultat attendu:

```
$> ./a.out
Avant: a=17, b=5
Après: a=3, b=2
Avant: a=20, b=6
Après: a=3, b=2
Avant: a=42, b=7
Après: a=6, b=0
$>
```
