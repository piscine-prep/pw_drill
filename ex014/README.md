Exercice 014 : Casting de types

Structure attendue du dossier:

```
ex014/
└── pw_casting.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un float en paramètre
- La fonction doit effectuer différents castings et retourner la somme de tous les résultats
- La fonction retourne la somme : (int)float + (char)float + round(float)
- Pour l'arrondi, utiliser la règle : si la partie décimale >= 0.5, arrondir vers le haut, sinon vers le bas

Prototype:

```c
int pw_casting(float f);
```

Resultat attendu:

```
$> ./a.out
Test avec 65.7: 198
Test avec 120.3: 360
Test avec 0.0: 0
Test avec 300.5: 901
$>
```
