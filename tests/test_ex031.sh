#!/bin/bash

# Script de test pour l'exercice 031 : Puissance d'un nombre
# Usage: ./test_ex031.sh

EXERCISE_DIR="ex031"
SOURCE_FILE="pw_pow.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 031 : Puissance d'un nombre ===${NC}"

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
int pw_pow(int base, int exposant);

int main(void)
{
    // Test de la fonction pw_pow avec différents cas
    printf("%d^%d = %d\n", 2, 3, pw_pow(2, 3));         // 2^3 = 8
    printf("%d^%d = %d\n", 5, 0, pw_pow(5, 0));         // 5^0 = 1
    printf("%d^%d = %d\n", 0, 5, pw_pow(0, 5));         // 0^5 = 0
    printf("%d^%d = %d\n", 0, 0, pw_pow(0, 0));         // 0^0 = 1
    printf("%d^%d = %d\n", 3, 4, pw_pow(3, 4));         // 3^4 = 81
    printf("%d^%d = %d\n", -2, 3, pw_pow(-2, 3));       // -2^3 = -8
    printf("%d^%d = %d\n", 2, -3, pw_pow(2, -3));       // 2^-3 = 0
    printf("%d^%d = %d\n", -3, 2, pw_pow(-3, 2));       // -3^2 = 9
    
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
echo "2^3 = 8$"
echo "5^0 = 1$"
echo "0^5 = 0$"
echo "0^0 = 1$"
echo "3^4 = 81$"
echo "-2^3 = -8$"
echo "2^-3 = 0$"
echo "-3^2 = 9$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="2^3 = 8$
5^0 = 1$
0^5 = 0$
0^0 = 1$
3^4 = 81$
-2^3 = -8$
2^-3 = 0$
-3^2 = 9$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction calcule correctement les puissances${NC}"
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
    echo "pw_pow(2, 3) -> attendu: 8"
    echo "pw_pow(5, 0) -> attendu: 1"
    echo "pw_pow(0, 5) -> attendu: 0"
    echo "pw_pow(0, 0) -> attendu: 1"
    echo "pw_pow(3, 4) -> attendu: 81"
    echo "pw_pow(-2, 3) -> attendu: -8"
    echo "pw_pow(2, -3) -> attendu: 0 (division entière)"
    echo "pw_pow(-3, 2) -> attendu: 9"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec 2^3
echo -e "${YELLOW}🧪 Test individuel avec 2^3...${NC}"

# Créer un fichier de test pour une seule puissance
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d\n", pw_pow(2, 3));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "8$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '8$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec exposant 0
echo -e "${YELLOW}🧪 Test avec exposant 0...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^0 = %d\n", 42, pw_pow(42, 0));
    printf("%d^0 = %d\n", -5, pw_pow(-5, 0));
    printf("%d^0 = %d\n", 0, pw_pow(0, 0));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_EXP_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ZERO_EXP="42^0 = 1$
-5^0 = 1$
0^0 = 1$"
    if [ "$ZERO_EXP_OUTPUT" = "$EXPECTED_ZERO_EXP" ]; then
        echo -e "${GREEN}✅ Test exposant 0 réussi${NC}"
    else
        echo -e "${RED}❌ Test exposant 0 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ZERO_EXP"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ZERO_EXP_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test exposant 0${NC}"
    TEST_RESULT=1
fi

# Test avec base 0
echo -e "${YELLOW}🧪 Test avec base 0...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^%d = %d\n", 0, 1, pw_pow(0, 1));
    printf("%d^%d = %d\n", 0, 5, pw_pow(0, 5));
    printf("%d^%d = %d\n", 0, 100, pw_pow(0, 100));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_BASE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ZERO_BASE="0^1 = 0$
0^5 = 0$
0^100 = 0$"
    if [ "$ZERO_BASE_OUTPUT" = "$EXPECTED_ZERO_BASE" ]; then
        echo -e "${GREEN}✅ Test base 0 réussi${NC}"
    else
        echo -e "${RED}❌ Test base 0 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ZERO_BASE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ZERO_BASE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test base 0${NC}"
    TEST_RESULT=1
fi

# Test avec exposants négatifs
echo -e "${YELLOW}🧪 Test avec exposants négatifs...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^%d = %d\n", 2, -1, pw_pow(2, -1));
    printf("%d^%d = %d\n", 5, -2, pw_pow(5, -2));
    printf("%d^%d = %d\n", 10, -1, pw_pow(10, -1));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_EXP_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NEGATIVE_EXP="2^-1 = 0$
5^-2 = 0$
10^-1 = 0$"
    if [ "$NEGATIVE_EXP_OUTPUT" = "$EXPECTED_NEGATIVE_EXP" ]; then
        echo -e "${GREEN}✅ Test exposants négatifs réussi${NC}"
    else
        echo -e "${RED}❌ Test exposants négatifs échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NEGATIVE_EXP"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NEGATIVE_EXP_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test exposants négatifs${NC}"
    TEST_RESULT=1
fi

# Test avec nombres négatifs et exposants pairs/impairs
echo -e "${YELLOW}🧪 Test avec nombres négatifs...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^%d = %d\n", -2, 2, pw_pow(-2, 2));     // pair -> positif
    printf("%d^%d = %d\n", -2, 3, pw_pow(-2, 3));     // impair -> négatif
    printf("%d^%d = %d\n", -3, 4, pw_pow(-3, 4));     // pair -> positif
    printf("%d^%d = %d\n", -5, 1, pw_pow(-5, 1));     // impair -> négatif
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_BASE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NEGATIVE_BASE="-2^2 = 4$
-2^3 = -8$
-3^4 = 81$
-5^1 = -5$"
    if [ "$NEGATIVE_BASE_OUTPUT" = "$EXPECTED_NEGATIVE_BASE" ]; then
        echo -e "${GREEN}✅ Test nombres négatifs réussi${NC}"
    else
        echo -e "${RED}❌ Test nombres négatifs échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NEGATIVE_BASE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NEGATIVE_BASE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test nombres négatifs${NC}"
    TEST_RESULT=1
fi

# Test avec exposant 1
echo -e "${YELLOW}🧪 Test avec exposant 1...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^1 = %d\n", 42, pw_pow(42, 1));
    printf("%d^1 = %d\n", -7, pw_pow(-7, 1));
    printf("%d^1 = %d\n", 1, pw_pow(1, 1));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ONE_EXP_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ONE_EXP="42^1 = 42$
-7^1 = -7$
1^1 = 1$"
    if [ "$ONE_EXP_OUTPUT" = "$EXPECTED_ONE_EXP" ]; then
        echo -e "${GREEN}✅ Test exposant 1 réussi${NC}"
    else
        echo -e "${RED}❌ Test exposant 1 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ONE_EXP"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ONE_EXP_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test exposant 1${NC}"
    TEST_RESULT=1
fi

# Test avec base 1
echo -e "${YELLOW}🧪 Test avec base 1...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^%d = %d\n", 1, 5, pw_pow(1, 5));
    printf("%d^%d = %d\n", 1, 100, pw_pow(1, 100));
    printf("%d^%d = %d\n", 1, 0, pw_pow(1, 0));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ONE_BASE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ONE_BASE="1^5 = 1$
1^100 = 1$
1^0 = 1$"
    if [ "$ONE_BASE_OUTPUT" = "$EXPECTED_ONE_BASE" ]; then
        echo -e "${GREEN}✅ Test base 1 réussi${NC}"
    else
        echo -e "${RED}❌ Test base 1 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ONE_BASE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ONE_BASE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test base 1${NC}"
    TEST_RESULT=1
fi

# Test avec grands exposants
echo -e "${YELLOW}🧪 Test avec grands exposants...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_pow(int base, int exposant);

int main(void)
{
    printf("%d^%d = %d\n", 2, 10, pw_pow(2, 10));     // 2^10 = 1024
    printf("%d^%d = %d\n", 3, 5, pw_pow(3, 5));       // 3^5 = 243
    printf("%d^%d = %d\n", 10, 3, pw_pow(10, 3));     // 10^3 = 1000
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LARGE_EXP_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LARGE_EXP="2^10 = 1024$
3^5 = 243$
10^3 = 1000$"
    if [ "$LARGE_EXP_OUTPUT" = "$EXPECTED_LARGE_EXP" ]; then
        echo -e "${GREEN}✅ Test grands exposants réussi${NC}"
    else
        echo -e "${RED}❌ Test grands exposants échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LARGE_EXP"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LARGE_EXP_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test grands exposants${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 031 validé avec succès${NC}"
    echo -e "${GREEN}La fonction calcule correctement les puissances!${NC}"
else
    echo -e "\n${RED}❌ Exercice 031 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"