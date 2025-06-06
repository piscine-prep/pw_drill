#!/bin/bash

# Script de test pour l'exercice 017 : Echanger deux valeurs
# Usage: ./test_ex017.sh

EXERCISE_DIR="ex017"
SOURCE_FILE="pw_swap.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 017 : Echanger deux valeurs ===${NC}"

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
void pw_swap(int *a, int *b);

int main(void)
{
    // Test de la fonction pw_swap avec differentes valeurs
    int a1 = 5, b1 = 10;
    printf("Avant: a=%d, b=%d\n", a1, b1);
    pw_swap(&a1, &b1);
    printf("Apres: a=%d, b=%d\n", a1, b1);
    
    int a2 = -3, b2 = 7;
    printf("Avant: a=%d, b=%d\n", a2, b2);
    pw_swap(&a2, &b2);
    printf("Apres: a=%d, b=%d\n", a2, b2);
    
    int a3 = 0, b3 = 42;
    printf("Avant: a=%d, b=%d\n", a3, b3);
    pw_swap(&a3, &b3);
    printf("Apres: a=%d, b=%d\n", a3, b3);
    
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
echo "Avant: a=5, b=10$"
echo "Apres: a=10, b=5$"
echo "Avant: a=-3, b=7$"
echo "Apres: a=7, b=-3$"
echo "Avant: a=0, b=42$"
echo "Apres: a=42, b=0$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: a=5, b=10$
Apres: a=10, b=5$
Avant: a=-3, b=7$
Apres: a=7, b=-3$
Avant: a=0, b=42$
Apres: a=42, b=0$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction echange correctement les valeurs${NC}"
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
    echo "pw_swap(&a1, &b1) avec a1=5, b1=10 -> doit donner a1=10, b1=5"
    echo "pw_swap(&a2, &b2) avec a2=-3, b2=7 -> doit donner a2=7, b2=-3"
    echo "pw_swap(&a3, &b3) avec a3=0, b3=42 -> doit donner a3=42, b3=0"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec un seul echange
echo -e "${YELLOW}🧪 Test individuel avec un echange...${NC}"

# Creer un fichier de test pour un seul echange
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_swap(int *a, int *b);

int main(void)
{
    int x = 100, y = 200;
    printf("Avant: x=%d, y=%d\n", x, y);
    pw_swap(&x, &y);
    printf("Apres: x=%d, y=%d\n", x, y);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: x=100, y=200$
Apres: x=200, y=100$"
    if [ "$SINGLE_OUTPUT" = "$EXPECTED_SINGLE" ]; then
        echo -e "${GREEN}✅ Test individuel reussi${NC}"
    else
        echo -e "${RED}❌ Test individuel echoue${NC}"
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

# Test avec valeurs identiques
echo -e "${YELLOW}🧪 Test avec valeurs identiques...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_swap(int *a, int *b);

int main(void)
{
    int a = 42, b = 42;
    printf("Avant: a=%d, b=%d\n", a, b);
    pw_swap(&a, &b);
    printf("Apres: a=%d, b=%d\n", a, b);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    IDENTICAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_IDENTICAL="Avant: a=42, b=42$
Apres: a=42, b=42$"
    if [ "$IDENTICAL_OUTPUT" = "$EXPECTED_IDENTICAL" ]; then
        echo -e "${GREEN}✅ Test valeurs identiques reussi${NC}"
    else
        echo -e "${RED}❌ Test valeurs identiques echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_IDENTICAL"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$IDENTICAL_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test valeurs identiques${NC}"
    TEST_RESULT=1
fi

# Test avec valeurs extremes
echo -e "${YELLOW}🧪 Test avec valeurs extremes...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_swap(int *a, int *b);

int main(void)
{
    int max_val = 2147483647;  // INT_MAX
    int min_val = -2147483648; // INT_MIN (approximatif)
    printf("Avant: max=%d, min=%d\n", max_val, min_val);
    pw_swap(&max_val, &min_val);
    printf("Apres: max=%d, min=%d\n", max_val, min_val);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EXTREME_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EXTREME="Avant: max=2147483647, min=-2147483648$
Apres: max=-2147483648, min=2147483647$"
    if [ "$EXTREME_OUTPUT" = "$EXPECTED_EXTREME" ]; then
        echo -e "${GREEN}✅ Test valeurs extremes reussi${NC}"
    else
        echo -e "${RED}❌ Test valeurs extremes echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_EXTREME"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$EXTREME_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test valeurs extremes${NC}"
    TEST_RESULT=1
fi

# Test avec meme pointeur (cas special, meme si pas recommande)
echo -e "${YELLOW}🧪 Test avec echanges multiples...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <wchar.h>
#include <locale.h>

// Prototype de la fonction de l'etudiant
void pw_swap(int *a, int *b);

int main(void)
{
    setlocale(LC_ALL, "");

    int a = 1, b = 2;
    wprintf(L"Initial: a=%d, b=%d\n", a, b);
    
    // Premier echange
    pw_swap(&a, &b);
    wprintf(L"1er echange: a=%d, b=%d\n", a, b);
    
    // Deuxieme echange (doit revenir a l'etat initial)
    pw_swap(&a, &b);
    wprintf(L"2eme echange: a=%d, b=%d\n", a, b);
    
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MULTIPLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_MULTIPLE="Initial: a=1, b=2$
1er echange: a=2, b=1$
2eme echange: a=1, b=2$"
    if [ "$MULTIPLE_OUTPUT" = "$EXPECTED_MULTIPLE" ]; then
        echo -e "${GREEN}✅ Test echanges multiples reussi${NC}"
    else
        echo -e "${RED}❌ Test echanges multiples echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_MULTIPLE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$MULTIPLE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test echanges multiples${NC}"
    TEST_RESULT=1
fi

# Test de verification que les variables sont bien modifiees
echo -e "${YELLOW}🧪 Test de verification des modifications...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_swap(int *a, int *b);

int main(void)
{
    int original_a = 123;
    int original_b = 456;
    int a = original_a;
    int b = original_b;
    
    pw_swap(&a, &b);
    
    // Verifier que a contient maintenant la valeur originale de b
    // et que b contient maintenant la valeur originale de a
    if (a == original_b && b == original_a) {
        printf("SUCCESS\n");
    } else {
        printf("FAILED: a=%d (expected %d), b=%d (expected %d)\n", 
               a, original_b, b, original_a);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    VERIFICATION_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$VERIFICATION_OUTPUT" = "SUCCESS$" ]; then
        echo -e "${GREEN}✅ Test de verification reussi${NC}"
    else
        echo -e "${RED}❌ Test de verification echoue${NC}"
        echo -e "${RED}Sortie: '$VERIFICATION_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test de verification${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 017 valide avec succes${NC}"
    echo -e "${GREEN}La fonction echange correctement les valeurs via pointeurs!${NC}"
else
    echo -e "\n${RED}❌ Exercice 017 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"