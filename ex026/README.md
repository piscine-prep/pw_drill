Exercice 026 : Vérifier lettres minuscules

Structure attendue du dossier:

```
ex026/
└── pw_is_lowercase.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers une chaîne de caractères en paramètre
- La fonction doit vérifier si la chaîne ne contient que des lettres minuscules (a-z)
- Les espaces, chiffres, caractères spéciaux ou majuscules invalident la chaîne
- La fonction retourne 1 si la chaîne ne contient que des lettres minuscules
- La fonction retourne 0 dans tous les autres cas (majuscules, chiffres, espaces, caractères spéciaux)
- Si la chaîne est vide ou NULL, la fonction retourne 0
- Seuls les caractères de 'a' à 'z' sont considérés comme des lettres minuscules valides

Prototype:

```c
int pw_is_lowercase(char *str);
```

Resultat attendu:

```
$> ./a.out
Test avec "hello": 1
Test avec "world": 1
Test avec "Hello": 0
Test avec "test123": 0
Test avec "hello world": 0
Test avec "": 0
Test avec "abcdef": 1
Test avec "ABC": 0
Test avec "test!": 0
$>
```
