#!/bin/bash

# Script de test pour l'exercice 010 : Compter les lettres E
# Usage: ./test_ex010.sh

EXERCISE_DIR="ex010"
SOURCE_FILE="pw_count_e.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 010 : Compter les lettres E ===${NC}"

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
int pw_count_e(char *str);

int main(void)
{
    // Test de la fonction pw_count_e avec differentes chaines
    printf("Test avec \"Hello\": %d\n", pw_count_e("Hello"));              // 1 occurrence de 'e'
    printf("Test avec \"excellence\": %d\n", pw_count_e("excellence"));    // 4 occurrences de 'e'
    printf("Test avec \"HELLO\": %d\n", pw_count_e("HELLO"));              // 0 occurrence de 'e' (majuscules)
    printf("Test avec \"\": %d\n", pw_count_e(""));                        // 0 occurrence (chaine vide)
    
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
echo "Test avec \"Hello\": 1$"
echo "Test avec \"excellence\": 4$"
echo "Test avec \"HELLO\": 0$"
echo "Test avec \"\": 0$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Test avec \"Hello\": 1$
Test avec \"excellence\": 4$
Test avec \"HELLO\": 0$
Test avec \"\": 0$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction compte correctement les lettres 'e'${NC}"
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
    echo "pw_count_e(\"Hello\") -> attendu: 1 (1 'e' minuscule)"
    echo "pw_count_e(\"excellence\") -> attendu: 4 (4 'e' minuscules)"
    echo "pw_count_e(\"HELLO\") -> attendu: 0 (pas de 'e' minuscule)"
    echo "pw_count_e(\"\") -> attendu: 0 (chaine vide)"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "Hello"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_count_e(char *str);

int main(void)
{
    printf("%d\n", pw_count_e("Hello"));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test individuel reussi${NC}"
    else
        echo -e "${RED}❌ Test individuel echoue - Sortie: '$SINGLE_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec "excellence" pour verifier les multiples occurrences
echo -e "${YELLOW}🧪 Test avec 'excellence'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_count_e(char *str);

int main(void)
{
    printf("%d\n", pw_count_e("excellence"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EXCELLENCE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EXCELLENCE_OUTPUT" = "4$" ]; then
        echo -e "${GREEN}✅ Test 'excellence' reussi${NC}"
    else
        echo -e "${RED}❌ Test 'excellence' echoue - Sortie: '$EXCELLENCE_OUTPUT' (attendu: '4$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test 'excellence'${NC}"
    TEST_RESULT=1
fi

# Test avec chaine en majuscules pour verifier qu'on ne compte que les minuscules
echo -e "${YELLOW}🧪 Test avec 'HELLO' (majuscules)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_count_e(char *str);

int main(void)
{
    printf("%d\n", pw_count_e("HELLO"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    HELLO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$HELLO_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test majuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test majuscules echoue - Sortie: '$HELLO_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test majuscules${NC}"
    TEST_RESULT=1
fi

# Test avec chaine vide
echo -e "${YELLOW}🧪 Test avec chaine vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
int pw_count_e(char *str);

int main(void)
{
    printf("%d\n", pw_count_e(""));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EMPTY_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test chaine vide reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine vide echoue - Sortie: '$EMPTY_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine vide${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 010 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 010 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"