Exercice 08 : Combinaisons de bits

Structure attendue du dossier:

```
ex08/
└── pw_print_bits.c
```

Fonctions autorisées:

- write

Description:

- Écrire une fonction qui affiche toutes les combinaisons possibles de 1 et 0 pour un groupe de 8 chiffres (un byte)
- Chaque combinaison doit être affichée sur une ligne séparée
- Les combinaisons doivent être affichées dans l'ordre croissant (de 00000000 à 11111111)
- Il doit y avoir exactement 256 combinaisons (2^8)
- Chaque ligne doit se terminer par un retour à la ligne
- La fonction ne doit pas utiliser printf ou puts
- Utiliser uniquement la fonction write pour l'affichage
- La fonction ne retourne rien

Prototype:

```c
void pw_print_bits(void);
```

Resultat attendu:

```
$> ./a.out
00000000
00000001
00000010
00000011
00000100
00000101
00000110
00000111
00001000
00001001
...
11111000
11111001
11111010
11111011
11111100
11111101
11111110
11111111
$>
```
