#!/bin/bash

# Script de test pour l'exercice 006 : Compter de N à 0
# Usage: ./test_ex006.sh

EXERCISE_DIR="ex006"
SOURCE_FILE="pw_count_reverse.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 006 : Compter de N à 0 ===${NC}"

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

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    // Test de la fonction pw_count_reverse avec différents nombres (0-9)
    pw_count_reverse(3);
    write(1, "---\n", 4);  // Séparateur pour les tests
    pw_count_reverse(9);
    write(1, "---\n", 4);  // Séparateur pour les tests
    pw_count_reverse(0);
    
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
echo "3$"
echo "2$"
echo "1$"
echo "0$"
echo "---$"
echo "9$"
echo "8$"
echo "7$"
echo "6$"
echo "5$"
echo "4$"
echo "3$"
echo "2$"
echo "1$"
echo "0$"
echo "---$"
echo "0$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="3$
2$
1$
0$
---$
9$
8$
7$
6$
5$
4$
3$
2$
1$
0$
---$
0$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction compte correctement de N à 0${NC}"
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
    echo "pw_count_reverse(3) -> attendu: 3, 2, 1, 0"
    echo "pw_count_reverse(9) -> attendu: 9, 8, 7, 6, 5, 4, 3, 2, 1, 0"
    echo "pw_count_reverse(0) -> attendu: 0"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec n=3
echo -e "${YELLOW}🧪 Test individuel avec n=3...${NC}"

# Créer un fichier de test pour une seule valeur
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(3);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="3$
2$
1$
0$"
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

# Test avec n=0
echo -e "${YELLOW}🧪 Test avec n=0...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(0);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test avec n=0 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec n=0 échoué - Sortie: '$ZERO_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec n=0${NC}"
    TEST_RESULT=1
fi

# Test avec n=1
echo -e "${YELLOW}🧪 Test avec n=1...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(1);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ONE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ONE="1$
0$"
    if [ "$ONE_OUTPUT" = "$EXPECTED_ONE" ]; then
        echo -e "${GREEN}✅ Test avec n=1 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec n=1 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ONE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ONE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec n=1${NC}"
    TEST_RESULT=1
fi

# Test avec un chiffre plus grand (5)
echo -e "${YELLOW}🧪 Test avec n=5...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(5);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    FIVE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_FIVE="5$
4$
3$
2$
1$
0$"
    if [ "$FIVE_OUTPUT" = "$EXPECTED_FIVE" ]; then
        echo -e "${GREEN}✅ Test avec n=5 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec n=5 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_FIVE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$FIVE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec n=5${NC}"
    TEST_RESULT=1
fi

# Test avec n=2 pour vérifier l'ordre décroissant
echo -e "${YELLOW}🧪 Test avec n=2...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(2);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TWO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_TWO="2$
1$
0$"
    if [ "$TWO_OUTPUT" = "$EXPECTED_TWO" ]; then
        echo -e "${GREEN}✅ Test avec n=2 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec n=2 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_TWO"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$TWO_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec n=2${NC}"
    TEST_RESULT=1
fi

# Test avec le maximum autorisé (9)
echo -e "${YELLOW}🧪 Test avec n=9...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_count_reverse(unsigned int n);

int main(void)
{
    pw_count_reverse(9);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NINE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NINE="9$
8$
7$
6$
5$
4$
3$
2$
1$
0$"
    if [ "$NINE_OUTPUT" = "$EXPECTED_NINE" ]; then
        echo -e "${GREEN}✅ Test avec n=9 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec n=9 échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NINE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NINE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec n=9${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 006 validé avec succès${NC}"
else
    echo -e "\n${RED}❌ Exercice 006 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"