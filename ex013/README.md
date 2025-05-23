Exercice 013 : Afficher un nombre (récursif)

Structure attendue du dossier:

```
ex013/
└── pw_putnbr.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui prend un unsigned int en paramètre
- La fonction doit afficher ce nombre dans la sortie standard
- La fonction doit utiliser une approche récursive pour décomposer le nombre
- Chaque chiffre doit être affiché dans le bon ordre (de gauche à droite)
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Aucun retour à la ligne n'est nécessaire (juste le nombre)

Prototype:

```c
void pw_putnbr(unsigned int nb);
```

Resultat attendu:

```
$> ./a.out
42
$>
```

Avec d'autres nombres:

```
$> ./a.out
0
$>
```

```
$> ./a.out
123456789
$>
```

```
$> ./a.out
4294967295
$>
```
