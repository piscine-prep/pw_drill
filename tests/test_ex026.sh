#!/bin/bash

# Script de test pour l'exercice 026 : Vérifier lettres minuscules
# Usage: ./test_ex026.sh

EXERCISE_DIR="ex026"
SOURCE_FILE="pw_is_lowercase.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 026 : Vérifier lettres minuscules ===${NC}"

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
int pw_is_lowercase(char *str);

int main(void)
{
    // Test de la fonction pw_is_lowercase avec différentes chaînes
    printf("Test avec \"hello\": %d\n", pw_is_lowercase("hello"));           // 1 (que des minuscules)
    printf("Test avec \"world\": %d\n", pw_is_lowercase("world"));           // 1 (que des minuscules)
    printf("Test avec \"Hello\": %d\n", pw_is_lowercase("Hello"));           // 0 (majuscule H)
    printf("Test avec \"test123\": %d\n", pw_is_lowercase("test123"));       // 0 (chiffres)
    printf("Test avec \"hello world\": %d\n", pw_is_lowercase("hello world")); // 0 (espace)
    printf("Test avec \"\": %d\n", pw_is_lowercase(""));                     // 0 (chaîne vide)
    printf("Test avec \"abcdef\": %d\n", pw_is_lowercase("abcdef"));         // 1 (que des minuscules)
    printf("Test avec \"ABC\": %d\n", pw_is_lowercase("ABC"));               // 0 (majuscules)
    printf("Test avec \"test!\": %d\n", pw_is_lowercase("test!"));           // 0 (caractère spécial)
    
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
echo "Test avec \"hello\": 1$"
echo "Test avec \"world\": 1$"
echo "Test avec \"Hello\": 0$"
echo "Test avec \"test123\": 0$"
echo "Test avec \"hello world\": 0$"
echo "Test avec \"\": 0$"
echo "Test avec \"abcdef\": 1$"
echo "Test avec \"ABC\": 0$"
echo "Test avec \"test!\": 0$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Test avec \"hello\": 1$
Test avec \"world\": 1$
Test avec \"Hello\": 0$
Test avec \"test123\": 0$
Test avec \"hello world\": 0$
Test avec \"\": 0$
Test avec \"abcdef\": 1$
Test avec \"ABC\": 0$
Test avec \"test!\": 0$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction vérifie correctement les lettres minuscules${NC}"
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
    echo "pw_is_lowercase(\"hello\") -> attendu: 1 (que des minuscules)"
    echo "pw_is_lowercase(\"world\") -> attendu: 1 (que des minuscules)"
    echo "pw_is_lowercase(\"Hello\") -> attendu: 0 (majuscule H)"
    echo "pw_is_lowercase(\"test123\") -> attendu: 0 (contient des chiffres)"
    echo "pw_is_lowercase(\"hello world\") -> attendu: 0 (contient un espace)"
    echo "pw_is_lowercase(\"\") -> attendu: 0 (chaîne vide)"
    echo "pw_is_lowercase(\"abcdef\") -> attendu: 1 (que des minuscules)"
    echo "pw_is_lowercase(\"ABC\") -> attendu: 0 (majuscules)"
    echo "pw_is_lowercase(\"test!\") -> attendu: 0 (caractère spécial)"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "hello"
echo -e "${YELLOW}🧪 Test individuel avec 'hello'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("hello"));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '1$')${NC}"
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
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase(NULL));
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

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase(""));
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

# Test avec un seul caractère minuscule
echo -e "${YELLOW}🧪 Test avec un caractère minuscule 'a'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("a"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_CHAR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_CHAR_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test caractère unique minuscule réussi${NC}"
    else
        echo -e "${RED}❌ Test caractère unique minuscule échoué - Sortie: '$SINGLE_CHAR_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractère unique minuscule${NC}"
    TEST_RESULT=1
fi

# Test avec un seul caractère majuscule
echo -e "${YELLOW}🧪 Test avec un caractère majuscule 'A'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("A"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_CHAR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$UPPER_CHAR_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test caractère unique majuscule réussi${NC}"
    else
        echo -e "${RED}❌ Test caractère unique majuscule échoué - Sortie: '$UPPER_CHAR_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractère unique majuscule${NC}"
    TEST_RESULT=1
fi

# Test avec alphabet complet en minuscules
echo -e "${YELLOW}🧪 Test avec alphabet complet minuscule...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("abcdefghijklmnopqrstuvwxyz"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ALPHABET_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ALPHABET_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test alphabet complet minuscule réussi${NC}"
    else
        echo -e "${RED}❌ Test alphabet complet minuscule échoué - Sortie: '$ALPHABET_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test alphabet complet${NC}"
    TEST_RESULT=1
fi

# Test avec mélange de caractères
echo -e "${YELLOW}🧪 Test avec mélange de caractères 'hello_world'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("hello_world"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UNDERSCORE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$UNDERSCORE_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test underscore réussi${NC}"
    else
        echo -e "${RED}❌ Test underscore échoué - Sortie: '$UNDERSCORE_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test underscore${NC}"
    TEST_RESULT=1
fi

# Test avec accents (caractères non-ASCII)
echo -e "${YELLOW}🧪 Test avec caractères accentués 'café'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("café"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ACCENT_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ACCENT_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test caractères accentués réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères accentués échoué - Sortie: '$ACCENT_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères accentués${NC}"
    TEST_RESULT=1
fi

# Test avec chiffres uniquement
echo -e "${YELLOW}🧪 Test avec chiffres uniquement '123456'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_lowercase(char *str);

int main(void)
{
    printf("%d\n", pw_is_lowercase("123456"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DIGITS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$DIGITS_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test chiffres uniquement réussi${NC}"
    else
        echo -e "${RED}❌ Test chiffres uniquement échoué - Sortie: '$DIGITS_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chiffres uniquement${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 026 validé avec succès${NC}"
    echo -e "${GREEN}La fonction vérifie correctement si une chaîne ne contient que des lettres minuscules!${NC}"
else
    echo -e "\n${RED}❌ Exercice 026 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"