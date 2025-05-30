#!/bin/bash

# Script de test pour l'exercice 029 : Trouver le premier chiffre
# Usage: ./test_ex029.sh

EXERCISE_DIR="ex029"
SOURCE_FILE="pw_find_digit.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 029 : Trouver le premier chiffre ===${NC}"

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
char *pw_find_digit(char *str);

int main(void)
{
    // Test de la fonction pw_find_digit avec differentes chaines
    char str1[] = "Hello123World";
    char *result1 = pw_find_digit(str1);
    printf("Chaine: \"%s\"\n", str1);
    printf("Premier chiffre trouve a partir de: \"%s\"\n", result1);
    
    char str2[] = "abc def ghi";
    char *result2 = pw_find_digit(str2);
    printf("Chaine: \"%s\"\n", str2);
    printf("Aucun chiffre, retour au debut: \"%s\"\n", result2);
    
    char str3[] = "42School";
    char *result3 = pw_find_digit(str3);
    printf("Chaine: \"%s\"\n", str3);
    printf("Premier chiffre trouve a partir de: \"%s\"\n", result3);
    
    char str4[] = "Test9End";
    char *result4 = pw_find_digit(str4);
    printf("Chaine: \"%s\"\n", str4);
    printf("Premier chiffre trouve a partir de: \"%s\"\n", result4);
    
    char str5[] = "";
    char *result5 = pw_find_digit(str5);
    printf("Chaine: \"%s\"\n", str5);
    printf("Chaine vide, retour au debut: \"%s\"\n", result5);
    
    // Test avec NULL
    char *result6 = pw_find_digit(NULL);
    if (result6 == NULL) {
        printf("Test NULL: OK\n");
    } else {
        printf("Test NULL: FAILED\n");
    }
    
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
echo "Chaine: \"Hello123World\"$"
echo "Premier chiffre trouve a partir de: \"123World\"$"
echo "Chaine: \"abc def ghi\"$"
echo "Aucun chiffre, retour au debut: \"abc def ghi\"$"
echo "Chaine: \"42School\"$"
echo "Premier chiffre trouve a partir de: \"42School\"$"
echo "Chaine: \"Test9End\"$"
echo "Premier chiffre trouve a partir de: \"9End\"$"
echo "Chaine: \"\"$"
echo "Chaine vide, retour au debut: \"\"$"
echo "Test NULL: OK$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Chaine: \"Hello123World\"$
Premier chiffre trouve a partir de: \"123World\"$
Chaine: \"abc def ghi\"$
Aucun chiffre, retour au debut: \"abc def ghi\"$
Chaine: \"42School\"$
Premier chiffre trouve a partir de: \"42School\"$
Chaine: \"Test9End\"$
Premier chiffre trouve a partir de: \"9End\"$
Chaine: \"\"$
Chaine vide, retour au debut: \"\"$
Test NULL: OK$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction trouve correctement le premier chiffre${NC}"
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
    echo "pw_find_digit(\"Hello123World\") -> doit pointer vers \"123World\""
    echo "pw_find_digit(\"abc def ghi\") -> doit pointer vers debut \"abc def ghi\""
    echo "pw_find_digit(\"42School\") -> doit pointer vers \"42School\""
    echo "pw_find_digit(\"Test9End\") -> doit pointer vers \"9End\""
    echo "pw_find_digit(\"\") -> doit pointer vers debut \"\""
    echo "pw_find_digit(NULL) -> doit retourner NULL"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "abc123def"
echo -e "${YELLOW}🧪 Test individuel avec 'abc123def'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "abc123def";
    char *result = pw_find_digit(test);
    printf("Original: %s\n", test);
    printf("Resultat: %s\n", result);
    
    // Verifier que le pointeur pointe bien vers le bon endroit
    if (result == &test[3]) {
        printf("Pointeur correct: OUI\n");
    } else {
        printf("Pointeur correct: NON\n");
    }
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Original: abc123def$
Resultat: 123def$
Pointeur correct: OUI$"
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

# Test avec chaine ne contenant que des chiffres
echo -e "${YELLOW}🧪 Test avec chaine de chiffres uniquement...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "123456";
    char *result = pw_find_digit(test);
    printf("Chaine: %s\n", test);
    printf("Resultat: %s\n", result);
    
    // Doit pointer vers le debut (premier caractere est deja un chiffre)
    if (result == test) {
        printf("Pointe vers debut: OUI\n");
    } else {
        printf("Pointe vers debut: NON\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DIGITS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_DIGITS="Chaine: 123456$
Resultat: 123456$
Pointe vers debut: OUI$"
    if [ "$DIGITS_OUTPUT" = "$EXPECTED_DIGITS" ]; then
        echo -e "${GREEN}✅ Test chaine de chiffres reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine de chiffres echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_DIGITS"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$DIGITS_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine de chiffres${NC}"
    TEST_RESULT=1
fi

# Test avec caracteres speciaux
echo -e "${YELLOW}🧪 Test avec caracteres speciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "!@#$%^&*()7test";
    char *result = pw_find_digit(test);
    printf("Chaine: %s\n", test);
    printf("Resultat: %s\n", result);
    
    // Doit pointer vers "7test"
    if (result[0] == '7') {
        printf("Premier caractere: 7 - OK\n");
    } else {
        printf("Premier caractere: %c - ERREUR\n", result[0]);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SPECIAL="Chaine: !@#$%^&*()7test$
Resultat: 7test$
Premier caractere: 7 - OK$"
    if [ "$SPECIAL_OUTPUT" = "$EXPECTED_SPECIAL" ]; then
        echo -e "${GREEN}✅ Test caracteres speciaux reussi${NC}"
    else
        echo -e "${RED}❌ Test caracteres speciaux echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SPECIAL"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SPECIAL_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caracteres speciaux${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char *result = pw_find_digit(NULL);
    if (result == NULL) {
        printf("Test NULL reussi\n");
    } else {
        printf("Test NULL echoue\n");
    }
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

# Test avec chaine sans chiffres
echo -e "${YELLOW}🧪 Test avec chaine sans chiffres...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "abcdefghijk";
    char *result = pw_find_digit(test);
    printf("Chaine: %s\n", test);
    printf("Resultat: %s\n", result);
    
    // Doit pointer vers le debut
    if (result == test) {
        printf("Retour au debut: OUI\n");
    } else {
        printf("Retour au debut: NON\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NO_DIGIT_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NO_DIGIT="Chaine: abcdefghijk$
Resultat: abcdefghijk$
Retour au debut: OUI$"
    if [ "$NO_DIGIT_OUTPUT" = "$EXPECTED_NO_DIGIT" ]; then
        echo -e "${GREEN}✅ Test sans chiffres reussi${NC}"
    else
        echo -e "${RED}❌ Test sans chiffres echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NO_DIGIT"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NO_DIGIT_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test sans chiffres${NC}"
    TEST_RESULT=1
fi

# Test avec chaine vide
echo -e "${YELLOW}🧪 Test avec chaine vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "";
    char *result = pw_find_digit(test);
    printf("Longueur chaine: %zu\n", strlen(test));
    printf("Longueur resultat: %zu\n", strlen(result));
    
    // Doit pointer vers le debut (chaine vide)
    if (result == test && strlen(result) == 0) {
        printf("Chaine vide OK\n");
    } else {
        printf("Chaine vide ERREUR\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EMPTY="Longueur chaine: 0$
Longueur resultat: 0$
Chaine vide OK$"
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

# Test avec dernier caractere etant un chiffre
echo -e "${YELLOW}🧪 Test avec chiffre en fin de chaine...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test[] = "abcdefg5";
    char *result = pw_find_digit(test);
    printf("Chaine: %s\n", test);
    printf("Resultat: %s\n", result);
    
    // Doit pointer vers "5"
    if (result[0] == '5' && result[1] == '\0') {
        printf("Dernier chiffre trouve: OUI\n");
    } else {
        printf("Dernier chiffre trouve: NON\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LAST_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LAST="Chaine: abcdefg5$
Resultat: 5$
Dernier chiffre trouve: OUI$"
    if [ "$LAST_OUTPUT" = "$EXPECTED_LAST" ]; then
        echo -e "${GREEN}✅ Test chiffre en fin reussi${NC}"
    else
        echo -e "${RED}❌ Test chiffre en fin echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LAST"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LAST_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chiffre en fin${NC}"
    TEST_RESULT=1
fi

# Test avec tous les chiffres 0-9
echo -e "${YELLOW}🧪 Test avec tous les chiffres 0-9...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_find_digit(char *str);

int main(void)
{
    char test0[] = "abc0def";
    char test1[] = "abc1def";
    char test2[] = "abc2def";
    char test3[] = "abc3def";
    char test4[] = "abc4def";
    char test5[] = "abc5def";
    char test6[] = "abc6def";
    char test7[] = "abc7def";
    char test8[] = "abc8def";
    char test9[] = "abc9def";
    
    char *tests[] = {test0, test1, test2, test3, test4, test5, test6, test7, test8, test9};
    int success = 1;
    
    for (int i = 0; i < 10; i++) {
        char *result = pw_find_digit(tests[i]);
        if (result[0] != ('0' + i)) {
            success = 0;
            break;
        }
    }
    
    if (success) {
        printf("Test tous chiffres: OK\n");
    } else {
        printf("Test tous chiffres: FAILED\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ALL_DIGITS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ALL_DIGITS_OUTPUT" = "Test tous chiffres: OK$" ]; then
        echo -e "${GREEN}✅ Test tous chiffres reussi${NC}"
    else
        echo -e "${RED}❌ Test tous chiffres echoue - Sortie: '$ALL_DIGITS_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test tous chiffres${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 029 valide avec succes${NC}"
    echo -e "${GREEN}La fonction trouve correctement le premier chiffre dans une chaine!${NC}"
else
    echo -e "\n${RED}❌ Exercice 029 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"