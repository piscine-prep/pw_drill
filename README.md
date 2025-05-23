# pw_drill - Exercices de Préparation à la Piscine 42

## Description du projet

**pw_drill** est un ensemble d'exercices de programmation en C conçu pour préparer les étudiants à la piscine de l'école 42. Ce projet propose une série d'exercices progressifs qui permettent aux étudiants de maîtriser les fondamentaux de la programmation en C.

## Structure attendue de votre repository personnel

Votre repository personnel doit respecter cette structure exacte :

```
pw_piscine_prep/
├── votre_nom_pw_drill/
│   ├── ex00/
│   │   └── pw_putchar_a.c
│   ├── ex01/
│   │   └── pw_hello_powercoders.c
│   ├── ex02/
│   │   └── pw_triangle.c
│   ├── ...
│   ├── tests/
│   │   ├── test_ex00.sh
│   │   ├── test_ex01.sh
│   │   ├── test_ex02.sh
│   └── └── ...
└── pw_drill/...
```

## Création de votre repository personnel

### Étape 1 : Création sur GitHub

1. **Se connecter à GitHub** et cliquer sur "New repository"
2. **Nommer le repository** : `votre_nom_pw_drill` (ex: `dupont_pw_drill`)
3. **Configuration** :
   - ✅ Public (accessible au professeur)
   - ✅ Add .gitignore → choisir "C"
4. **Cliquer sur "Create repository"**

### Étape 2 : Clonage des repositories nécessaires

```bash
# Cloner le repository des exercices (pour accéder aux énoncés et tests)
git clone https://github.com/piscine-prep/pw_drill.git

# Cloner votre repository personnel
git clone https://github.com/votre_username/votre_nom_pw_drill.git
cd votre_nom_pw_drill

# Créer la structure de dossiers
mkdir ex00 ex01 ex02 tests

# Vérifier la structure
ls -la
```

**Important** : Vous devez avoir les deux repositories dans le même dossier parent :

```
pw_piscine_prep/
├── pw_drill/              ← Repository des exercices (énoncés et tests)
└── votre_nom_pw_drill/    ← Votre repository personnel (solutions)
```

### Étape 3 : Premier commit

```bash
# Ajouter et commiter la structure initiale
git add .
git commit -m "Initial setup: created project structure"
git push origin main
```

## Workflow pour chaque exercice

### Exemple complet avec l'exercice 00

#### 1. Lire l'énoncé

```bash
# Consulter l'énoncé dans le repository des exercices
cat ../pw_drill/ex00/README.md
```

#### 2. Créer le fichier source

```bash
# Dans votre repository personnel
cd ex00
touch pw_putchar_a.c
# Éditer avec votre éditeur préféré
```

#### 3. Implémenter la fonction

Exemple de contenu pour `pw_putchar_a.c` :

```c
#include <unistd.h>

void pw_putchar_a(void)
{
    write(1, "a", 1);
}
```

#### 4. Copier et préparer le test

```bash
# Depuis la racine de votre repository personnel
# Copier le test depuis le repository des exercices
cp ../pw_drill/tests/test_ex00.sh tests/
chmod +x tests/test_ex00.sh
```

#### 5. Tester votre solution

```bash
./tests/test_ex00.sh
```

#### 6. Valider et publier

```bash
# Si le test passe
git add ex00/ tests/test_ex00.sh
git commit -m "ex00: implemented pw_putchar_a - displays letter 'a'"
git push origin main
```

#### 7. Mettre à jour la progression (optionnel)

Éditer le README principal pour cocher `[x] ex00`.

## Points importants

### Structure obligatoire

- **Respecter exactement** les noms de fichiers et dossiers
- **Un exercice = un dossier** (ex00, ex01, etc.)
- **Tests séparés** dans le dossier `tests/`

### Bonnes pratiques

- **Toujours tester** avant de push
- **Messages de commit clairs** : `"exXX: brief description"`
- **Push régulier** pour sauvegarder
- **Utiliser l'éditeur de votre choix** : vim, nano, VSCode, etc.

### Commandes utiles

#### Création de fichiers

```bash
touch nom_fichier.c     # Créer un fichier vide
mkdir nom_dossier       # Créer un dossier
```

#### Git essentiels

```bash
git status              # État des fichiers
git add fichier         # Ajouter un fichier
git add .               # Ajouter tous les fichiers
git commit -m "message" # Créer un commit
git push origin main    # Envoyer vers GitHub
git log --oneline       # Historique des commits
```

#### Tests

```bash
chmod +x script.sh      # Rendre exécutable
./script.sh             # Exécuter le script
```

### En cas de problème

1. **Erreur de compilation** : Vérifier la syntaxe C et les fonctions autorisées
2. **Test échoué** : Comparer votre sortie avec le résultat attendu
3. **Problème Git** : Utiliser `git status` pour diagnostiquer
4. **Structure incorrecte** : Vérifier les noms de fichiers et dossiers

## Validation finale

Le professeur validera votre travail en :

1. Clonant votre repository
2. Exécutant les scripts de test
3. Vérifiant que tous passent avec succès

**Important** : Votre repository doit être public et accessible sur GitHub.
