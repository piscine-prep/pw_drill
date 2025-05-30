Exercice 028 : Nettoyer et convertir en majuscules

Structure attendue du dossier:

```
ex028/
└── pw_strip_and_to_uppercase.c
```

Fonctions autorisees:

- Aucune fonction externe autorisee (uniquement les operations de base du C)

Description:

- Ecrire une fonction qui prend un pointeur vers une chaine de caracteres en parametre
- La fonction doit parcourir la chaine et ne garder que les lettres (a-z et A-Z)
- Tous les autres caracteres (chiffres, espaces, ponctuation, caracteres speciaux) doivent etre supprimes
- Toutes les lettres conservees doivent etre converties en majuscules
- La modification doit etre effectuee directement dans la chaine originale
- La fonction ne doit pas retourner de valeur
- Si la chaine est NULL, la fonction ne doit rien faire
- Le caractere de fin de chaine '\0' doit rester a la fin

Prototype:

```c
void pw_strip_and_to_uppercase(char *str);
```

Resultat attendu:

```
$> ./a.out
Avant: "Hello World 123!"
Apres: "HELLOWORLD"
Avant: "42 School-Paris"
Apres: "SCHOOLPARIS"
Avant: "test@email.com"
Apres: "TESTEMAILCOM"
Avant: "123456"
Apres: ""
Avant: ""
Apres: ""
$>
```
