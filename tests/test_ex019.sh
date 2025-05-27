#!/bin/bash

# Script de test pour l'exercice 019 : Division et modulo ultimes
# Usage: ./test_ex019.sh

EXERCISE_DIR="ex019"
SOURCE_FILE="pw_ultimate_div_mod.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 019 : Division et modulo ultimes ===${NC}"

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
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    // Test de la fonction pw_ultimate_div_mod avec différentes valeurs
    int a1 = 17, b1 = 5;
    printf("Avant: a=%d, b=%d\n", a1, b1);
    pw_ultimate_div_mod(&a1, &b1);
    printf("Après: a=%d, b=%d\n", a1, b1);
    
    int a2 = 20, b2 = 6;
    printf("Avant: a=%d, b=%d\n", a2, b2);
    pw_ultimate_div_mod(&a2, &b2);
    printf("Après: a=%d, b=%d\n", a2, b2);
    
    int a3 = 42, b3 = 7;
    printf("Avant: a=%d, b=%d\n", a3, b3);
    pw_ultimate_div_mod(&a3, &b3);
    printf("Après: a=%d, b=%d\n", a3, b3);
    
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
echo "Avant: a=17, b=5$"
echo "Après: a=3, b=2$"
echo "Avant: a=20, b=6$"
echo "Après: a=3, b=2$"
echo "Avant: a=42, b=7$"
echo "Après: a=6, b=0$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Avant: a=17, b=5$
Après: a=3, b=2$
Avant: a=20, b=6$
Après: a=3, b=2$
Avant: a=42, b=7$
Après: a=6, b=0$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction effectue correctement la division et le modulo${NC}"
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
    echo "pw_ultimate_div_mod(&a1, &b1) avec a1=17, b1=5 -> a1=17/5=3, b1=17%5=2"
    echo "pw_ultimate_div_mod(&a2, &b2) avec a2=20, b2=6 -> a2=20/6=3, b2=20%6=2"
    echo "pw_ultimate_div_mod(&a3, &b3) avec a3=42, b3=7 -> a3=42/7=6, b3=42%7=0"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec 17 et 5
echo -e "${YELLOW}🧪 Test individuel avec 17 / 5...${NC}"

# Créer un fichier de test pour une seule division
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int dividend = 17, divisor = 5;
    printf("Avant: dividend=%d, divisor=%d\n", dividend, divisor);
    pw_ultimate_div_mod(&dividend, &divisor);
    printf("Après: quotient=%d, reste=%d\n", dividend, divisor);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: dividend=17, divisor=5$
Après: quotient=3, reste=2$"
    if [ "$SINGLE_OUTPUT" = "$EXPECTED_SINGLE" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SINGLE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SINGLE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec division exacte (reste = 0)
echo -e "${YELLOW}🧪 Test avec division exacte (10 / 2)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int a = 10, b = 2;
    printf("Avant: a=%d, b=%d\n", a, b);
    pw_ultimate_div_mod(&a, &b);
    printf("Après: a=%d, b=%d\n", a, b);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EXACT_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EXACT="Avant: a=10, b=2$
Après: a=5, b=0$"
    if [ "$EXACT_OUTPUT" = "$EXPECTED_EXACT" ]; then
        echo -e "${GREEN}✅ Test division exacte réussi${NC}"
    else
        echo -e "${RED}❌ Test division exacte échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_EXACT"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$EXACT_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test division exacte${NC}"
    TEST_RESULT=1
fi

# Test avec grand nombre
echo -e "${YELLOW}🧪 Test avec grands nombres (100 / 7)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int a = 100, b = 7;
    printf("Avant: a=%d, b=%d\n", a, b);
    pw_ultimate_div_mod(&a, &b);
    printf("Après: a=%d, b=%d\n", a, b);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LARGE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 100 / 7 = 14, 100 % 7 = 2
    EXPECTED_LARGE="Avant: a=100, b=7$
Après: a=14, b=2$"
    if [ "$LARGE_OUTPUT" = "$EXPECTED_LARGE" ]; then
        echo -e "${GREEN}✅ Test grands nombres réussi${NC}"
    else
        echo -e "${RED}❌ Test grands nombres échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LARGE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LARGE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test grands nombres${NC}"
    TEST_RESULT=1
fi

# Test avec 1 comme diviseur
echo -e "${YELLOW}🧪 Test avec diviseur 1 (25 / 1)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int a = 25, b = 1;
    printf("Avant: a=%d, b=%d\n", a, b);
    pw_ultimate_div_mod(&a, &b);
    printf("Après: a=%d, b=%d\n", a, b);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ONE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 25 / 1 = 25, 25 % 1 = 0
    EXPECTED_ONE="Avant: a=25, b=1$
Après: a=25, b=0$"
    if [ "$ONE_OUTPUT" = "$EXPECTED_ONE" ]; then
        echo -e "${GREEN}✅ Test diviseur 1 réussi${NC}"
    else
        echo -e "${RED}❌ Test diviseur 1 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ONE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ONE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test diviseur 1${NC}"
    TEST_RESULT=1
fi

# Test avec dividende plus petit que diviseur
echo -e "${YELLOW}🧪 Test dividende < diviseur (3 / 5)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int a = 3, b = 5;
    printf("Avant: a=%d, b=%d\n", a, b);
    pw_ultimate_div_mod(&a, &b);
    printf("Après: a=%d, b=%d\n", a, b);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SMALL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 3 / 5 = 0, 3 % 5 = 3
    EXPECTED_SMALL="Avant: a=3, b=5$
Après: a=0, b=3$"
    if [ "$SMALL_OUTPUT" = "$EXPECTED_SMALL" ]; then
        echo -e "${GREEN}✅ Test dividende < diviseur réussi${NC}"
    else
        echo -e "${RED}❌ Test dividende < diviseur échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SMALL"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SMALL_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test dividende < diviseur${NC}"
    TEST_RESULT=1
fi

# Test de vérification mathématique
echo -e "${YELLOW}🧪 Test de vérification mathématique...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_ultimate_div_mod(int *a, int *b);

int main(void)
{
    int original_dividend = 23;
    int original_divisor = 4;
    int a = original_dividend;
    int b = original_divisor;
    
    pw_ultimate_div_mod(&a, &b);
    
    // Vérifier que dividend = quotient * divisor + reste
    int verification = a * original_divisor + b;
    
    if (verification == original_dividend) {
        printf("VERIFICATION_SUCCESS: %d = %d * %d + %d\n", 
               original_dividend, a, original_divisor, b);
    } else {
        printf("VERIFICATION_FAILED: %d != %d * %d + %d = %d\n", 
               original_dividend, a, original_divisor, b, verification);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    VERIFICATION_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if echo "$VERIFICATION_OUTPUT" | grep -q "VERIFICATION_SUCCESS"; then
        echo -e "${GREEN}✅ Test de vérification mathématique réussi${NC}"
    else
        echo -e "${RED}❌ Test de vérification mathématique échoué${NC}"
        echo -e "${RED}Sortie: '$VERIFICATION_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test de vérification${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 019 validé avec succès${NC}"
    echo -e "${GREEN}La fonction effectue correctement la division et le modulo via pointeurs!${NC}"
else
    echo -e "\n${RED}❌ Exercice 019 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"