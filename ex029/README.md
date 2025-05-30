Exercice 029 : Trouver le premier chiffre

Structure attendue du dossier:

```
ex029/
└── pw_find_digit.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers une chaîne de caractères en paramètre
- La fonction doit parcourir la chaîne pour trouver le premier chiffre (0-9)
- La fonction retourne un pointeur vers le premier chiffre trouvé dans la chaîne
- Si aucun chiffre n'est trouvé, la fonction retourne un pointeur vers le début de la chaîne originale
- Si la chaîne est NULL, la fonction retourne NULL
- Les espaces, lettres et caractères spéciaux ne sont pas considérés comme des chiffres
- Seuls les caractères '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' sont des chiffres

Prototype:

```c
char *pw_find_digit(char *str);
```

Résultat attendu:

```
$> ./a.out
Chaine: "Hello123World"
Premier chiffre trouve a partir de: "123World"
Chaine: "abc def ghi"
Aucun chiffre, retour au debut: "abc def ghi"
Chaine: "42School"
Premier chiffre trouve a partir de: "42School"
Chaine: "Test9End"
Premier chiffre trouve a partir de: "9End"
Chaine: ""
Chaine vide, retour au debut: ""
Test NULL: OK
$>
```
