Exercice 025 : Vérifier si alphabétique

Structure attendue du dossier:

```
ex025/
└── pw_is_alphabetic.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend une chaîne de caractères en paramètre
- La fonction doit vérifier si la chaîne ne contient que des lettres alphabétiques (a-z et A-Z)
- Les espaces, chiffres, caractères spéciaux et signes de ponctuation ne sont pas autorisés
- Si la chaîne ne contient que des lettres, la fonction retourne 1
- Si la chaîne contient au moins un caractère non-alphabétique, la fonction retourne 0
- Si la chaîne est vide, la fonction retourne 1 (une chaîne vide est considérée comme valide)
- Si la chaîne est NULL, la fonction retourne 0

Prototype:

```c
int pw_is_alphabetic(char *str);
```

Resultat attendu:

```
$> ./a.out
Test avec "Hello": 1
Test avec "HelloWorld": 1
Test avec "Hello World": 0
Test avec "Hello123": 0
Test avec "Test!": 0
Test avec "": 1
Test avec NULL: 0
Test avec "ABC": 1
Test avec "abc": 1
Test avec "AbCdEf": 1
$>
```
