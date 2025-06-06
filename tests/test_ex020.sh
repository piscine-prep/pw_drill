#!/bin/bash

# Script de test pour l'exercice 020 : Inverser une chaine
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

echo -e "${BLUE}=== Test de l'exercice 020 : Inverser une chaine ===${NC}"

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
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    // Test de la fonction pw_reverse_string avec differentes chaines
    char str1[] = "hello";
    printf("Avant: \"%s\"\n", str1);
    pw_reverse_string(str1);
    printf("Apres: \"%s\"\n", str1);
    
    char str2[] = "Powercoders";
    printf("Avant: \"%s\"\n", str2);
    pw_reverse_string(str2);
    printf("Apres: \"%s\"\n", str2);
    
    char str3[] = "a";
    printf("Avant: \"%s\"\n", str3);
    pw_reverse_string(str3);
    printf("Apres: \"%s\"\n", str3);
    
    char str4[] = "";
    printf("Avant: \"%s\"\n", str4);
    pw_reverse_string(str4);
    printf("Apres: \"%s\"\n", str4);
    
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
echo "Avant: \"hello\"$"
echo "Apres: \"olleh\"$"
echo "Avant: \"Powercoders\"$"
echo "Apres: \"sredocrewoP\"$"
echo "Avant: \"a\"$"
echo "Apres: \"a\"$"
echo "Avant: \"\"$"
echo "Apres: \"\"$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: \"hello\"$
Apres: \"olleh\"$
Avant: \"Powercoders\"$
Apres: \"sredocrewoP\"$
Avant: \"a\"$
Apres: \"a\"$
Avant: \"\"$
Apres: \"\"$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction inverse correctement les chaines${NC}"
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
    echo "pw_reverse_string(\"hello\") -> doit donner \"olleh\""
    echo "pw_reverse_string(\"Powercoders\") -> doit donner \"sredocrewoP\""
    echo "pw_reverse_string(\"a\") -> doit donner \"a\""
    echo "pw_reverse_string(\"\") -> doit donner \"\""
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "hello"
echo -e "${YELLOW}🧪 Test individuel avec 'hello'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char test[] = "hello";
    printf("Avant: %s\n", test);
    pw_reverse_string(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: hello$
Apres: olleh$"
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

# Test avec chaine vide
echo -e "${YELLOW}🧪 Test avec chaine vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char empty[] = "";
    printf("Longueur avant: %zu\n", strlen(empty));
    pw_reverse_string(empty);
    printf("Longueur apres: %zu\n", strlen(empty));
    printf("Contenu: '%s'\n", empty);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EMPTY="Longueur avant: 0$
Longueur apres: 0$
Contenu: ''$"
    if [ "$EMPTY_OUTPUT" = "$EXPECTED_EMPTY" ]; then
        echo -e "${GREEN}✅ Test chaine vide reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine vide echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_EMPTY"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$EMPTY_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine vide${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    pw_reverse_string(NULL);
    printf("Test NULL reussi\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "Test NULL reussi$" ]; then
        echo -e "${GREEN}✅ Test NULL reussi${NC}"
    else
        echo -e "${RED}❌ Test NULL echoue - Sortie: '$NULL_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test avec un caractere unique
echo -e "${YELLOW}🧪 Test avec un caractere...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char single[] = "X";
    printf("Avant: %s\n", single);
    pw_reverse_string(single);
    printf("Apres: %s\n", single);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_CHAR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE_CHAR="Avant: X$
Apres: X$"
    if [ "$SINGLE_CHAR_OUTPUT" = "$EXPECTED_SINGLE_CHAR" ]; then
        echo -e "${GREEN}✅ Test caractere unique reussi${NC}"
    else
        echo -e "${RED}❌ Test caractere unique echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SINGLE_CHAR"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SINGLE_CHAR_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractere unique${NC}"
    TEST_RESULT=1
fi

# Test avec chaine longue
echo -e "${YELLOW}🧪 Test avec chaine longue...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char long_str[] = "abcdefghijklmnopqrstuvwxyz";
    printf("Avant: %s\n", long_str);
    pw_reverse_string(long_str);
    printf("Apres: %s\n", long_str);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LONG_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LONG="Avant: abcdefghijklmnopqrstuvwxyz$
Apres: zyxwvutsrqponmlkjihgfedcba$"
    if [ "$LONG_OUTPUT" = "$EXPECTED_LONG" ]; then
        echo -e "${GREEN}✅ Test chaine longue reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine longue echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LONG"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LONG_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine longue${NC}"
    TEST_RESULT=1
fi

# Test avec double inversion pour verifier que ca revient a l'original
echo -e "${YELLOW}🧪 Test double inversion...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char original[] = "test123";
    char copy[20];
    strcpy(copy, original);
    
    printf("Original: %s\n", copy);
    
    // Premiere inversion
    pw_reverse_string(copy);
    printf("1ere inversion: %s\n", copy);
    
    // Deuxieme inversion (doit revenir a l'original)
    pw_reverse_string(copy);
    printf("2eme inversion: %s\n", copy);
    
    // Verifier si on a bien retrouve l'original
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
        echo -e "${GREEN}✅ Test double inversion reussi${NC}"
    else
        echo -e "${RED}❌ Test double inversion echoue${NC}"
        echo -e "${RED}Sortie: '$DOUBLE_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test double inversion${NC}"
    TEST_RESULT=1
fi

# Test avec chaine palindrome
echo -e "${YELLOW}🧪 Test avec palindrome...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_string(char *str);

int main(void)
{
    char palindrome[] = "racecar";
    printf("Avant: %s\n", palindrome);
    pw_reverse_string(palindrome);
    printf("Apres: %s\n", palindrome);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    PALINDROME_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_PALINDROME="Avant: racecar$
Apres: racecar$"
    if [ "$PALINDROME_OUTPUT" = "$EXPECTED_PALINDROME" ]; then
        echo -e "${GREEN}✅ Test palindrome reussi${NC}"
    else
        echo -e "${RED}❌ Test palindrome echoue${NC}"
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
    echo -e "\n${GREEN}✅ Exercice 020 valide avec succes${NC}"
    echo -e "${GREEN}La fonction inverse correctement les chaines de caracteres!${NC}"
else
    echo -e "\n${RED}❌ Exercice 020 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"