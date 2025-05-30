#!/bin/bash

# Script de test pour l'exercice 023 : Copier une chaîne (strcpy)
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

echo -e "${BLUE}=== Test de l'exercice 023 : Copier une chaîne (strcpy) ===${NC}"

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
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    // Test de la fonction pw_strcpy avec différentes chaînes
    char dest1[50];
    char src1[] = "Hello World";
    printf("Source: \"%s\"\n", src1);
    pw_strcpy(dest1, src1);
    printf("Destination après copie: \"%s\"\n", dest1);
    
    char dest2[50];
    char src2[] = "42 School";
    printf("Source: \"%s\"\n", src2);
    pw_strcpy(dest2, src2);
    printf("Destination après copie: \"%s\"\n", dest2);
    
    char dest3[50];
    char src3[] = "";
    printf("Source: \"%s\"\n", src3);
    pw_strcpy(dest3, src3);
    printf("Destination après copie: \"%s\"\n", dest3);
    
    char dest4[50];
    char src4[] = "a";
    printf("Source: \"%s\"\n", src4);
    pw_strcpy(dest4, src4);
    printf("Destination après copie: \"%s\"\n", dest4);
    
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
echo "Source: \"Hello World\"$"
echo "Destination après copie: \"Hello World\"$"
echo "Source: \"42 School\"$"
echo "Destination après copie: \"42 School\"$"
echo "Source: \"\"$"
echo "Destination après copie: \"\"$"
echo "Source: \"a\"$"
echo "Destination après copie: \"a\"$"
echo "Test NULL: OK$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Source: \"Hello World\"$
Destination après copie: \"Hello World\"$
Source: \"42 School\"$
Destination après copie: \"42 School\"$
Source: \"\"$
Destination après copie: \"\"$
Source: \"a\"$
Destination après copie: \"a\"$
Test NULL: OK$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction copie correctement les chaînes${NC}"
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
    echo "pw_strcpy(dest, \"Hello World\") -> doit copier \"Hello World\""
    echo "pw_strcpy(dest, \"42 School\") -> doit copier \"42 School\""
    echo "pw_strcpy(dest, \"\") -> doit copier chaîne vide"
    echo "pw_strcpy(dest, \"a\") -> doit copier \"a\""
    echo "pw_strcpy(dest, NULL) -> dest ne doit pas changer"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "Hello"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello'...${NC}"

# Créer un fichier de test pour une seule copie
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
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

# Test avec dest NULL
echo -e "${YELLOW}🧪 Test avec dest NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
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
        echo -e "${GREEN}✅ Test dest NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test dest NULL échoué - Sortie: '$NULL_DEST_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test dest NULL${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne longue
echo -e "${YELLOW}🧪 Test avec chaîne longue...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[100];
    char src[] = "Ceci est une très longue chaîne de caractères pour tester la fonction strcpy";
    pw_strcpy(dest, src);
    
    if (strcmp(dest, src) == 0) {
        printf("Test chaîne longue: OK\n");
    } else {
        printf("Test chaîne longue: FAILED\n");
        printf("Source: %s\n", src);
        printf("Destination: %s\n", dest);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LONG_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LONG_OUTPUT" = "Test chaîne longue: OK$" ]; then
        echo -e "${GREEN}✅ Test chaîne longue réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne longue échoué${NC}"
        echo -e "${RED}Sortie: '$LONG_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne longue${NC}"
    TEST_RESULT=1
fi

# Test de comparaison avec strcpy standard
echo -e "${YELLOW}🧪 Test de comparaison avec strcpy standard...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
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
        echo -e "${GREEN}✅ Test comparaison avec strcpy standard réussi${NC}"
    else
        echo -e "${RED}❌ Test comparaison avec strcpy standard échoué${NC}"
        echo -e "${RED}Sortie: '$COMPARISON_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test comparaison${NC}"
    TEST_RESULT=1
fi

# Test caractères spéciaux et nombres
echo -e "${YELLOW}🧪 Test avec caractères spéciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[50];
    char src[] = "Hello\tWorld\n123!@#$%^&*()";
    pw_strcpy(dest, src);
    
    if (strcmp(dest, src) == 0) {
        printf("Test caractères spéciaux: OK\n");
    } else {
        printf("Test caractères spéciaux: FAILED\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPECIAL_OUTPUT" = "Test caractères spéciaux: OK$" ]; then
        echo -e "${GREEN}✅ Test caractères spéciaux réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères spéciaux échoué${NC}"
        echo -e "${RED}Sortie: '$SPECIAL_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères spéciaux${NC}"
    TEST_RESULT=1
fi

# Test de vérification que le '\0' est bien copié
echo -e "${YELLOW}🧪 Test vérification du caractère de fin...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'étudiant
char *pw_strcpy(char *dest, char *src);

int main(void)
{
    char dest[20];
    // Remplir dest avec des caractères non-null
    memset(dest, 'X', 19);
    dest[19] = '\0';
    
    char src[] = "ABC";
    pw_strcpy(dest, src);
    
    // Vérifier que le 4ème caractère est bien '\0'
    if (dest[3] == '\0' && strlen(dest) == 3) {
        printf("Test caractère de fin: OK\n");
    } else {
        printf("Test caractère de fin: FAILED\n");
        printf("Longueur: %zu (attendu: 3)\n", strlen(dest));
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TERMINATOR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$TERMINATOR_OUTPUT" = "Test caractère de fin: OK$" ]; then
        echo -e "${GREEN}✅ Test caractère de fin réussi${NC}"
    else
        echo -e "${RED}❌ Test caractère de fin échoué${NC}"
        echo -e "${RED}Sortie: '$TERMINATOR_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractère de fin${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 023 validé avec succès${NC}"
    echo -e "${GREEN}La fonction pw_strcpy reproduit correctement le comportement de strcpy!${NC}"
else
    echo -e "\n${RED}❌ Exercice 023 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"