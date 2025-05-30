#!/bin/bash

# Script de test pour l'exercice 030 : Afficher la memoire
# Usage: ./test_ex030.sh

EXERCISE_DIR="ex030"
SOURCE_FILE="pw_print_memory.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 030 : Afficher la memoire ===${NC}"

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

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    // Test de la fonction pw_print_memory avec differentes donnees
    char str1[] = "Hello World";
    pw_print_memory(str1, 11);
    write(1, "\n", 1);  // Separateur pour les tests
    
    // Test avec caracteres non imprimables
    char data[] = {'A', 'B', 'C', 1, 2, 3, 'D', 'E', 'F'};
    pw_print_memory(data, 9);
    write(1, "\n", 1);
    
    // Test avec chaine normale
    char str2[] = "Test123!";
    pw_print_memory(str2, 8);
    write(1, "\n", 1);
    
    // Test avec taille partielle
    char str3[] = "Programming";
    pw_print_memory(str3, 4);
    write(1, "\n", 1);
    
    // Test avec taille 0
    char str4[] = "Nothing";
    pw_print_memory(str4, 0);
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
echo "Hello World$"
echo "ABC...DEF$"
echo "Test123!$"
echo "Prog$"
echo "$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Hello World$
ABC...DEF$
Test123!$
Prog$
$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction affiche correctement le contenu de la memoire${NC}"
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
    echo "pw_print_memory(\"Hello World\", 11) -> doit donner \"Hello World\""
    echo "pw_print_memory(data_avec_non_imprimables, 9) -> doit donner \"ABC...DEF\""
    echo "pw_print_memory(\"Test123!\", 8) -> doit donner \"Test123!\""
    echo "pw_print_memory(\"Programming\", 4) -> doit donner \"Prog\""
    echo "pw_print_memory(quelconque, 0) -> doit donner rien"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "Hi"
echo -e "${YELLOW}🧪 Test individuel avec 'Hi'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    char test[] = "Hi";
    pw_print_memory(test, 2);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "Hi" ]; then
        echo -e "${GREEN}✅ Test individuel reussi${NC}"
    else
        echo -e "${RED}❌ Test individuel echoue - Sortie: '$SINGLE_OUTPUT' (attendu: 'Hi')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    pw_print_memory(NULL, 5);
    write(1, "OK", 2);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "OK" ]; then
        echo -e "${GREEN}✅ Test NULL reussi${NC}"
    else
        echo -e "${RED}❌ Test NULL echoue - Sortie: '$NULL_OUTPUT' (attendu: 'OK')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test avec taille 0
echo -e "${YELLOW}🧪 Test avec taille 0...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    char test[] = "test";
    pw_print_memory(test, 0);
    write(1, "DONE", 4);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_OUTPUT" = "DONE" ]; then
        echo -e "${GREEN}✅ Test taille 0 reussi${NC}"
    else
        echo -e "${RED}❌ Test taille 0 echoue - Sortie: '$ZERO_OUTPUT' (attendu: 'DONE')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test taille 0${NC}"
    TEST_RESULT=1
fi

# Test avec caracteres non imprimables specifiques
echo -e "${YELLOW}🧪 Test avec caracteres non imprimables...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    // Creer un tableau avec caracteres non imprimables
    unsigned char test_data[6];
    test_data[0] = 'A';     // Imprimable
    test_data[1] = 31;      // Non imprimable (< 32)
    test_data[2] = 32;      // Espace (imprimable)
    test_data[3] = 126;     // ~ (imprimable)
    test_data[4] = 127;     // DEL (non imprimable)
    test_data[5] = 'Z';     // Imprimable
    
    pw_print_memory(test_data, 6);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UNPRINTABLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # Doit donner: A (char 65), . (char 31), espace (char 32), ~ (char 126), . (char 127), Z (char 90)
    if [ "$UNPRINTABLE_OUTPUT" = "A. ~.Z" ]; then
        echo -e "${GREEN}✅ Test caracteres non imprimables reussi${NC}"
    else
        echo -e "${RED}❌ Test caracteres non imprimables echoue - Sortie: '$UNPRINTABLE_OUTPUT' (attendu: 'A. ~.Z')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caracteres non imprimables${NC}"
    TEST_RESULT=1
fi

# Test avec caracteres speciaux imprimables
echo -e "${YELLOW}🧪 Test avec caracteres speciaux imprimables...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    char special[] = "!@#$%^&*()";
    pw_print_memory(special, 10);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPECIAL_OUTPUT" = "!@#$%^&*()" ]; then
        echo -e "${GREEN}✅ Test caracteres speciaux imprimables reussi${NC}"
    else
        echo -e "${RED}❌ Test caracteres speciaux imprimables echoue - Sortie: '$SPECIAL_OUTPUT' (attendu: '!@#$%^&*()')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caracteres speciaux imprimables${NC}"
    TEST_RESULT=1
fi

# Test avec melange de caracteres imprimables et non imprimables
echo -e "${YELLOW}🧪 Test avec melange...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>

// Prototype de la fonction de l'etudiant
void pw_print_memory(void *addr, size_t size);

int main(void)
{
    unsigned char mixed[] = {72, 101, 108, 108, 111, 0, 9, 87, 111, 114, 108, 100}; // "Hello" + null + tab + "World"
    pw_print_memory(mixed, 12);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MIXED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # "Hello" + '.' (pour \0) + '.' (pour \t) + "World"
    if [ "$MIXED_OUTPUT" = "Hello..World" ]; then
        echo -e "${GREEN}✅ Test melange reussi${NC}"
    else
        echo -e "${RED}❌ Test melange echoue - Sortie: '$MIXED_OUTPUT' (attendu: 'Hello..World')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test melange${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 030 valide avec succes${NC}"
    echo -e "${GREEN}La fonction affiche correctement le contenu de la memoire!${NC}"
else
    echo -e "\n${RED}❌ Exercice 030 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"