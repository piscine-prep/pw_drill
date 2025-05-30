Exercice 030 : Afficher la mémoire

Structure attendue du dossier:

```
ex030/
└── pw_print_memory.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui prend une adresse mémoire (void \*) et une taille (size_t) en paramètres
- La fonction doit lire size octets à partir de l'adresse donnée
- Chaque octet doit être interprété comme un caractère et affiché
- Si un caractère n'est pas imprimable (code ASCII < 32 ou > 126), il doit être remplacé par '.'
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Si l'adresse est NULL ou si la taille est 0, la fonction ne doit rien faire
- Aucun retour à la ligne n'est nécessaire

Prototype:

```c
void pw_print_memory(void *addr, size_t size);
```

Résultat attendu:

```
$> ./a.out
Hello World
$>
```

Avec d'autres exemples:

```
$> ./a.out
ABC...DEF
$>
```

```
$> ./a.out
Test123!
$>
```
