#!/bin/bash

# Script de test pour l'exercice 013 : Afficher un nombre (récursif)
# Usage: ./test_ex013.sh

EXERCISE_DIR="ex013"
SOURCE_FILE="pw_putnbr.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 013 : Afficher un nombre (récursif) ===${NC}"

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
void pw_putnbr(unsigned int nb);

int main(void)
{
    // Test de la fonction pw_putnbr avec différents nombres
    pw_putnbr(42);
    write(1, "\n", 1);  // Ajout d'un retour à la ligne pour séparer
    
    pw_putnbr(0);
    write(1, "\n", 1);
    
    pw_putnbr(123456789);
    write(1, "\n", 1);
    
    pw_putnbr(999999999);  // UINT_MAX
    write(1, "\n", 1);
    
    pw_putnbr(1);
    write(1, "\n", 1);
    
    pw_putnbr(999);
    write(1, "\n", 1);
    
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
echo "42$"
echo "0$"
echo "123456789$"
echo "999999999$"
echo "1$"
echo "999$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="42$
0$
123456789$
999999999$
1$
999$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction affiche correctement tous les nombres${NC}"
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
    echo "pw_putnbr(42) -> attendu: 42"
    echo "pw_putnbr(0) -> attendu: 0"
    echo "pw_putnbr(123456789) -> attendu: 123456789"
    echo "pw_putnbr(999999999) -> attendu: 999999999"
    echo "pw_putnbr(1) -> attendu: 1"
    echo "pw_putnbr(999) -> attendu: 999"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec 42
echo -e "${YELLOW}🧪 Test individuel avec 42...${NC}"

# Créer un fichier de test pour une seule valeur
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(42);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "42" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '42')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec 0 (cas spécial)
echo -e "${YELLOW}🧪 Test avec 0...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(0);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_OUTPUT" = "0" ]; then
        echo -e "${GREEN}✅ Test avec 0 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec 0 échoué - Sortie: '$ZERO_OUTPUT' (attendu: '0')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec 0${NC}"
    TEST_RESULT=1
fi

# Test avec un chiffre unique (1)
echo -e "${YELLOW}🧪 Test avec 1...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(1);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ONE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ONE_OUTPUT" = "1" ]; then
        echo -e "${GREEN}✅ Test avec 1 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec 1 échoué - Sortie: '$ONE_OUTPUT' (attendu: '1')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec 1${NC}"
    TEST_RESULT=1
fi

# Test avec un grand nombre (UINT_MAX)
echo -e "${YELLOW}🧪 Test avec UINT_MAX (999999999)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(999999999);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MAX_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$MAX_OUTPUT" = "999999999" ]; then
        echo -e "${GREEN}✅ Test avec UINT_MAX réussi${NC}"
    else
        echo -e "${RED}❌ Test avec UINT_MAX échoué - Sortie: '$MAX_OUTPUT' (attendu: '999999999')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec UINT_MAX${NC}"
    TEST_RESULT=1
fi

# Test avec un nombre à 3 chiffres
echo -e "${YELLOW}🧪 Test avec 999...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(999);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NINE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NINE_OUTPUT" = "999" ]; then
        echo -e "${GREEN}✅ Test avec 999 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec 999 échoué - Sortie: '$NINE_OUTPUT' (attendu: '999')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec 999${NC}"
    TEST_RESULT=1
fi

# Test avec un nombre très long
echo -e "${YELLOW}🧪 Test avec 123456789...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(123456789);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LONG_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LONG_OUTPUT" = "123456789" ]; then
        echo -e "${GREEN}✅ Test avec 123456789 réussi${NC}"
    else
        echo -e "${RED}❌ Test avec 123456789 échoué - Sortie: '$LONG_OUTPUT' (attendu: '123456789')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec 123456789${NC}"
    TEST_RESULT=1
fi

# Test avec puissances de 10
echo -e "${YELLOW}🧪 Test avec puissances de 10...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'étudiant
void pw_putnbr(unsigned int nb);

int main(void)
{
    pw_putnbr(10);
    write(1, " ", 1);
    pw_putnbr(100);
    write(1, " ", 1);
    pw_putnbr(1000);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    POWERS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$POWERS_OUTPUT" = "10 100 1000" ]; then
        echo -e "${GREEN}✅ Test puissances de 10 réussi${NC}"
    else
        echo -e "${RED}❌ Test puissances de 10 échoué - Sortie: '$POWERS_OUTPUT' (attendu: '10 100 1000')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test puissances de 10${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 013 validé avec succès${NC}"
    echo -e "${GREEN}La fonction affiche correctement tous les nombres en utilisant la récursion!${NC}"
else
    echo -e "\n${RED}❌ Exercice 013 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"