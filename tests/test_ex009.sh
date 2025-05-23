#!/bin/bash

# Script de test pour l'exercice 009 : Compter les caractères
# Usage: ./test_ex009.sh

EXERCISE_DIR="ex009"
SOURCE_FILE="pw_count_chars.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 009 : Compter les caractères ===${NC}"

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
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_count_chars(char *str);

int main(void)
{
    // Test de la fonction pw_count_chars avec différentes chaînes
    printf("%d\n", pw_count_chars("hello"));           // 5 caractères
    printf("%d\n", pw_count_chars("Hello World!"));   // 12 caractères
    printf("%d\n", pw_count_chars(""));               // 0 caractères
    printf("%d\n", pw_count_chars("a"));              // 1 caractère
    printf("%d\n", pw_count_chars("Powercoders"));    // 11 caractères
    
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

echo -e "${YELLOW}🧪 Exécution du test...${NC}"
echo

# Exécuter le programme et capturer la sortie avec cat -e
echo "Sortie du programme avec cat -e:"
OUTPUT_VISIBLE=$(./"$EXECUTABLE" | cat -e)
echo "$OUTPUT_VISIBLE"

echo
echo -e "${YELLOW}📋 Résultat attendu avec cat -e:${NC}"
echo "5$"
echo "12$"
echo "0$"
echo "1$"
echo "11$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="5$
12$
0$
1$
11$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction compte correctement les caractères${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test échoué!${NC}"
    echo -e "${RED}Sortie attendue:${NC}"
    echo "$EXPECTED_OUTPUT"
    echo -e "${RED}Sortie obtenue:${NC}"
    echo "$OUTPUT_VISIBLE"
    
    # Comparer ligne par ligne pour diagnostic
    echo -e "${YELLOW}📋 Comparaison détaillée:${NC}"
    echo "=== Tests effectués ==="
    echo "pw_count_chars(\"hello\") -> attendu: 5"
    echo "pw_count_chars(\"Hello World!\") -> attendu: 12"
    echo "pw_count_chars(\"\") -> attendu: 0"
    echo "pw_count_chars(\"a\") -> attendu: 1"
    echo "pw_count_chars(\"Powercoders\") -> attendu: 11"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec une chaîne simple
echo -e "${YELLOW}🧪 Test individuel avec 'hello'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_count_chars(char *str);

int main(void)
{
    printf("%d\n", pw_count_chars("hello"));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "5$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '5$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_count_chars(char *str);

int main(void)
{
    printf("%d\n", pw_count_chars(""));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EMPTY_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test chaîne vide réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne vide échoué - Sortie: '$EMPTY_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne vide${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 009 validé avec succès${NC}"
else
    echo -e "\n${RED}❌ Exercice 009 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"