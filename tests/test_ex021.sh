#!/bin/bash

# Script de test pour l'exercice 021 : Remplacer caractères
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

echo -e "${BLUE}=== Test de l'exercice 021 : Remplacer caractères ===${NC}"

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
void pw_replace_chars(char *str);

int main(void)
{
    // Test de la fonction pw_replace_chars avec différentes chaînes
    char str1[] = "Hello World";
    printf("Avant: \"%s\"\n", str1);
    pw_replace_chars(str1);
    printf("Après: \"%s\"\n", str1);
    
    char str2[] = "Excellence in CODING";
    printf("Avant: \"%s\"\n", str2);
    pw_replace_chars(str2);
    printf("Après: \"%s\"\n", str2);
    
    char str3[] = "test123";
    printf("Avant: \"%s\"\n", str3);
    pw_replace_chars(str3);
    printf("Après: \"%s\"\n", str3);
    
    char str4[] = "UPPERCASE";
    printf("Avant: \"%s\"\n", str4);
    pw_replace_chars(str4);
    printf("Après: \"%s\"\n", str4);
    
    char str5[] = "";
    printf("Avant: \"%s\"\n", str5);
    pw_replace_chars(str5);
    printf("Après: \"%s\"\n", str5);
    
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
echo "Avant: \"Hello World\"$"
echo "Après: \"?*llo ?orld\"$"
echo "Avant: \"Excellence in CODING\"$"
echo "Après: \"?xc*ll*nc* in ??????\"$"
echo "Avant: \"test123\"$"
echo "Après: \"t*st123\"$"
echo "Avant: \"UPPERCASE\"$"
echo "Après: \"?????????\"$"
echo "Avant: \"\"$"
echo "Après: \"\"$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Avant: \"Hello World\"$
Après: \"?*llo ?orld\"$
Avant: \"Excellence in CODING\"$
Après: \"?xc*ll*nc* in ??????\"$
Avant: \"test123\"$
Après: \"t*st123\"$
Avant: \"UPPERCASE\"$
Après: \"?????????\"$
Avant: \"\"$
Après: \"\"$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction remplace correctement les caractères${NC}"
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
    echo "pw_replace_chars(\"Hello World\") -> doit donner \"?*llo ?orld\""
    echo "pw_replace_chars(\"Excellence in CODING\") -> doit donner \"?xc*ll*nc* in ??????\""
    echo "pw_replace_chars(\"test123\") -> doit donner \"t*st123\""
    echo "pw_replace_chars(\"UPPERCASE\") -> doit donner \"?????????\""
    echo "pw_replace_chars(\"\") -> doit donner \"\""
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
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "Hello";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Après: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: Hello$
Après: ?*llo$"
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

# Test avec chaîne contenant seulement des 'e'
echo -e "${YELLOW}🧪 Test avec chaîne de 'e'...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "eeee";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Après: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    E_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_E="Avant: eeee$
Après: ****$"
    if [ "$E_OUTPUT" = "$EXPECTED_E" ]; then
        echo -e "${GREEN}✅ Test chaîne de 'e' réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne de 'e' échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_E"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$E_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne de 'e'${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne contenant seulement des majuscules
echo -e "${YELLOW}🧪 Test avec chaîne de majuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "ABCD";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Après: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UPPER="Avant: ABCD$
Après: ????$"
    if [ "$UPPER_OUTPUT" = "$EXPECTED_UPPER" ]; then
        echo -e "${GREEN}✅ Test majuscules réussi${NC}"
    else
        echo -e "${RED}❌ Test majuscules échoué${NC}"
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

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    pw_replace_chars(NULL);
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

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    char empty[] = "";
    printf("Longueur avant: %zu\n", strlen(empty));
    pw_replace_chars(empty);
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

# Test avec 'E' majuscule (doit être remplacé par '?', pas par '*')
echo -e "${YELLOW}🧪 Test avec 'E' majuscule...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "ExcellencE";
    printf("Avant: %s\n", test);
    pw_replace_chars(test);
    printf("Après: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    CAPITAL_E_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_CAPITAL_E="Avant: ExcellencE$
Après: ?xc*ll*nc?$"
    if [ "$CAPITAL_E_OUTPUT" = "$EXPECTED_CAPITAL_E" ]; then
        echo -e "${GREEN}✅ Test 'E' majuscule réussi${NC}"
    else
        echo -e "${RED}❌ Test 'E' majuscule échoué${NC}"
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

# Test avec tous les caractères non modifiés
echo -e "${YELLOW}🧪 Test avec caractères non modifiés...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_replace_chars(char *str);

int main(void)
{
    char test[] = "abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()";
    char original[] = "abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()";
    pw_replace_chars(test);
    printf("Modifié: %s\n", test);
    printf("Original: %s\n", original);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UNCHANGED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UNCHANGED="Modifié: abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()$
Original: abcdfghijklmnopqrstuvwxyz123456789!@#$%^&*()$"
    if [ "$UNCHANGED_OUTPUT" = "$EXPECTED_UNCHANGED" ]; then
        echo -e "${GREEN}✅ Test caractères non modifiés réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères non modifiés échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_UNCHANGED"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$UNCHANGED_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères non modifiés${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 021 validé avec succès${NC}"
    echo -e "${GREEN}La fonction remplace correctement les caractères!${NC}"
else
    echo -e "\n${RED}❌ Exercice 021 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"