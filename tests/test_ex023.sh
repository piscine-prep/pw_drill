#!/bin/bash

# Script de test pour l'exercice 023 : Copier une chaine (strcpy)
# Usage: ./test_ex023.sh

EXERCISE_DIR="ex023"
SOURCE_FILE="pw_strcpy.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 023 : Copier une chaine (strcpy) ===${NC}"

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
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    // Test de la fonction pw_strcpy avec differentes chaines
    char dest1[50];
    char src1[] = "Hello World";
    printf("Source: \"%s\"\n", src1);
    pw_strcpy(dest1, src1);
    printf("Destination apres copie: \"%s\"\n", dest1);
    
    char dest2[50];
    char src2[] = "42 School";
    printf("Source: \"%s\"\n", src2);
    pw_strcpy(dest2, src2);
    printf("Destination apres copie: \"%s\"\n", dest2);
    
    char dest3[50];
    char src3[] = "";
    printf("Source: \"%s\"\n", src3);
    pw_strcpy(dest3, src3);
    printf("Destination apres copie: \"%s\"\n", dest3);
    
    char dest4[50];
    char src4[] = "a";
    printf("Source: \"%s\"\n", src4);
    pw_strcpy(dest4, src4);
    printf("Destination apres copie: \"%s\"\n", dest4);
    
    // Test avec NULL
    char dest5[50] = "unchanged";
    char *result = pw_strcpy(dest5, NULL);
    if (result == dest5 && strcmp(dest5, "unchanged") == 0) {
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
echo "Source: \"Hello World\"$"
echo "Destination apres copie: \"Hello World\"$"
echo "Source: \"42 School\"$"
echo "Destination apres copie: \"42 School\"$"
echo "Source: \"\"$"
echo "Destination apres copie: \"\"$"
echo "Source: \"a\"$"
echo "Destination apres copie: \"a\"$"
echo "Test NULL: OK$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Source: \"Hello World\"$
Destination apres copie: \"Hello World\"$
Source: \"42 School\"$
Destination apres copie: \"42 School\"$
Source: \"\"$
Destination apres copie: \"\"$
Source: \"a\"$
Destination apres copie: \"a\"$
Test NULL: OK$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction copie correctement les chaines${NC}"
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
    echo "pw_strcpy(dest, \"Hello World\") -> doit copier \"Hello World\""
    echo "pw_strcpy(dest, \"42 School\") -> doit copier \"42 School\""
    echo "pw_strcpy(dest, \"\") -> doit copier chaine vide"
    echo "pw_strcpy(dest, \"a\") -> doit copier \"a\""
    echo "pw_strcpy(dest, NULL) -> dest ne doit pas changer"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec "Hello"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello'...${NC}"

# Creer un fichier de test pour une seule copie
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[20];
    char src[] = "Hello";
    char *result = pw_strcpy(dest, src);
    
    printf("Source: %s\n", src);
    printf("Destination: %s\n", dest);
    printf("Retour correct: %s\n", (result == dest) ? "OUI" : "NON");
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Source: Hello$
Destination: Hello$
Retour correct: OUI$"
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
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[20] = "initial";
    char src[] = "";
    pw_strcpy(dest, src);
    printf("Longueur destination: %zu\n", strlen(dest));
    printf("Destination: '%s'\n", dest);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_EMPTY="Longueur destination: 0$
Destination: ''$"
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

# Test avec dest NULL
echo -e "${YELLOW}🧪 Test avec dest NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char src[] = "test";
    char *result = pw_strcpy(NULL, src);
    if (result == NULL) {
        printf("Test dest NULL: OK\n");
    } else {
        printf("Test dest NULL: FAILED\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_DEST_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_DEST_OUTPUT" = "Test dest NULL: OK$" ]; then
        echo -e "${GREEN}✅ Test dest NULL reussi${NC}"
    else
        echo -e "${RED}❌ Test dest NULL echoue - Sortie: '$NULL_DEST_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test dest NULL${NC}"
    TEST_RESULT=1
fi

# Test avec chaine longue
echo -e "${YELLOW}🧪 Test avec chaine longue...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[100];
    char src[] = "Ceci est une tres longue chaine de caracteres pour tester la fonction strcpy";
    pw_strcpy(dest, src);
    
    if (strcmp(dest, src) == 0) {
        printf("Test chaine longue: OK\n");
    } else {
        printf("Test chaine longue: FAILED\n");
        printf("Source: %s\n", src);
        printf("Destination: %s\n", dest);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LONG_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LONG_OUTPUT" = "Test chaine longue: OK$" ]; then
        echo -e "${GREEN}✅ Test chaine longue reussi${NC}"
    else
        echo -e "${RED}❌ Test chaine longue echoue${NC}"
        echo -e "${RED}Sortie: '$LONG_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaine longue${NC}"
    TEST_RESULT=1
fi

# Test de comparaison avec strcpy standard
echo -e "${YELLOW}🧪 Test de comparaison avec strcpy standard...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char src[] = "Test123!@#";
    char dest1[50];
    char dest2[50];
    
    // Utiliser strcpy standard
    strcpy(dest1, src);
    
    // Utiliser notre fonction
    pw_strcpy(dest2, src);
    
    if (strcmp(dest1, dest2) == 0) {
        printf("Comparaison avec strcpy standard: OK\n");
    } else {
        printf("Comparaison avec strcpy standard: FAILED\n");
        printf("strcpy standard: %s\n", dest1);
        printf("pw_strcpy: %s\n", dest2);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    COMPARISON_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$COMPARISON_OUTPUT" = "Comparaison avec strcpy standard: OK$" ]; then
        echo -e "${GREEN}✅ Test comparaison avec strcpy standard reussi${NC}"
    else
        echo -e "${RED}❌ Test comparaison avec strcpy standard echoue${NC}"
        echo -e "${RED}Sortie: '$COMPARISON_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test comparaison${NC}"
    TEST_RESULT=1
fi

# Test caracteres speciaux et nombres
echo -e "${YELLOW}🧪 Test avec caracteres speciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[50];
    char src[] = "Hello\tWorld\n123!@#$%^&*()";
    pw_strcpy(dest, src);
    
    if (strcmp(dest, src) == 0) {
        printf("Test caracteres speciaux: OK\n");
    } else {
        printf("Test caracteres speciaux: FAILED\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPECIAL_OUTPUT" = "Test caracteres speciaux: OK$" ]; then
        echo -e "${GREEN}✅ Test caracteres speciaux reussi${NC}"
    else
        echo -e "${RED}❌ Test caracteres speciaux echoue${NC}"
        echo -e "${RED}Sortie: '$SPECIAL_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caracteres speciaux${NC}"
    TEST_RESULT=1
fi

# Test de verification que le '\0' est bien copie
echo -e "${YELLOW}🧪 Test verification du caractere de fin...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[20];
    // Remplir dest avec des caracteres non-null
    memset(dest, 'X', 19);
    dest[19] = '\0';
    
    char src[] = "ABC";
    pw_strcpy(dest, src);
    
    // Verifier que le 4eme caractere est bien '\0'
    if (dest[3] == '\0' && strlen(dest) == 3) {
        printf("Test caractere de fin: OK\n");
    } else {
        printf("Test caractere de fin: FAILED\n");
        printf("Longueur: %zu (attendu: 3)\n", strlen(dest));
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
    echo -e "\n${GREEN}✅ Exercice 023 valide avec succes${NC}"
    echo -e "${GREEN}La fonction pw_strcpy reproduit correctement le comportement de strcpy!${NC}"
else
    echo -e "\n${RED}❌ Exercice 023 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"