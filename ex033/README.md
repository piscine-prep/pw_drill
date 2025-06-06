Exercice 033 : Fichier d'implémentation pour calculatrice

Structure attendue du dossier:

```
ex033/
└── pw_calc.c
```

Fonctions autorisées:

- write

Description:

- Écrire un fichier pw_calc.c qui contiendra les prototypes et implémentations des fonctions nécessaires
- Le fichier doit faire compiler et fonctionner correctement le main suivant
- Toutes les fonctions doivent être implémentées dans pw_calc.c
- Utiliser uniquement la fonction write pour l'affichage

Code à faire fonctionner:

```c
#include <unistd.h>

// Prototypes des fonctions (à inclure dans pw_calc.c)
void pw_putstr(char *str);
void pw_putnbr(int nb);
int pw_add(int a, int b);
int pw_sub(int a, int b);
int pw_mul(int a, int b);
int pw_div(int a, int b);
int pw_max(int a, int b);

int main(void)
{
    int a = 10;
    int b = 5;

    pw_putstr("Addition: ");
    pw_putnbr(pw_add(a, b));
    pw_putstr("\n");

    pw_putstr("Soustraction: ");
    pw_putnbr(pw_sub(a, b));
    pw_putstr("\n");

    pw_putstr("Multiplication: ");
    pw_putnbr(pw_mul(a, b));
    pw_putstr("\n");

    pw_putstr("Division: ");
    pw_putnbr(pw_div(a, b));
    pw_putstr("\n");

    pw_putstr("Maximum: ");
    pw_putnbr(pw_max(a, b));
    pw_putstr("\n");

    return (0);
}
```

Resultat attendu:

```
$> ./a.out
Addition: 15
Soustraction: 5
Multiplication: 50
Division: 2
Maximum: 10
$>
```
