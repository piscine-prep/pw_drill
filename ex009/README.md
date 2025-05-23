Exercice 009 : Compter les caractères

Structure attendue du dossier:

```
ex009/
└── pw_count_chars.c
```

Fonctions autorisées:

- Aucune fonction externe n'est autorisée

Description:

- Écrire une fonction qui prend une chaîne de caractères en paramètre
- La fonction doit compter le nombre de caractères dans la chaîne (sans compter le caractère de fin '\0')
- La fonction retourne le nombre de caractères trouvés
- Si la chaîne est vide, retourner 0
- Ne pas utiliser de fonctions de la bibliothèque standard comme strlen

Prototype:

```c
int pw_count_chars(char *str);
```

Resultat attendu:

```
$> ./a.out
5
$>
```

Avec d'autres chaînes:

```
$> ./a.out
12
$>
```

```
$> ./a.out
0
$>
```
