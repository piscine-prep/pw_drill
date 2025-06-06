#!/bin/bash

# Script de test pour l'exercice 033 : Fichier d'implémentation pour calculatrice
# Usage: ./test_ex033.sh

EXERCISE_DIR="ex033"
SOURCE_FILE="pw_calc.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 033 : Fichier d'implémentation pour calculatrice ===${NC}"

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

# Créer le fichier de test avec le main fourni
cat > "$EXERCISE_DIR/$TEST_FILE" << 'EOF'
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
echo "Addition: 15$"
echo "Soustraction: 5$"
echo "Multiplication: 50$"
echo "Division: 2$"
echo "Maximum: 10$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Addition: 15$
Soustraction: 5$
Multiplication: 50$
Division: 2$
Maximum: 10$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! Le fichier d'implémentation fonctionne correctement${NC}"
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
    echo "pw_add(10, 5) -> doit donner 15"
    echo "pw_sub(10, 5) -> doit donner 5"
    echo "pw_mul(10, 5) -> doit donner 50"
    echo "pw_div(10, 5) -> doit donner 2"
    echo "pw_max(10, 5) -> doit donner 10"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test avec d'autres valeurs pour vérifier la robustesse
echo -e "${YELLOW}🧪 Test avec d'autres valeurs...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putstr(char *str);
void pw_putnbr(int nb);
int pw_add(int a, int b);
int pw_sub(int a, int b);
int pw_mul(int a, int b);
int pw_div(int a, int b);
int pw_max(int a, int b);

int main(void)
{
    int x = 20;
    int y = 8;
    
    pw_putstr("Test 2 - Addition: ");
    pw_putnbr(pw_add(x, y));
    pw_putstr("\n");
    
    pw_putstr("Test 2 - Maximum: ");
    pw_putnbr(pw_max(x, y));
    pw_putstr("\n");
    
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SECOND_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SECOND="Test 2 - Addition: 28$
Test 2 - Maximum: 20$"
    if [ "$SECOND_OUTPUT" = "$EXPECTED_SECOND" ]; then
        echo -e "${GREEN}✅ Test avec autres valeurs réussi${NC}"
    else
        echo -e "${RED}❌ Test avec autres valeurs échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SECOND"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SECOND_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec autres valeurs${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Test de la fonction pw_putstr seule
echo -e "${YELLOW}🧪 Test de pw_putstr...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putstr(char *str);

int main(void)
{
    pw_putstr("Hello World");
    pw_putstr("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    PUTSTR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$PUTSTR_OUTPUT" = "Hello World$" ]; then
        echo -e "${GREEN}✅ Test pw_putstr réussi${NC}"
    else
        echo -e "${RED}❌ Test pw_putstr échoué - Sortie: '$PUTSTR_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test pw_putstr${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Test de la fonction pw_putnbr seule
echo -e "${YELLOW}🧪 Test de pw_putnbr...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putnbr(int nb);

int main(void)
{
    pw_putnbr(42);
    pw_putnbr(127);
    pw_putnbr(0);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    PUTNBR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$PUTNBR_OUTPUT" = "421270" ]; then
        echo -e "${GREEN}✅ Test pw_putnbr réussi${NC}"
    else
        echo -e "${RED}❌ Test pw_putnbr échoué - Sortie: '$PUTNBR_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test pw_putnbr${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Test edge case avec MAX de nombres identiques
echo -e "${YELLOW}🧪 Test MAX avec nombres identiques...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putstr(char *str);
void pw_putnbr(int nb);
int pw_max(int a, int b);

int main(void)
{
    int same = 7;
    pw_putstr("MAX identiques: ");
    pw_putnbr(pw_max(same, same));
    pw_putstr("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SAME_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SAME_OUTPUT" = "MAX identiques: 7$" ]; then
        echo -e "${GREEN}✅ Test MAX identiques réussi${NC}"
    else
        echo -e "${RED}❌ Test MAX identiques échoué - Sortie: '$SAME_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test MAX identiques${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Test de division avec reste
echo -e "${YELLOW}🧪 Test division avec reste...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putstr(char *str);
void pw_putnbr(int nb);
int pw_div(int a, int b);

int main(void)
{
    pw_putstr("Division 7/3: ");
    pw_putnbr(pw_div(7, 3));
    pw_putstr("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DIV_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$DIV_OUTPUT" = "Division 7/3: 2$" ]; then
        echo -e "${GREEN}✅ Test division avec reste réussi${NC}"
    else
        echo -e "${RED}❌ Test division avec reste échoué - Sortie: '$DIV_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test division avec reste${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Test avec zéro
echo -e "${YELLOW}🧪 Test avec zéro...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototypes des fonctions
void pw_putstr(char *str);
void pw_putnbr(int nb);
int pw_add(int a, int b);
int pw_mul(int a, int b);

int main(void)
{
    pw_putstr("Addition avec 0: ");
    pw_putnbr(pw_add(5, 0));
    pw_putstr("\n");
    
    pw_putstr("Multiplication par 0: ");
    pw_putnbr(pw_mul(5, 0));
    pw_putstr("\n");
    
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ZERO="Addition avec 0: 5$
Multiplication par 0: 0$"
    if [ "$ZERO_OUTPUT" = "$EXPECTED_ZERO" ]; then
        echo -e "${GREEN}✅ Test avec zéro réussi${NC}"
    else
        echo -e "${RED}❌ Test avec zéro échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ZERO"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ZERO_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec zéro${NC}"
    cat compilation_errors.txt
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 033 validé avec succès${NC}"
    echo -e "${GREEN}Le fichier pw_calc.c fonctionne correctement!${NC}"
else
    echo -e "\n${RED}❌ Exercice 033 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"