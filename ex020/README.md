Exercice 020 : Inverser une chaîne

Structure attendue du dossier:

```
ex020/
└── pw_reverse_string.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers une chaîne de caractères en paramètre
- La fonction doit inverser l'ordre des caractères dans la chaîne (le premier devient le dernier, etc.)
- La modification doit être effectuée directement dans la chaîne originale (pas de création d'une nouvelle chaîne)
- La fonction ne doit pas retourner de valeur
- Si la chaîne est NULL ou vide, la fonction ne doit rien faire
- Le caractère de fin de chaîne '\0' doit rester à la fin

Prototype:

```c
void pw_reverse_string(char *str);
```

Resultat attendu:

```
$> ./a.out
Avant: "hello"
Après: "olleh"
Avant: "Powercoders"
Après: "sredocrewop"
Avant: "a"
Après: "a"
Avant: ""
Après: ""
$>
```
