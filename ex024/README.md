Exercice 024 : Copier une chaîne avec limite (strncpy)

Structure attendue du dossier:

```
ex024/
└── pw_strncpy.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui reproduit le comportement de la fonction strncpy de la bibliothèque standard
- La fonction doit copier au maximum n caractères de la chaîne source (src) vers la chaîne destination (dest)
- Si la longueur de src est inférieure à n, dest doit être complétée avec des caractères '\0'
- Si la longueur de src est supérieure ou égale à n, exactement n caractères sont copiés (sans '\0' final)
- La fonction doit retourner un pointeur vers la chaîne destination
- La fonction ne doit pas utiliser strncpy ou d'autres fonctions de string.h
- Si src est NULL, dest ne doit pas être modifié et la fonction retourne dest
- Si dest est NULL, la fonction doit retourner NULL
- Si n est 0, aucune copie n'est effectuée et la fonction retourne dest

Conseils:

- Regardez `man strncpy` dans votre terminal pour comprendre le comportement exact de la fonction
- Attention : strncpy ne garantit pas que dest se termine par '\0' si src est plus long que n
- Si src est plus court que n, tous les caractères restants de dest doivent être mis à '\0'

Prototype:

```c
char *pw_strncpy(char *dest, char *src, unsigned int n);
```

Resultat attendu:

```
$> ./a.out
Test 1 - Copie complète:
Source: "Hello"
Destination (n=10): "Hello"
Longueur destination: 5

Test 2 - Copie tronquée:
Source: "Hello World"
Destination (n=5): "Hello"
Longueur destination: 5

Test 3 - Chaîne vide:
Source: ""
Destination (n=5): ""
Longueur destination: 0

Test 4 - n=0:
Destination inchangée: "initial"

Test 5 - src plus court que n:
Source: "Hi"
Destination (n=5): "Hi"
Longueur destination: 2

Test NULL: OK
$>
```
