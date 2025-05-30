Exercice 031 : Puissance d'un nombre

Structure attendue du dossier:

```
ex031/
└── pw_pow.c
```

Fonctions autorisées:

- Aucune fonction externe autorisée (uniquement les opérations de base du C)

Description:

- Écrire une fonction qui calcule la puissance d'un nombre entier
- La fonction prend deux paramètres : la base (int) et l'exposant (int)
- La fonction doit retourner le résultat de base^exposant
- L'exposant peut être positif, négatif ou zéro
- Si l'exposant est 0, le résultat doit être 1 (même pour base = 0)
- Si l'exposant est négatif, le résultat doit être 0 (division entière)
- Si la base est 0 et l'exposant est positif, le résultat doit être 0
- La fonction doit gérer les cas particuliers correctement
- Ne pas utiliser de fonctions mathématiques externes comme pow()

Prototype:

```c
int pw_pow(int base, int exposant);
```

Resultat attendu:

```
$> ./a.out
2^3 = 8
5^0 = 1
0^5 = 0
0^0 = 1
3^4 = 81
-2^3 = -8
2^-3 = 0
-3^2 = 9
$>
```
