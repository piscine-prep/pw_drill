Exercice 021 : Remplacer caractères

Structure attendue du dossier:

```
ex021/
└── pw_replace_chars.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers une chaîne de caractères en paramètre
- La fonction doit remplacer tous les caractères 'e' (minuscule) par '\*'
- La fonction doit remplacer tous les caractères majuscules (A-Z) par '?'
- La modification doit être effectuée directement dans la chaîne originale
- Les autres caractères doivent rester inchangés
- La fonction ne doit pas retourner de valeur
- Si la chaîne est NULL, la fonction ne doit rien faire
- Le caractère de fin de chaîne '\0' doit rester intact

Prototype:

```c
void pw_replace_chars(char *str);
```

Resultat attendu:

```
$> ./a.out
Avant: "Hello World"
Après: "?*llo ?orld"
Avant: "Excellence in CODING"
Après: "?xc*ll*nc* in ??????"
Avant: "test123"
Après: "t*st123"
Avant: "UPPERCASE"
Après: "?????????"
Avant: ""
Après: ""
$>
```
