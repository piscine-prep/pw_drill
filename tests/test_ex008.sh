#!/bin/bash

# Script de test pour l'exercice 008 : Addition de deux nombres
# Usage: ./test_ex008.sh

EXERCISE_DIR="ex008"
SOURCE_FILE="pw_add.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 008 : Addition de deux nombres ===${NC}"

# Verifier si le dossier existe
if [ ! -d "$EXERCISE_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier '$EXERCISE_DIR' n'existe pas${NC}"
    exit 1
fi

# Verifier si le fichier source existe
if [ ! -f "$EXERCISE_DIR/$SOURCE_FILE" ]; then
    echo -e "${RED}❌ Erreur: Le fichier '$SOURCE_FILE' n'existe pas dans $EXERCISE_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}📁 Structure du dossier:${NC}"
ls -la "$EXERCISE_DIR"
echo

# Creer le fichier de test temporaire
cat > "$EXERCISE_DIR/$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_add(int a, int b);

int main(void)
{
    // Test de la fonction pw_add avec differents nombres
    printf("%d + %d = %d\n", 5, 3, pw_add(5, 3));         // 5 + 3 = 8
    printf("%d + %d = %d\n", -2, 4, pw_add(-2, 4));       // -2 + 4 = 2
    printf("%d + %d = %d\n", 0, 0, pw_add(0, 0));         // 0 + 0 = 0
    printf("%d + %d = %d\n", -5, -3, pw_add(-5, -3));     // -5 + -3 = -8
    
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

echo -e "${GREEN}✅ Compilation reussie${NC}"
echo

echo -e "${YELLOW}🧪 Execution du test...${NC}"
echo

# Executer le programme et capturer la sortie avec cat -e
echo "Sortie du programme avec cat -e:"
OUTPUT_VISIBLE=$(./"$EXECUTABLE" | cat -e)
echo "$OUTPUT_VISIBLE"

echo
echo -e "${YELLOW}📋 Resultat attendu avec cat -e:${NC}"
echo "5 + 3 = 8$"
echo "-2 + 4 = 2$"
echo "0 + 0 = 0$"
echo "-5 + -3 = -8$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="5 + 3 = 8$
-2 + 4 = 2$
0 + 0 = 0$
-5 + -3 = -8$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction additionne correctement les nombres${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test echoue!${NC}"
    echo -e "${RED}Sortie attendue:${NC}"
    echo "$EXPECTED_OUTPUT"
    echo -e "${RED}Sortie obtenue:${NC}"
    echo "$OUTPUT_VISIBLE"
    
    # Comparer ligne par ligne pour diagnostic
    echo -e "${YELLOW}📋 Comparaison detaillee:${NC}"
    echo "=== Tests effectues ==="
    echo "pw_add(5, 3) -> attendu: 8"
    echo "pw_add(-2, 4) -> attendu: 2"
    echo "pw_add(0, 0) -> attendu: 0"
    echo "pw_add(-5, -3) -> attendu: -8"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec des nombres positifs
echo -e "${YELLOW}🧪 Test individuel avec nombres positifs (5 + 3)...${NC}"

# Creer un fichier de test pour une seule addition
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_add(int a, int b);

int main(void)
{
    printf("%d\n", pw_add(5, 3));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "8$" ]; then
        echo -e "${GREEN}✅ Test individuel reussi${NC}"
    else
        echo -e "${RED}❌ Test individuel echoue - Sortie: '$SINGLE_OUTPUT' (attendu: '8$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec nombres negatifs
echo -e "${YELLOW}🧪 Test avec nombres negatifs (-5 + -3)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_add(int a, int b);

int main(void)
{
    printf("%d\n", pw_add(-5, -3));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NEGATIVE_OUTPUT" = "-8$" ]; then
        echo -e "${GREEN}✅ Test nombres negatifs reussi${NC}"
    else
        echo -e "${RED}❌ Test nombres negatifs echoue - Sortie: '$NEGATIVE_OUTPUT' (attendu: '-8$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test nombres negatifs${NC}"
    TEST_RESULT=1
fi

# Test avec zero
echo -e "${YELLOW}🧪 Test avec zero (0 + 0)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_add(int a, int b);

int main(void)
{
    printf("%d\n", pw_add(0, 0));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test avec zero reussi${NC}"
    else
        echo -e "${RED}❌ Test avec zero echoue - Sortie: '$ZERO_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec zero${NC}"
    TEST_RESULT=1
fi

# Test avec nombres mixtes (positif + negatif)
echo -e "${YELLOW}🧪 Test avec nombres mixtes (-2 + 4)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_add(int a, int b);

int main(void)
{
    printf("%d\n", pw_add(-2, 4));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MIXED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$MIXED_OUTPUT" = "2$" ]; then
        echo -e "${GREEN}✅ Test nombres mixtes reussi${NC}"
    else
        echo -e "${RED}❌ Test nombres mixtes echoue - Sortie: '$MIXED_OUTPUT' (attendu: '2$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test nombres mixtes${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 008 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 008 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"