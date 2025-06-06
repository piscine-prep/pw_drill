#!/bin/bash

# Script de test pour l'exercice 014 : Casting de types
# Usage: ./test_ex014.sh

EXERCISE_DIR="ex014"
SOURCE_FILE="pw_casting.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 014 : Casting de types ===${NC}"

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
int pw_casting(float f);

int main(void)
{
    // Test de la fonction pw_casting avec differents floats
    printf("Test avec 65.7: %d\n", pw_casting(65.7f));       // (int)65.7 + (char)65.7 + round(65.7) = 65 + 65 + 66 = 196... wait
    printf("Test avec 120.3: %d\n", pw_casting(120.3f));     // (int)120.3 + (char)120.3 + round(120.3) = 120 + 120 + 120 = 360
    printf("Test avec 0.0: %d\n", pw_casting(0.0f));         // (int)0.0 + (char)0.0 + round(0.0) = 0 + 0 + 0 = 0
    printf("Test avec 300.5: %d\n", pw_casting(300.5f));     // (int)300.5 + (char)300.5 + round(300.5) = 300 + 44 + 301 = 645... wait (char)300 = 300%256 = 44
    
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
echo "Test avec 65.7: 196$"
echo "Test avec 120.3: 360$"
echo "Test avec 0.0: 0$"
echo "Test avec 300.5: 645$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Test avec 65.7: 196$
Test avec 120.3: 360$
Test avec 0.0: 0$
Test avec 300.5: 645$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction effectue correctement les castings${NC}"
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
    echo "pw_casting(65.7f) -> (int)65 + (char)65 + round(66) = 65 + 65 + 66 = 196"
    echo "pw_casting(120.3f) -> (int)120 + (char)120 + round(120) = 120 + 120 + 120 = 360"
    echo "pw_casting(0.0f) -> (int)0 + (char)0 + round(0) = 0 + 0 + 0 = 0"
    echo "pw_casting(300.5f) -> (int)300 + (char)(300%256=44) + round(301) = 300 + 44 + 301 = 645"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec 65.7
echo -e "${YELLOW}🧪 Test individuel avec 65.7...${NC}"

# Creer un fichier de test pour une seule valeur
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_casting(float f);

int main(void)
{
    printf("%d\n", pw_casting(65.7f));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "196$" ]; then
        echo -e "${GREEN}✅ Test individuel reussi${NC}"
    else
        echo -e "${RED}❌ Test individuel echoue - Sortie: '$SINGLE_OUTPUT' (attendu: '196$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec zero
echo -e "${YELLOW}🧪 Test avec zero (0.0)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_casting(float f);

int main(void)
{
    printf("%d\n", pw_casting(0.0f));
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

# Test avec grand nombre pour verifier le casting char (modulo 256)
echo -e "${YELLOW}🧪 Test avec grand nombre (300.5)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_casting(float f);

int main(void)
{
    printf("%d\n", pw_casting(300.5f));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LARGE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LARGE_OUTPUT" = "645$" ]; then
        echo -e "${GREEN}✅ Test grand nombre reussi${NC}"
    else
        echo -e "${RED}❌ Test grand nombre echoue - Sortie: '$LARGE_OUTPUT' (attendu: '645$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test grand nombre${NC}"
    TEST_RESULT=1
fi

# Test supplementaire pour verifier l'arrondi
echo -e "${YELLOW}🧪 Test arrondi avec 10.4...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_casting(float f);

int main(void)
{
    printf("%d\n", pw_casting(10.4f));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ROUND_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 10.4 -> (int)10 + (char)10 + round(10) = 10 + 10 + 10 = 30
    if [ "$ROUND_OUTPUT" = "30$" ]; then
        echo -e "${GREEN}✅ Test arrondi vers le bas reussi${NC}"
    else
        echo -e "${RED}❌ Test arrondi vers le bas echoue - Sortie: '$ROUND_OUTPUT' (attendu: '30$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test arrondi${NC}"
    TEST_RESULT=1
fi

# Test supplementaire pour verifier l'arrondi vers le haut
echo -e "${YELLOW}🧪 Test arrondi avec 10.6...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_casting(float f);

int main(void)
{
    printf("%d\n", pw_casting(10.6f));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ROUND_UP_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 10.6 -> (int)10 + (char)10 + round(11) = 10 + 10 + 11 = 31
    if [ "$ROUND_UP_OUTPUT" = "31$" ]; then
        echo -e "${GREEN}✅ Test arrondi vers le haut reussi${NC}"
    else
        echo -e "${RED}❌ Test arrondi vers le haut echoue - Sortie: '$ROUND_UP_OUTPUT' (attendu: '31$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test arrondi vers le haut${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 014 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 014 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"