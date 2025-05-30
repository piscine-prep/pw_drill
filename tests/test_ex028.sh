#!/bin/bash

# Script de test pour l'exercice 028 : Nettoyer et convertir en majuscules
# Usage: ./test_ex028.sh

EXERCISE_DIR="ex028"
SOURCE_FILE="pw_strip_and_to_uppercase.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 028 : Nettoyer et convertir en majuscules ===${NC}"

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
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    // Test de la fonction pw_strip_and_to_uppercase avec differentes chaines
    char str1[] = "Hello World 123!";
    printf("Avant: \"%s\"\n", str1);
    pw_strip_and_to_uppercase(str1);
    printf("Apres: \"%s\"\n", str1);
    
    char str2[] = "42 School-Paris";
    printf("Avant: \"%s\"\n", str2);
    pw_strip_and_to_uppercase(str2);
    printf("Apres: \"%s\"\n", str2);
    
    char str3[] = "test@email.com";
    printf("Avant: \"%s\"\n", str3);
    pw_strip_and_to_uppercase(str3);
    printf("Apres: \"%s\"\n", str3);
    
    char str4[] = "123456";
    printf("Avant: \"%s\"\n", str4);
    pw_strip_and_to_uppercase(str4);
    printf("Apres: \"%s\"\n", str4);
    
    char str5[] = "";
    printf("Avant: \"%s\"\n", str5);
    pw_strip_and_to_uppercase(str5);
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
echo "Avant: \"Hello World 123!\"$"
echo "Apres: \"HELLOWORLD\"$"
echo "Avant: \"42 School-Paris\"$"
echo "Apres: \"SCHOOLPARIS\"$"
echo "Avant: \"test@email.com\"$"
echo "Apres: \"TESTEMAILCOM\"$"
echo "Avant: \"123456\"$"
echo "Apres: \"\"$"
echo "Avant: \"\"$"
echo "Apres: \"\"$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: \"Hello World 123!\"$
Apres: \"HELLOWORLD\"$
Avant: \"42 School-Paris\"$
Apres: \"SCHOOLPARIS\"$
Avant: \"test@email.com\"$
Apres: \"TESTEMAILCOM\"$
Avant: \"123456\"$
Apres: \"\"$
Avant: \"\"$
Apres: \"\"$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction nettoie et convertit correctement les chaines${NC}"
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
    echo "pw_strip_and_to_uppercase(\"Hello World 123!\") -> doit donner \"HELLOWORLD\""
    echo "pw_strip_and_to_uppercase(\"42 School-Paris\") -> doit donner \"SCHOOLPARIS\""
    echo "pw_strip_and_to_uppercase(\"test@email.com\") -> doit donner \"TESTEMAILCOM\""
    echo "pw_strip_and_to_uppercase(\"123456\") -> doit donner \"\""
    echo "pw_strip_and_to_uppercase(\"\") -> doit donner \"\""
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "Hello123"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello123'...${NC}"

# Creer un fichier de test pour une seule chaine
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "Hello123";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: Hello123$
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

# Test avec chaine contenant seulement des lettres minuscules
echo -e "${YELLOW}🧪 Test avec lettres minuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "abcdef";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LOWER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LOWER="Avant: abcdef$
Apres: ABCDEF$"
    if [ "$LOWER_OUTPUT" = "$EXPECTED_LOWER" ]; then
        echo -e "${GREEN}✅ Test lettres minuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test lettres minuscules echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LOWER"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LOWER_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test lettres minuscules${NC}"
    TEST_RESULT=1
fi

# Test avec chaine contenant seulement des majuscules
echo -e "${YELLOW}🧪 Test avec lettres majuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "ABCDEF";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_UPPER="Avant: ABCDEF$
Apres: ABCDEF$"
    if [ "$UPPER_OUTPUT" = "$EXPECTED_UPPER" ]; then
        echo -e "${GREEN}✅ Test lettres majuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test lettres majuscules echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_UPPER"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$UPPER_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test lettres majuscules${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    pw_strip_and_to_uppercase(NULL);
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

# Test avec chaine sans lettres
echo -e "${YELLOW}🧪 Test avec chaine sans lettres...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "!@#$%^&*()1234567890";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    printf("Longueur apres: %zu\n", strlen(test));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NO_LETTERS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NO_LETTERS="Avant: !@#$%^&*()1234567890$
Apres: $
Longueur apres: 0$"
    if [ "$NO_LETTERS_OUTPUT" = "$EXPECTED_NO_LETTERS" ]; then
        echo -e "${GREEN}✅ Test sans lettres reussi${NC}"
    else
        echo -e "${RED}❌ Test sans lettres echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NO_LETTERS"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NO_LETTERS_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test sans lettres${NC}"
    TEST_RESULT=1
fi

# Test avec melange de majuscules et minuscules
echo -e "${YELLOW}🧪 Test avec melange majuscules/minuscules...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "AbCdEf123GhIjK!@#";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MIXED_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_MIXED="Avant: AbCdEf123GhIjK!@#$
Apres: ABCDEFGHIJK$"
    if [ "$MIXED_OUTPUT" = "$EXPECTED_MIXED" ]; then
        echo -e "${GREEN}✅ Test melange majuscules/minuscules reussi${NC}"
    else
        echo -e "${RED}❌ Test melange majuscules/minuscules echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_MIXED"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$MIXED_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test melange${NC}"
    TEST_RESULT=1
fi

# Test avec espaces multiples
echo -e "${YELLOW}🧪 Test avec espaces multiples...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "   a   b   c   ";
    printf("Avant: '%s'\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: '%s'\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPACES_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SPACES="Avant: '   a   b   c   '$
Apres: 'ABC'$"
    if [ "$SPACES_OUTPUT" = "$EXPECTED_SPACES" ]; then
        echo -e "${GREEN}✅ Test espaces multiples reussi${NC}"
    else
        echo -e "${RED}❌ Test espaces multiples echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_SPACES"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$SPACES_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test espaces${NC}"
    TEST_RESULT=1
fi

# Test avec caracteres speciaux et accents
echo -e "${YELLOW}🧪 Test avec caracteres speciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[] = "a1b2c3d4e5!@#$%^&*()";
    printf("Avant: %s\n", test);
    pw_strip_and_to_uppercase(test);
    printf("Apres: %s\n", test);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SPECIAL="Avant: a1b2c3d4e5!@#$%^&*()$
Apres: ABCDE$"
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

# Test de verification que le caractere de fin est bien place
echo -e "${YELLOW}🧪 Test verification du caractere de fin...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
void pw_strip_and_to_uppercase(char *str);

int main(void)
{
    char test[20];
    // Remplir avec des caracteres non-null
    memset(test, 'X', 19);
    test[19] = '\0';
    
    // Copier une chaine de test
    strcpy(test, "a1b2c");
    
    pw_strip_and_to_uppercase(test);
    
    // Verifier la longueur et le contenu
    if (strlen(test) == 3 && strcmp(test, "ABC") == 0) {
        printf("Test caractere de fin: OK\n");
    } else {
        printf("Test caractere de fin: FAILED\n");
        printf("Resultat: '%s', longueur: %zu\n", test, strlen(test));
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TERMINATOR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$TERMINATOR_OUTPUT" = "Test caractere de fin: OK$" ]; then
        echo -e "${GREEN}✅ Test caractere de fin reussi${NC}"
    else
        echo -e "${RED}❌ Test caractere de fin echoue${NC}"
        echo -e "${RED}Sortie: '$TERMINATOR_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractere de fin${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 028 valide avec succes${NC}"
    echo -e "${GREEN}La fonction nettoie et convertit correctement les chaines!${NC}"
else
    echo -e "\n${RED}❌ Exercice 028 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"