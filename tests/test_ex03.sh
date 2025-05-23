#!/bin/bash

# Script de test pour l'exercice 03 : Pair ou Impair
# Usage: ./test_ex03.sh

EXERCISE_DIR="ex03"
SOURCE_FILE="pw_pair_impair.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 03 : Pair ou Impair ===${NC}"

# Vérifier si le dossier existe
if [ ! -d "$EXERCISE_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier '$EXERCISE_DIR' n'existe pas${NC}"
    exit 1
fi

# Vérifier si le fichier source existe
if [ ! -f "$EXERCISE_DIR/$SOURCE_FILE" ]; then
    echo -e "${RED}❌ Erreur: Le fichier '$SOURCE_FILE' n'existe pas dans $EXERCISE_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}📁 Structure du dossier:${NC}"
ls -la "$EXERCISE_DIR"
echo

# Créer le fichier de test temporaire
cat > "$EXERCISE_DIR/$TEST_FILE" << 'EOF'
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    char result;
    
    printf("=== Tests de la fonction pw_pair_impair ===\n");
    
    // Test 1: Mot avec nombre impair de lettres
    result = pw_pair_impair("Hello");
    printf("Test avec \"Hello\": %c\n", result);
    
    // Test 2: Mot avec nombre pair de lettres
    result = pw_pair_impair("Code");
    printf("Test avec \"Code\": %c\n", result);
    
    // Test 3: Chaîne vide (0 lettres = pair)
    result = pw_pair_impair("");
    printf("Test avec \"\": %c\n", result);
    
    // Test 4: Chaîne avec espaces et chiffres
    result = pw_pair_impair("42 School");
    printf("Test avec \"42 School\": %c\n", result);
    
    // Test 5: Chaîne NULL
    result = pw_pair_impair(NULL);
    printf("Test avec NULL: %c\n", result);
    
    // Tests supplémentaires
    printf("\n=== Tests supplémentaires ===\n");
    
    // Test 6: Que des chiffres
    result = pw_pair_impair("12345");
    printf("Test avec \"12345\": %c\n", result);
    
    // Test 7: Mélange de lettres et caractères spéciaux
    result = pw_pair_impair("A!B@C#");
    printf("Test avec \"A!B@C#\": %c\n", result);
    
    // Test 8: Une seule lettre
    result = pw_pair_impair("X");
    printf("Test avec \"X\": %c\n", result);
    
    // Test 9: Deux lettres
    result = pw_pair_impair("AB");
    printf("Test avec \"AB\": %c\n", result);
    
    return (0);
}
EOF

echo -e "${YELLOW}🔨 Compilation en cours...${NC}"

# Compiler le programme
cd "$EXERCISE_DIR"
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erreur de compilation:${NC}"
    cat compilation_errors.txt
    rm -f compilation_errors.txt "$TEST_FILE"
    exit 1
fi

echo -e "${GREEN}✅ Compilation réussie${NC}"
echo

echo -e "${YELLOW}🧪 Exécution des tests...${NC}"
echo

# Exécuter le programme
./"$EXECUTABLE"
EXEC_STATUS=$?

echo
echo -e "${YELLOW}📋 Résultats attendus:${NC}"
echo "Test avec \"Hello\": I (5 lettres = impair)"
echo "Test avec \"Code\": P (4 lettres = pair)"
echo "Test avec \"\": P (0 lettres = pair)"
echo "Test avec \"42 School\": I (6 lettres = pair... attendu P si correct)"
echo "Test avec NULL: N"
echo
echo "Tests supplémentaires attendus:"
echo "Test avec \"12345\": P (0 lettres = pair)"
echo "Test avec \"A!B@C#\": I (3 lettres = impair)"
echo "Test avec \"X\": I (1 lettre = impair)"
echo "Test avec \"AB\": P (2 lettres = pair)"

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ]; then
    echo -e "\n${GREEN}✅ Programme exécuté avec succès${NC}"
    echo -e "${BLUE}👀 Vérifiez manuellement si les résultats correspondent aux attentes${NC}"
else
    echo -e "\n${RED}❌ Erreur lors de l'exécution du programme${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"