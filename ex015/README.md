Exercice 015 : Tailles des types avec sizeof

Structure attendue du dossier:

```
ex015/
└── pw_sizeof.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui affiche la taille en octets de différents types de données en C
- La fonction doit utiliser l'opérateur sizeof pour obtenir ces tailles
- Les types à afficher sont : char, short, int, long, float, et double
- Chaque taille doit être affichée sur une ligne séparée au format "type: X octets"
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien
- Chaque ligne doit se terminer par un retour à la ligne

Prototype:

```c
void pw_sizeof(void);
```

Resultat attendu:

```
$> ./a.out
char: 1 octets
short: 2 octets
int: 4 octets
long: 8 octets
float: 4 octets
double: 8 octets
$>
```
