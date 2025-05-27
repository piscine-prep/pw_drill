#!/bin/bash

# Script de test pour l'exercice 020 : Inverser une chaîne
# Usage: ./test_ex020.sh

EXERCISE_DIR="ex020"
SOURCE_FILE="pw_reverse_string.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 020 : Inverser une chaîne ===${NC}"

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
#include <string.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    // Test de la fonction pw_reverse_string avec différentes chaînes
    char str1[] = "hello";
    printf("Avant: \"%s\"\n", str1);
    pw_reverse_string(str1);
    printf("Après: \"%s\"\n", str1);
    
    char str2[] = "Powercoders";
    printf("Avant: \"%s\"\n", str2);
    pw_reverse_string(str2);
    printf("Après: \"%s\"\n", str2);
    
    char str3[] = "a";
    printf("Avant: \"%s\"\n", str3);
    pw_reverse_string(str3);
    printf("Après: \"%s\"\n", str3);
    
    char str4[] = "";
    printf("Avant: \"%s\"\n", str4);
    pw_reverse_string(str4);
    printf("Après: \"%s\"\n", str4);
    
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
echo "Avant: \"hello\"$"
echo "Après: \"olleh\"$"
echo "Avant: \"Powercoders\"$"
echo "Après: \"sredocrewoP\"$"
echo "Avant: \"a\"$"
echo "Après: \"a\"$"
echo "Avant: \"\"$"
echo "Après: \"\"$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Avant: \"hello\"$
Après: \"olleh\"$
Avant: \"Powercoders\"$
Après: \"sredocrewoP\"$
Avant: \"a\"$
Après: \"a\"$
Avant: \"\"$
Après: \"\"$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction inverse correctement les chaînes${NC}"
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
    echo "pw_reverse_string(\"hello\") -> doit donner \"olleh\""
    echo "pw_reverse_string(\"Powercoders\") -> doit donner \"sredocrewoP\""
    echo "pw_reverse_string(\"a\") -> doit donner \"a\""
    echo "pw_reverse_string(\"\") -> doit donner \"\""
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "hello"
echo -e "${YELLOW}🧪 Test individuel avec 'hello'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char test[] = "hello";
    printf("Avant: %s\n", test);
    pw_reverse_string(test);
    printf("Après: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: hello$
Après: olleh$"
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

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char empty[] = "";
    printf("Longueur avant: %zu\n", strlen(empty));
    pw_reverse_string(empty);
    printf("Longueur après: %zu\n", strlen(empty));
    printf("Contenu: '%s'\n", empty);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EMPTY="Longueur avant: 0$
Longueur après: 0$
Contenu: ''$"
    if [ "$EMPTY_OUTPUT" = "$EXPECTED_EMPTY" ]; then
        echo -e "${GREEN}✅ Test chaîne vide réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne vide échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_EMPTY"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$EMPTY_OUTPUT"
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
void pw_reverse_string(char *str);

int main(void)
{
    pw_reverse_string(NULL);
    printf("Test NULL réussi\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "Test NULL réussi$" ]; then
        echo -e "${GREEN}✅ Test NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test NULL échoué - Sortie: '$NULL_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test avec un caractère unique
echo -e "${YELLOW}🧪 Test avec un caractère...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char single[] = "X";
    printf("Avant: %s\n", single);
    pw_reverse_string(single);
    printf("Après: %s\n", single);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_CHAR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE_CHAR="Avant: X$
Après: X$"
    if [ "$SINGLE_CHAR_OUTPUT" = "$EXPECTED_SINGLE_CHAR" ]; then
        echo -e "${GREEN}✅ Test caractère unique réussi${NC}"
    else
        echo -e "${RED}❌ Test caractère unique échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SINGLE_CHAR"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SINGLE_CHAR_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractère unique${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne longue
echo -e "${YELLOW}🧪 Test avec chaîne longue...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char long_str[] = "abcdefghijklmnopqrstuvwxyz";
    printf("Avant: %s\n", long_str);
    pw_reverse_string(long_str);
    printf("Après: %s\n", long_str);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LONG_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LONG="Avant: abcdefghijklmnopqrstuvwxyz$
Après: zyxwvutsrqponmlkjihgfedcba$"
    if [ "$LONG_OUTPUT" = "$EXPECTED_LONG" ]; then
        echo -e "${GREEN}✅ Test chaîne longue réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne longue échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LONG"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LONG_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne longue${NC}"
    TEST_RESULT=1
fi

# Test avec double inversion pour vérifier que ça revient à l'original
echo -e "${YELLOW}🧪 Test double inversion...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char original[] = "test123";
    char copy[20];
    strcpy(copy, original);
    
    printf("Original: %s\n", copy);
    
    // Première inversion
    pw_reverse_string(copy);
    printf("1ère inversion: %s\n", copy);
    
    // Deuxième inversion (doit revenir à l'original)
    pw_reverse_string(copy);
    printf("2ème inversion: %s\n", copy);
    
    // Vérifier si on a bien retrouvé l'original
    if (strcmp(copy, original) == 0) {
        printf("DOUBLE_INVERSION_SUCCESS\n");
    } else {
        printf("DOUBLE_INVERSION_FAILED\n");
    }
    
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DOUBLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if echo "$DOUBLE_OUTPUT" | grep -q "DOUBLE_INVERSION_SUCCESS"; then
        echo -e "${GREEN}✅ Test double inversion réussi${NC}"
    else
        echo -e "${RED}❌ Test double inversion échoué${NC}"
        echo -e "${RED}Sortie: '$DOUBLE_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test double inversion${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne palindrome
echo -e "${YELLOW}🧪 Test avec palindrome...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_reverse_string(char *str);

int main(void)
{
    char palindrome[] = "racecar";
    printf("Avant: %s\n", palindrome);
    pw_reverse_string(palindrome);
    printf("Après: %s\n", palindrome);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    PALINDROME_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_PALINDROME="Avant: racecar$
Après: racecar$"
    if [ "$PALINDROME_OUTPUT" = "$EXPECTED_PALINDROME" ]; then
        echo -e "${GREEN}✅ Test palindrome réussi${NC}"
    else
        echo -e "${RED}❌ Test palindrome échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_PALINDROME"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$PALINDROME_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test palindrome${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 020 validé avec succès${NC}"
    echo -e "${GREEN}La fonction inverse correctement les chaînes de caractères!${NC}"
else
    echo -e "\n${RED}❌ Exercice 020 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"