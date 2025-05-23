Exercice 011 : Pair ou Impair

Structure attendue du dossier:

```
ex011/
└── pw_pair_impair.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui détermine si un mot contient un nombre pair ou impair de lettres
- La fonction doit parcourir entièrement la chaîne jusqu'au caractère de fin '\0'
- Tous les caractères alphabétiques (a-z et A-Z) sont considérés comme des lettres
- Les espaces, chiffres et caractères spéciaux ne sont pas comptés comme des lettres
- Si le nombre de lettres est pair (y compris 0), la fonction retourne 'P'
- Si le nombre de lettres est impair, la fonction retourne 'I'
- Si la chaîne est NULL, la fonction doit retourner 'N'

Prototype:

```c
char pw_pair_impair(char *str);
```

Resultat attendu:

```
$> ./a.out
Test avec "Hello": I
Test avec "Code": P
Test avec "": P
Test avec "42 School": I
Test avec NULL: N
$>
```
