Exercice 00 : Afficher la lettre A

Structure attendue du dossier:

```
ex00/
└── pw_putchar_a.c
```

Fonctions autorisées:

- write

Voici un exemple de l'utilisation de write:

```c
write(1, %c, 1);
```

Description:

- Écrire une fonction qui affiche uniquement la lettre "a" dans le terminal
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Aucun retour à la ligne n'est nécessaire

Prototype:

```c
void pw_putchar_a(void);
```

Resultat attendu:

```
$> ./a.out
a$>
```
