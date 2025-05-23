Exercice 007 : Afficher une lettre

Structure attendue du dossier:

```
ex007/
└── pw_putchar.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui affiche un caractère donné en paramètre suivi d'un retour à la ligne
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Le caractère doit être affiché exactement une fois suivi d'un retour à la ligne

Prototype:

```c
void pw_putchar(char c);
```

Resultat attendu:

```
$> ./a.out
a
$>
```

Avec d'autres caractères:

```
$> ./a.out
z
$>
```

```
$> ./a.out
5
$>
```
