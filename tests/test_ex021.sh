#!/bin/bash

# Script de test pour l'exercice 021 : Remplacer caracteres
# Usage: ./test_ex021.sh

EXERCISE_DIR="ex021"
SOURCE_FILE="pw_replace_chars.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 021 : Remplacer caracteres ===${NC}"

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
void pw_replace_chars(char *str);

int main(void)
{
    // Test de la fonction pw_replace_chars avec differentes chaines
    char str1[] = "Hello World";
    printf("Avant: \"%s\"\n", str1);
    pw_replace_chars(str1);
    printf("Apres: \"%s\"\n", str1);
    
    char str2[] = "Excellence in CODING";
    printf("Avant: \"%s\"\n", str2);
    pw_replace_chars(str2);
    printf("Apres: \"%s\"\n", str2);
    
    char str3[] = "test123";
    printf("Avant: \"%s\"\n", str3);
    pw_replace_chars(str3);
    printf("Apres: \"%s\"\n", str3);
    
    char str4[] = "UPPERCASE";
    printf("Avant: \"%s\"\n", str4);
    pw_replace_chars(str4);
    printf("Apres: \"%s\"\n", str4);
    
    char str5[] = "";
    printf("Avant: \"%s\"\n", str5);
    pw_replace_chars(str5);
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
echo "Avant: \"Hello World\"$"
echo "Apres: \"?*llo ?orld\"$"
echo "Avant: \"Excellence in CODING\"$"
echo "Apres: \"?xc*ll*nc* in ??????\"$"
echo "Avant: \"test123\"$"
echo "Apres: \"t*st123\"$"
echo "Avant: \"UPPERCASE\"$"
echo "Apres: \"?????????\"$"
echo "Avant: \"\"$"
echo "Apres: \"\"$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: \"Hello World\"$
Apres: \"?*llo ?orld\"$
Avant: \"Excellence in CODING\"$
Apres: \"?xc*ll*nc* in ??????\"$
Avant: \"test123\"$
Apres: \"t*st123\"$
Avant: \"UPPERCASE\"$
Apres: \"?????????\"$
Avant: \"\"$
Apres: \"\"$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction remplace correctement les caracteres${NC}"
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
    echo "pw_replace_chars(\"Hello World\") -> doit donner \"?*llo ?orld\""
    echo "pw_replace_chars(\"Excellence in CODING\") -> doit donner \"?xc*ll*nc* in ??????\""
    echo "pw_replace_chars(\"test123\") -> doit donner \"t*st123\""
    echo "pw_replace_chars(\"UPPERCASE\") -> doit donner \"?????????\""
    echo "pw_replace_chars(\"\") -> doit donner \"\""
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
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "Hello";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: Hello$
Apres: ?*llo$"
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

# Test avec chaine contenant seulement des 'e'
echo -e "${YELLOW}🧪 Test avec chaine de 'e'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "eeee";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    E_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_E="Avant: eeee$
Apres: ****$"
    if [ "$E_OUTPUT" = "$EXPECTED_E" ]; then
        echo -e "${GREEN}✅ Test chaine de 'e' reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine de 'e' echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_E"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$E_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine de 'e'${NC}"
    TEST_RESULT=1
fi

# Test avec chaine contenant seulement des majuscules
echo -e "${YELLOW}🧪 Test avec chaine de majuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "ABCD";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UPPER="Avant: ABCD$
Apres: ????$"
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
void pw_replace_chars(char *str);

int main(void)
{
    pw_replace_chars(NULL);
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
void pw_replace_chars(char *str);

int main(void)
{
    char empty[] = "";
    printf("Longueur avant: %zu\n", strlen(empty));
    pw_replace_chars(empty);
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

# Test avec 'E' majuscule (doit etre remplace par '?', pas par '*')
echo -e "${YELLOW}🧪 Test avec 'E' majuscule...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "ExcellencE";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    CAPITAL_E_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_CAPITAL_E="Avant: ExcellencE$
Apres: ?xc*ll*nc?$"
    if [ "$CAPITAL_E_OUTPUT" = "$EXPECTED_CAPITAL_E" ]; then
        echo -e "${GREEN}✅ Test 'E' majuscule reussi${NC}"
    else
        echo -e "${RED}❌ Test 'E' majuscule echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_CAPITAL_E"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$CAPITAL_E_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test 'E' majuscule${NC}"
    TEST_RESULT=1
fi

# Test avec tous les caracteres non modifies
echo -e "${YELLOW}🧪 Test avec caracteres non modifies...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()";
    char original[] = "abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()";
    pw_replace_chars(test);
    printf("Modifie: %s\n", test);
    printf("Original: %s\n", original);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UNCHANGED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UNCHANGED="Modifie: abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()$
Original: abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()$"
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

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 021 valide avec succes${NC}"
    echo -e "${GREEN}La fonction remplace correctement les caracteres!${NC}"
else
    echo -e "\n${RED}❌ Exercice 021 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"