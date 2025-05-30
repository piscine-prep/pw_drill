Exercice 023 : Copier une chaîne (strcpy)

Structure attendue du dossier:

```
ex023/
└── pw_strcpy.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui reproduit le comportement de la fonction strcpy de la bibliothèque standard
- La fonction doit copier la chaîne source (src) vers la chaîne destination (dest)
- La copie doit inclure le caractère de fin de chaîne '\0'
- La fonction doit retourner un pointeur vers la chaîne destination
- Il faut s'assurer que la destination a suffisamment d'espace pour la source
- La fonction ne doit pas utiliser strcpy ou d'autres fonctions de string.h
- Si src est NULL, dest ne doit pas être modifié et la fonction retourne dest
- Si dest est NULL, la fonction doit retourner NULL

Conseils:

- Regardez `man strcpy` dans votre terminal pour comprendre le comportement exact de la fonction
- La fonction strcpy copie caractère par caractère jusqu'au '\0' inclus
- N'oubliez pas de retourner le pointeur vers dest à la fin

Prototype:

```c
char *pw_strcpy(char *dest, char *src);
```

Resultat attendu:

```
$> ./a.out
Source: "Hello World"
Destination après copie: "Hello World"
Source: "42 School"
Destination après copie: "42 School"
Source: ""
Destination après copie: ""
Source: "a"
Destination après copie: "a"
Test NULL: OK
$>
```
