#!/bin/bash

# Script de test pour l'exercice 011 : Pair ou Impair
# Usage: ./test_ex011.sh

EXERCISE_DIR="ex011"
SOURCE_FILE="pw_pair_impair.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 011 : Pair ou Impair ===${NC}"

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
char pw_pair_impair(char *str);

int main(void)
{
    // Test de la fonction pw_pair_impair avec différentes chaînes
    
    printf("Test avec \"Hello\": %c\n", pw_pair_impair("Hello"));          // 5 lettres -> I (impair)
    printf("Test avec \"Code\": %c\n", pw_pair_impair("Code"));            // 4 lettres -> P (pair)
    printf("Test avec \"\": %c\n", pw_pair_impair(""));                    // 0 lettres -> P (pair)
    printf("Test avec \"42 School\": %c\n", pw_pair_impair("42 School"));  // 6 lettres (School) -> P (pair)
    printf("Test avec NULL: %c\n", pw_pair_impair(NULL));                  // NULL -> N
    
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
echo "Test avec \"Hello\": I$"
echo "Test avec \"Code\": P$"
echo "Test avec \"\": P$"
echo "Test avec \"42 School\": P$"
echo "Test avec NULL: N$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Test avec \"Hello\": I$
Test avec \"Code\": P$
Test avec \"\": P$
Test avec \"42 School\": P$
Test avec NULL: N$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction détermine correctement pair/impair${NC}"
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
    echo "pw_pair_impair(\"Hello\") -> attendu: I (5 lettres = impair)"
    echo "pw_pair_impair(\"Code\") -> attendu: P (4 lettres = pair)"
    echo "pw_pair_impair(\"\") -> attendu: P (0 lettres = pair)"
    echo "pw_pair_impair(\"42 School\") -> attendu: P (6 lettres = pair)"
    echo "pw_pair_impair(NULL) -> attendu: N (NULL)"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "Hello"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair("Hello"));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "I$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: 'I$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec "Code" pour vérifier nombre pair
echo -e "${YELLOW}🧪 Test avec 'Code'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair("Code"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    CODE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$CODE_OUTPUT" = "P$" ]; then
        echo -e "${GREEN}✅ Test 'Code' réussi${NC}"
    else
        echo -e "${RED}❌ Test 'Code' échoué - Sortie: '$CODE_OUTPUT' (attendu: 'P$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test 'Code'${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne contenant chiffres et espaces
echo -e "${YELLOW}🧪 Test avec '42 School'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair("42 School"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SCHOOL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SCHOOL_OUTPUT" = "P$" ]; then
        echo -e "${GREEN}✅ Test '42 School' réussi${NC}"
    else
        echo -e "${RED}❌ Test '42 School' échoué - Sortie: '$SCHOOL_OUTPUT' (attendu: 'P$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test '42 School'${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair(""));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EMPTY_OUTPUT" = "P$" ]; then
        echo -e "${GREEN}✅ Test chaîne vide réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne vide échoué - Sortie: '$EMPTY_OUTPUT' (attendu: 'P$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne vide${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair(NULL));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "N$" ]; then
        echo -e "${GREEN}✅ Test NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test NULL échoué - Sortie: '$NULL_OUTPUT' (attendu: 'N$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test supplémentaire avec mélange majuscules/minuscules
echo -e "${YELLOW}🧪 Test avec 'HeLLo WoRLd'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
char pw_pair_impair(char *str);

int main(void)
{
    printf("%c\n", pw_pair_impair("HeLLo WoRLd"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MIXED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # "HeLLo WoRLd" = 10 lettres -> P (pair)
    if [ "$MIXED_OUTPUT" = "P$" ]; then
        echo -e "${GREEN}✅ Test majuscules/minuscules réussi${NC}"
    else
        echo -e "${RED}❌ Test majuscules/minuscules échoué - Sortie: '$MIXED_OUTPUT' (attendu: 'P$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test majuscules/minuscules${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 011 validé avec succès${NC}"
else
    echo -e "\n${RED}❌ Exercice 011 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"