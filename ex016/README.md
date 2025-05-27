Exercice 016 : Modifier une valeur via pointeur

Structure attendue du dossier:

```
ex016/
└── pw_set_value.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers un int en paramètre
- La fonction doit toujours assigner la valeur 42 à l'adresse pointée par le paramètre
- La fonction ne doit pas retourner de valeur
- La fonction doit modifier directement la valeur à l'adresse donnée
- Pas besoin de vérifier si le pointeur est NULL

Prototype:

```c
void pw_set_value(int *ptr);
```

Resultat attendu:

```
$> ./a.out
Avant: 10
Après: 42
Avant: -5
Après: 42
Avant: 0
Après: 42
$>
```
