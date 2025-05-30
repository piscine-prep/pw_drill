Exercice 032 : Extraire les chiffres

Structure attendue du dossier:

```
ex032/
└── pw_extract_digits.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend une chaîne de caractères en paramètre
- La fonction doit extraire tous les chiffres (0-9) présents dans la chaîne
- Les chiffres extraits doivent être concaténés dans l'ordre d'apparition pour former un nombre entier
- La fonction retourne ce nombre entier
- Si aucun chiffre n'est trouvé dans la chaîne, la fonction retourne 0
- Si la chaîne est NULL ou vide, la fonction retourne 0
- Les caractères non-numériques doivent être ignorés
- La fonction doit gérer les nombres jusqu'à la limite des int

Prototype:

```c
int pw_extract_digits(char *str);
```

Resultat attendu:

```
$> ./a.out
Test avec "abc123def456": 123456
Test avec "42 School": 42
Test avec "Hello World": 0
Test avec "a1b2c3": 123
Test avec "": 0
Test avec "999": 999
Test avec "No digits here!": 0
$>
```
