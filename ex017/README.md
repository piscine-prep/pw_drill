Exercice 017 : Échanger deux valeurs

Structure attendue du dossier:

```
ex017/
└── pw_swap.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend deux pointeurs vers des int en paramètres
- La fonction doit échanger les valeurs pointées par les deux paramètres
- Après l'appel de la fonction, la valeur pointée par le premier paramètre doit contenir l'ancienne valeur du second
- Après l'appel de la fonction, la valeur pointée par le second paramètre doit contenir l'ancienne valeur du premier
- La fonction ne doit pas retourner de valeur
- La fonction doit modifier directement les valeurs aux adresses données
- Pas besoin de vérifier si les pointeurs sont NULL

Prototype:

```c
void pw_swap(int *a, int *b);
```

Resultat attendu:

```
$> ./a.out
Avant: a=5, b=10
Après: a=10, b=5
Avant: a=-3, b=7
Après: a=7, b=-3
Avant: a=0, b=42
Après: a=42, b=0
$>
```
