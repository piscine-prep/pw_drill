Exercice 02 : Compter les lettres E

Structure attendue du dossier:

```
ex02/
└── pw_count_e.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui compte le nombre d'occurrences de la lettre "e" (minuscule) dans une chaîne de caractères
- La fonction doit parcourir entièrement la chaîne jusqu'au caractère de fin '\0'
- Seule la lettre "e" minuscule doit être comptée, pas le "E" majuscule
- Si la chaîne est vide ou NULL, la fonction doit retourner 0
- La fonction retourne le nombre total d'occurrences trouvées

Prototype:

```c
int pw_count_e(char *str);
```

Resultat attendu:

```
$> ./a.out
Test avec "Hello": 1
Test avec "excellence": 4
Test avec "HELLO": 0
Test avec "": 0
$>
```
