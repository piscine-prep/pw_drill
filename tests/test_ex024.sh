#!/bin/bash

# Script de test pour l'exercice 024 : Copier une chaine avec limite (strncpy)
# Usage: ./test_ex024.sh

EXERCISE_DIR="ex024"
SOURCE_FILE="pw_strncpy.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 024 : Copier une chaine avec limite (strncpy) ===${NC}"

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
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    // Test de la fonction pw_strncpy avec differents cas
    
    // Test 1 - Copie complete (src plus court que n)
    printf("Test 1 - Copie complete:\n");
    char dest1[20];
    memset(dest1, 'X', 19);  // Remplir avec des X
    dest1[19] = '\0';
    char src1[] = "Hello";
    printf("Source: \"%s\"\n", src1);
    pw_strncpy(dest1, src1, 10);
    printf("Destination (n=10): \"%s\"\n", dest1);
    printf("Longueur destination: %zu\n", strlen(dest1));
    printf("\n");
    
    // Test 2 - Copie tronquee (src plus long que n)
    printf("Test 2 - Copie tronquee:\n");
    char dest2[20];
    memset(dest2, 'X', 19);
    dest2[19] = '\0';
    char src2[] = "Hello World";
    printf("Source: \"%s\"\n", src2);
    pw_strncpy(dest2, src2, 5);
    dest2[5] = '\0';  // Ajouter le terminateur pour l'affichage
    printf("Destination (n=5): \"%s\"\n", dest2);
    printf("Longueur destination: %zu\n", strlen(dest2));
    printf("\n");
    
    // Test 3 - Chaine vide
    printf("Test 3 - Chaine vide:\n");
    char dest3[20];
    memset(dest3, 'X', 19);
    dest3[19] = '\0';
    char src3[] = "";
    printf("Source: \"%s\"\n", src3);
    pw_strncpy(dest3, src3, 5);
    printf("Destination (n=5): \"%s\"\n", dest3);
    printf("Longueur destination: %zu\n", strlen(dest3));
    printf("\n");
    
    // Test 4 - n=0
    printf("Test 4 - n=0:\n");
    char dest4[] = "initial";
    pw_strncpy(dest4, "test", 0);
    printf("Destination inchangee: \"%s\"\n", dest4);
    printf("\n");
    
    // Test 5 - src plus court que n (verifier padding avec '\0')
    printf("Test 5 - src plus court que n:\n");
    char dest5[20];
    memset(dest5, 'X', 19);
    dest5[19] = '\0';
    char src5[] = "Hi";
    printf("Source: \"%s\"\n", src5);
    pw_strncpy(dest5, src5, 5);
    printf("Destination (n=5): \"%s\"\n", dest5);
    printf("Longueur destination: %zu\n", strlen(dest5));
    printf("\n");
    
    // Test avec NULL
    char dest6[50] = "unchanged";
    char *result = pw_strncpy(dest6, NULL, 5);
    if (result == dest6 && strcmp(dest6, "unchanged") == 0) {
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
echo "Test 1 - Copie complete:$"
echo "Source: \"Hello\"$"
echo "Destination (n=10): \"Hello\"$"
echo "Longueur destination: 5$"
echo "$"
echo "Test 2 - Copie tronquee:$"
echo "Source: \"Hello World\"$"
echo "Destination (n=5): \"Hello\"$"
echo "Longueur destination: 5$"
echo "$"
echo "Test 3 - Chaine vide:$"
echo "Source: \"\"$"
echo "Destination (n=5): \"\"$"
echo "Longueur destination: 0$"
echo "$"
echo "Test 4 - n=0:$"
echo "Destination inchangee: \"initial\"$"
echo "$"
echo "Test 5 - src plus court que n:$"
echo "Source: \"Hi\"$"
echo "Destination (n=5): \"Hi\"$"
echo "Longueur destination: 2$"
echo "$"
echo "Test NULL: OK$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Test 1 - Copie complete:$
Source: \"Hello\"$
Destination (n=10): \"Hello\"$
Longueur destination: 5$
$
Test 2 - Copie tronquee:$
Source: \"Hello World\"$
Destination (n=5): \"Hello\"$
Longueur destination: 5$
$
Test 3 - Chaine vide:$
Source: \"\"$
Destination (n=5): \"\"$
Longueur destination: 0$
$
Test 4 - n=0:$
Destination inchangee: \"initial\"$
$
Test 5 - src plus court que n:$
Source: \"Hi\"$
Destination (n=5): \"Hi\"$
Longueur destination: 2$
$
Test NULL: OK$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction copie correctement les chaines avec limite${NC}"
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
    echo "pw_strncpy(dest, \"Hello\", 10) -> doit copier \"Hello\" et padder avec \\0"
    echo "pw_strncpy(dest, \"Hello World\", 5) -> doit copier \"Hello\" seulement"
    echo "pw_strncpy(dest, \"\", 5) -> doit copier chaine vide et padder"
    echo "pw_strncpy(dest, \"test\", 0) -> dest ne doit pas changer"
    echo "pw_strncpy(dest, \"Hi\", 5) -> doit copier \"Hi\" et padder avec \\0"
    echo "pw_strncpy(dest, NULL, 5) -> dest ne doit pas changer"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec troncature
echo -e "${YELLOW}🧪 Test individuel avec troncature...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char dest[10];
    memset(dest, 'X', 9);
    dest[9] = '\0';
    
    char src[] = "TooLongString";
    char *result = pw_strncpy(dest, src, 3);
    
    printf("Source: %s\n", src);
    printf("Premiers 3 chars: ");
    for (int i = 0; i < 3; i++) {
        printf("%c", dest[i]);
    }
    printf("\n");
    printf("Retour correct: %s\n", (result == dest) ? "OUI" : "NON");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TRUNC_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_TRUNC="Source: TooLongString$
Premiers 3 chars: Too$
Retour correct: OUI$"
    if [ "$TRUNC_OUTPUT" = "$EXPECTED_TRUNC" ]; then
        echo -e "${GREEN}✅ Test troncature reussi${NC}"
    else
        echo -e "${RED}❌ Test troncature echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_TRUNC"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$TRUNC_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test troncature${NC}"
    TEST_RESULT=1
fi

# Test avec dest NULL
echo -e "${YELLOW}🧪 Test avec dest NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char src[] = "test";
    char *result = pw_strncpy(NULL, src, 5);
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

# Test de padding avec '\0' (verification que les caracteres apres src sont bien a '\0')
echo -e "${YELLOW}🧪 Test verification du padding...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char dest[10];
    memset(dest, 'X', 9);  // Remplir avec des X
    dest[9] = '\0';
    
    char src[] = "AB";
    pw_strncpy(dest, src, 5);
    
    // Verifier que les caracteres 2, 3 et 4 sont des '\0'
    if (dest[0] == 'A' && dest[1] == 'B' && 
        dest[2] == '\0' && dest[3] == '\0' && dest[4] == '\0') {
        printf("Test padding: OK\n");
    } else {
        printf("Test padding: FAILED\n");
        printf("dest[0]='%c', dest[1]='%c', dest[2]=%d, dest[3]=%d, dest[4]=%d\n", 
               dest[0], dest[1], (int)dest[2], (int)dest[3], (int)dest[4]);
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    PADDING_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$PADDING_OUTPUT" = "Test padding: OK$" ]; then
        echo -e "${GREEN}✅ Test padding reussi${NC}"
    else
        echo -e "${RED}❌ Test padding echoue${NC}"
        echo -e "${RED}Sortie: '$PADDING_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test padding${NC}"
    TEST_RESULT=1
fi

# Test de comparaison avec strncpy standard
echo -e "${YELLOW}🧪 Test de comparaison avec strncpy standard...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char src[] = "Test123";
    char dest1[10];
    char dest2[10];
    
    // Remplir les deux destinations avec des X
    memset(dest1, 'X', 9);
    dest1[9] = '\0';
    memset(dest2, 'X', 9);
    dest2[9] = '\0';
    
    // Utiliser strncpy standard
    strncpy(dest1, src, 4);
    
    // Utiliser notre fonction
    pw_strncpy(dest2, src, 4);
    
    // Comparer les 4 premiers caracteres
    int same = 1;
    for (int i = 0; i < 4; i++) {
        if (dest1[i] != dest2[i]) {
            same = 0;
            break;
        }
    }
    
    if (same) {
        printf("Comparaison avec strncpy standard: OK\n");
    } else {
        printf("Comparaison avec strncpy standard: FAILED\n");
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    COMPARISON_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$COMPARISON_OUTPUT" = "Comparaison avec strncpy standard: OK$" ]; then
        echo -e "${GREEN}✅ Test comparaison avec strncpy standard reussi${NC}"
    else
        echo -e "${RED}❌ Test comparaison avec strncpy standard echoue${NC}"
        echo -e "${RED}Sortie: '$COMPARISON_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test comparaison${NC}"
    TEST_RESULT=1
fi

# Test cas limite : n plus grand que la taille des chaines
echo -e "${YELLOW}🧪 Test avec n tres grand...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char dest[50];
    memset(dest, 'X', 49);
    dest[49] = '\0';
    
    char src[] = "Short";
    pw_strncpy(dest, src, 20);
    
    if (strcmp(dest, "Short") == 0 && strlen(dest) == 5) {
        printf("Test n tres grand: OK\n");
    } else {
        printf("Test n tres grand: FAILED\n");
        printf("dest='%s', longueur=%zu\n", dest, strlen(dest));
    }
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LARGE_N_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LARGE_N_OUTPUT" = "Test n tres grand: OK$" ]; then
        echo -e "${GREEN}✅ Test n tres grand reussi${NC}"
    else
        echo -e "${RED}❌ Test n tres grand echoue${NC}"
        echo -e "${RED}Sortie: '$LARGE_N_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test n tres grand${NC}"
    TEST_RESULT=1
fi

# Test avec caracteres speciaux
echo -e "${YELLOW}🧪 Test avec caracteres speciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Prototype de la fonction de l'etudiant
char *pw_strncpy(char *dest, char *src, unsigned int n);

int main(void)
{
    char dest[20];
    char src[] = "A\tB\nC";
    pw_strncpy(dest, src, 10);
    
    if (strncmp(dest, src, strlen(src)) == 0) {
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

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 024 valide avec succes${NC}"
    echo -e "${GREEN}La fonction pw_strncpy reproduit correctement le comportement de strncpy!${NC}"
else
    echo -e "\n${RED}❌ Exercice 024 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"