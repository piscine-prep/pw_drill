Exercice 022 : Inverser un tableau

Structure attendue du dossier:

```
ex022/
└── pw_reverse_array.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un tableau d'entiers et sa taille en paramètres
- La fonction doit inverser l'ordre des éléments dans le tableau (le premier devient le dernier, etc.)
- La modification doit être effectuée directement dans le tableau original (pas de création d'un nouveau tableau)
- La fonction ne doit pas retourner de valeur
- Si le tableau est NULL ou si la taille est 0 ou négative, la fonction ne doit rien faire
- Un tableau d'un seul élément reste inchangé

Prototype:

```c
void pw_reverse_array(int *arr, int size);
```

Resultat attendu:

```
$> ./a.out
Avant: [1, 2, 3, 4, 5]
Après: [5, 4, 3, 2, 1]
Avant: [10, -5, 0, 42]
Après: [42, 0, -5, 10]
Avant: [7]
Après: [7]
Avant: []
Après: []
$>
```
