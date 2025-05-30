#!/bin/bash

# Script de test pour l'exercice 031 : Extraire les chiffres
# Usage: ./test_ex032.sh

EXERCISE_DIR="ex032"
SOURCE_FILE="pw_extract_digits.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 031 : Extraire les chiffres ===${NC}"

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
int pw_extract_digits(char *str);

int main(void)
{
    // Test de la fonction pw_extract_digits avec différentes chaînes
    printf("Test avec \"abc123def456\": %d\n", pw_extract_digits("abc123def456"));
    printf("Test avec \"42 School\": %d\n", pw_extract_digits("42 School"));
    printf("Test avec \"Hello World\": %d\n", pw_extract_digits("Hello World"));
    printf("Test avec \"a1b2c3\": %d\n", pw_extract_digits("a1b2c3"));
    printf("Test avec \"\": %d\n", pw_extract_digits(""));
    printf("Test avec \"999\": %d\n", pw_extract_digits("999"));
    printf("Test avec \"No digits here!\": %d\n", pw_extract_digits("No digits here!"));
    
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
echo "Test avec \"abc123def456\": 123456$"
echo "Test avec \"42 School\": 42$"
echo "Test avec \"Hello World\": 0$"
echo "Test avec \"a1b2c3\": 123$"
echo "Test avec \"\": 0$"
echo "Test avec \"999\": 999$"
echo "Test avec \"No digits here!\": 0$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Test avec \"abc123def456\": 123456$
Test avec \"42 School\": 42$
Test avec \"Hello World\": 0$
Test avec \"a1b2c3\": 123$
Test avec \"\": 0$
Test avec \"999\": 999$
Test avec \"No digits here!\": 0$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction extrait correctement les chiffres${NC}"
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
    echo "pw_extract_digits(\"abc123def456\") -> attendu: 123456"
    echo "pw_extract_digits(\"42 School\") -> attendu: 42"
    echo "pw_extract_digits(\"Hello World\") -> attendu: 0"
    echo "pw_extract_digits(\"a1b2c3\") -> attendu: 123"
    echo "pw_extract_digits(\"\") -> attendu: 0"
    echo "pw_extract_digits(\"999\") -> attendu: 999"
    echo "pw_extract_digits(\"No digits here!\") -> attendu: 0"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "abc123def456"
echo -e "${YELLOW}🧪 Test individuel avec 'abc123def456'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("abc123def456");
    printf("%d\n", result);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "123456$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '123456$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EMPTY_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test chaîne vide réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne vide échoué - Sortie: '$EMPTY_OUTPUT' (attendu: '0$')${NC}"
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
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits(NULL);
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test NULL échoué - Sortie: '$NULL_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test avec seulement des chiffres
echo -e "${YELLOW}🧪 Test avec seulement des chiffres...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("123456789");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DIGITS_ONLY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$DIGITS_ONLY_OUTPUT" = "123456789$" ]; then
        echo -e "${GREEN}✅ Test seulement des chiffres réussi${NC}"
    else
        echo -e "${RED}❌ Test seulement des chiffres échoué - Sortie: '$DIGITS_ONLY_OUTPUT' (attendu: '123456789$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test seulement des chiffres${NC}"
    TEST_RESULT=1
fi

# Test avec caractères spéciaux et espaces
echo -e "${YELLOW}🧪 Test avec caractères spéciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("!@#1$%^2&*()3");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPECIAL_OUTPUT" = "123$" ]; then
        echo -e "${GREEN}✅ Test caractères spéciaux réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères spéciaux échoué - Sortie: '$SPECIAL_OUTPUT' (attendu: '123$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères spéciaux${NC}"
    TEST_RESULT=1
fi

# Test avec zéros en début
echo -e "${YELLOW}🧪 Test avec zéros en début...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("abc000123def");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZEROS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 000123 doit donner 123 (les zéros en début sont ignorés par la conversion en int)
    if [ "$ZEROS_OUTPUT" = "123$" ]; then
        echo -e "${GREEN}✅ Test zéros en début réussi${NC}"
    else
        echo -e "${RED}❌ Test zéros en début échoué - Sortie: '$ZEROS_OUTPUT' (attendu: '123$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test zéros en début${NC}"
    TEST_RESULT=1
fi

# Test avec un seul chiffre
echo -e "${YELLOW}🧪 Test avec un seul chiffre...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("abc7def");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_DIGIT_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_DIGIT_OUTPUT" = "7$" ]; then
        echo -e "${GREEN}✅ Test un seul chiffre réussi${NC}"
    else
        echo -e "${RED}❌ Test un seul chiffre échoué - Sortie: '$SINGLE_DIGIT_OUTPUT' (attendu: '7$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test un seul chiffre${NC}"
    TEST_RESULT=1
fi

# Test avec chiffres séparés par beaucoup de caractères
echo -e "${YELLOW}🧪 Test avec chiffres très séparés...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("1aaaaaaaa2bbbbbbb3ccccccc4");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SEPARATED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SEPARATED_OUTPUT" = "1234$" ]; then
        echo -e "${GREEN}✅ Test chiffres très séparés réussi${NC}"
    else
        echo -e "${RED}❌ Test chiffres très séparés échoué - Sortie: '$SEPARATED_OUTPUT' (attendu: '1234$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chiffres très séparés${NC}"
    TEST_RESULT=1
fi

# Test avec seulement le chiffre 0
echo -e "${YELLOW}🧪 Test avec seulement '0'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_extract_digits(char *str);

int main(void)
{
    int result = pw_extract_digits("abc0def");
    printf("%d\n", result);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_ONLY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_ONLY_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test seulement '0' réussi${NC}"
    else
        echo -e "${RED}❌ Test seulement '0' échoué - Sortie: '$ZERO_ONLY_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test seulement '0'${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 031 validé avec succès${NC}"
    echo -e "${GREEN}La fonction extrait correctement les chiffres des chaînes!${NC}"
else
    echo -e "\n${RED}❌ Exercice 031 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"