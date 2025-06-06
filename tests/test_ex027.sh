#!/bin/bash

# Script de test pour l'exercice 027 : Convertir en majuscules
# Usage: ./test_ex027.sh

EXERCISE_DIR="ex027"
SOURCE_FILE="pw_to_uppercase.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 027 : Convertir en majuscules ===${NC}"

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
void pw_to_uppercase(char *str);

int main(void)
{
    // Test de la fonction pw_to_uppercase avec differentes chaines
    char str1[] = "hello world";
    printf("Avant: \"%s\"\n", str1);
    pw_to_uppercase(str1);
    printf("Apres: \"%s\"\n", str1);
    
    char str2[] = "Test123!@#";
    printf("Avant: \"%s\"\n", str2);
    pw_to_uppercase(str2);
    printf("Apres: \"%s\"\n", str2);
    
    char str3[] = "ALREADY UPPERCASE";
    printf("Avant: \"%s\"\n", str3);
    pw_to_uppercase(str3);
    printf("Apres: \"%s\"\n", str3);
    
    char str4[] = "mixedCASE";
    printf("Avant: \"%s\"\n", str4);
    pw_to_uppercase(str4);
    printf("Apres: \"%s\"\n", str4);
    
    char str5[] = "";
    printf("Avant: \"%s\"\n", str5);
    pw_to_uppercase(str5);
    printf("Apres: \"%s\"\n", str5);
    
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
echo "Avant: \"hello world\"$"
echo "Apres: \"HELLO WORLD\"$"
echo "Avant: \"Test123!@#\"$"
echo "Apres: \"TEST123!@#\"$"
echo "Avant: \"ALREADY UPPERCASE\"$"
echo "Apres: \"ALREADY UPPERCASE\"$"
echo "Avant: \"mixedCASE\"$"
echo "Apres: \"MIXEDCASE\"$"
echo "Avant: \"\"$"
echo "Apres: \"\"$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: \"hello world\"$
Apres: \"HELLO WORLD\"$
Avant: \"Test123!@#\"$
Apres: \"TEST123!@#\"$
Avant: \"ALREADY UPPERCASE\"$
Apres: \"ALREADY UPPERCASE\"$
Avant: \"mixedCASE\"$
Apres: \"MIXEDCASE\"$
Avant: \"\"$
Apres: \"\"$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction convertit correctement en majuscules${NC}"
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
    echo "pw_to_uppercase(\"hello world\") -> doit donner \"HELLO WORLD\""
    echo "pw_to_uppercase(\"Test123!@#\") -> doit donner \"TEST123!@#\""
    echo "pw_to_uppercase(\"ALREADY UPPERCASE\") -> doit donner \"ALREADY UPPERCASE\""
    echo "pw_to_uppercase(\"mixedCASE\") -> doit donner \"MIXEDCASE\""
    echo "pw_to_uppercase(\"\") -> doit donner \"\""
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "hello"
echo -e "${YELLOW}🧪 Test individuel avec 'hello'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "hello";
    printf("Avant: %s\n", test);
    pw_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: hello$
Apres: HELLO$"
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

# Test avec chaine contenant seulement des minuscules
echo -e "${YELLOW}🧪 Test avec chaine de minuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "abcdefghijklmnopqrstuvwxyz";
    printf("Avant: %s\n", test);
    pw_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LOWER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LOWER="Avant: abcdefghijklmnopqrstuvwxyz$
Apres: ABCDEFGHIJKLMNOPQRSTUVWXYZ$"
    if [ "$LOWER_OUTPUT" = "$EXPECTED_LOWER" ]; then
        echo -e "${GREEN}✅ Test chaine de minuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine de minuscules echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LOWER"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LOWER_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine de minuscules${NC}"
    TEST_RESULT=1
fi

# Test avec chaine contenant seulement des majuscules
echo -e "${YELLOW}🧪 Test avec chaine de majuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    printf("Avant: %s\n", test);
    pw_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UPPER="Avant: ABCDEFGHIJKLMNOPQRSTUVWXYZ$
Apres: ABCDEFGHIJKLMNOPQRSTUVWXYZ$"
    if [ "$UPPER_OUTPUT" = "$EXPECTED_UPPER" ]; then
        echo -e "${GREEN}✅ Test majuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test majuscules echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_UPPER"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$UPPER_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test majuscules${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    pw_to_uppercase(NULL);
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

# Test avec chaine vide
echo -e "${YELLOW}🧪 Test avec chaine vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char empty[] = "";
    printf("Longueur avant: %zu\n", strlen(empty));
    pw_to_uppercase(empty);
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

# Test avec caracteres speciaux et chiffres (ne doivent pas changer)
echo -e "${YELLOW}🧪 Test avec caracteres non modifies...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "123!@#$%^&*()_+-=[]{}|;':\",./<>?";
    char original[] = "123!@#$%^&*()_+-=[]{}|;':\",./<>?";
    pw_to_uppercase(test);
    printf("Modifie: %s\n", test);
    printf("Original: %s\n", original);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UNCHANGED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UNCHANGED="Modifie: 123!@#$%^&*()_+-=[]{}|;':\",./<>?$
Original: 123!@#$%^&*()_+-=[]{}|;':\",./<>?$"
    if [ "$UNCHANGED_OUTPUT" = "$EXPECTED_UNCHANGED" ]; then
        echo -e "${GREEN}✅ Test caracteres non modifies reussi${NC}"
    else
        echo -e "${RED}❌ Test caracteres non modifies echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_UNCHANGED"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$UNCHANGED_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caracteres non modifies${NC}"
    TEST_RESULT=1
fi

# Test avec espaces et tabulations
echo -e "${YELLOW}🧪 Test avec espaces et tabulations...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "hello\tworld\n test";
    printf("Avant: hello\\tworld\\n test\n");
    pw_to_uppercase(test);
    printf("Apres: HELLO\\tWORLD\\n TEST\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    WHITESPACE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_WHITESPACE="Avant: hello\\tworld\\n test$
Apres: HELLO\\tWORLD\\n TEST$"
    if [ "$WHITESPACE_OUTPUT" = "$EXPECTED_WHITESPACE" ]; then
        echo -e "${GREEN}✅ Test espaces et tabulations reussi${NC}"
    else
        echo -e "${RED}❌ Test espaces et tabulations echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_WHITESPACE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$WHITESPACE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test espaces et tabulations${NC}"
    TEST_RESULT=1
fi

# Test de verification caractere par caractere
echo -e "${YELLOW}🧪 Test de verification caractere par caractere...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_to_uppercase(char *str);

int main(void)
{
    char test[] = "aBc123XyZ";
    pw_to_uppercase(test);
    
    // Verifier chaque caractere individuellement
    if (test[0] == 'A' && test[1] == 'B' && test[2] == 'C' && 
        test[3] == '1' && test[4] == '2' && test[5] == '3' &&
        test[6] == 'X' && test[7] == 'Y' && test[8] == 'Z' && test[9] == '\0') {
        printf("VERIFICATION_SUCCESS\n");
    } else {
        printf("VERIFICATION_FAILED: %s\n", test);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    VERIFICATION_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if echo "$VERIFICATION_OUTPUT" | grep -q "VERIFICATION_SUCCESS"; then
        echo -e "${GREEN}✅ Test de verification caractere par caractere reussi${NC}"
    else
        echo -e "${RED}❌ Test de verification caractere par caractere echoue${NC}"
        echo -e "${RED}Sortie: '$VERIFICATION_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test de verification${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 027 valide avec succes${NC}"
    echo -e "${GREEN}La fonction convertit correctement les caracteres en majuscules!${NC}"
else
    echo -e "\n${RED}❌ Exercice 027 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"