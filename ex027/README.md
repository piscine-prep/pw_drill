Exercice 027 : Convertir en majuscules

Structure attendue du dossier:

```
ex027/
└── pw_to_uppercase.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui prend un pointeur vers une chaîne de caractères en paramètre
- La fonction doit convertir toutes les lettres minuscules (a-z) en majuscules (A-Z)
- La modification doit être effectuée directement dans la chaîne originale
- Les autres caractères (chiffres, espaces, caractères spéciaux, majuscules déjà présentes) doivent rester inchangés
- La fonction ne doit pas retourner de valeur
- Si la chaîne est NULL, la fonction ne doit rien faire
- Le caractère de fin de chaîne '\0' doit rester intact

Prototype:

```c
void pw_to_uppercase(char *str);
```

Resultat attendu:

```
$> ./a.out
Avant: "hello world"
Apres: "HELLO WORLD"
Avant: "Test123!@#"
Apres: "TEST123!@#"
Avant: "ALREADY UPPERCASE"
Apres: "ALREADY UPPERCASE"
Avant: "mixedCASE"
Apres: "MIXEDCASE"
Avant: ""
Apres: ""
$>
```
