#!/bin/bash

# Script de test pour l'exercice 022 : Inverser un tableau
# Usage: ./test_ex022.sh

EXERCISE_DIR="ex022"
SOURCE_FILE="pw_reverse_array.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 022 : Inverser un tableau ===${NC}"

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

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    // Test de la fonction pw_reverse_array avec differents tableaux
    int arr1[] = {1, 2, 3, 4, 5};
    int size1 = 5;
    printf("Avant: ");
    print_array(arr1, size1);
    printf("\n");
    pw_reverse_array(arr1, size1);
    printf("Apres: ");
    print_array(arr1, size1);
    printf("\n");
    
    int arr2[] = {10, -5, 0, 42};
    int size2 = 4;
    printf("Avant: ");
    print_array(arr2, size2);
    printf("\n");
    pw_reverse_array(arr2, size2);
    printf("Apres: ");
    print_array(arr2, size2);
    printf("\n");
    
    int arr3[] = {7};
    int size3 = 1;
    printf("Avant: ");
    print_array(arr3, size3);
    printf("\n");
    pw_reverse_array(arr3, size3);
    printf("Apres: ");
    print_array(arr3, size3);
    printf("\n");
    
    int *arr4 = NULL;
    int size4 = 0;
    printf("Avant: ");
    print_array(arr4, size4);
    printf("\n");
    pw_reverse_array(arr4, size4);
    printf("Apres: ");
    print_array(arr4, size4);
    printf("\n");
    
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
echo "Avant: [1, 2, 3, 4, 5]$"
echo "Apres: [5, 4, 3, 2, 1]$"
echo "Avant: [10, -5, 0, 42]$"
echo "Apres: [42, 0, -5, 10]$"
echo "Avant: [7]$"
echo "Apres: [7]$"
echo "Avant: []$"
echo "Apres: []$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="Avant: [1, 2, 3, 4, 5]$
Apres: [5, 4, 3, 2, 1]$
Avant: [10, -5, 0, 42]$
Apres: [42, 0, -5, 10]$
Avant: [7]$
Apres: [7]$
Avant: []$
Apres: []$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction inverse correctement les tableaux${NC}"
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
    echo "pw_reverse_array([1,2,3,4,5], 5) -> doit donner [5,4,3,2,1]"
    echo "pw_reverse_array([10,-5,0,42], 4) -> doit donner [42,0,-5,10]"
    echo "pw_reverse_array([7], 1) -> doit donner [7]"
    echo "pw_reverse_array(NULL, 0) -> doit donner []"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour verifier le comportement avec [1,2,3]
echo -e "${YELLOW}🧪 Test individuel avec [1,2,3]...${NC}"

# Creer un fichier de test pour un seul tableau
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    int test[] = {1, 2, 3};
    printf("Avant: ");
    print_array(test, 3);
    printf("\n");
    pw_reverse_array(test, 3);
    printf("Apres: ");
    print_array(test, 3);
    printf("\n");
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: [1, 2, 3]$
Apres: [3, 2, 1]$"
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

# Test avec tableau de deux elements
echo -e "${YELLOW}🧪 Test avec deux elements [10, 20]...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    int test[] = {10, 20};
    printf("Avant: ");
    print_array(test, 2);
    printf("\n");
    pw_reverse_array(test, 2);
    printf("Apres: ");
    print_array(test, 2);
    printf("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TWO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_TWO="Avant: [10, 20]$
Apres: [20, 10]$"
    if [ "$TWO_OUTPUT" = "$EXPECTED_TWO" ]; then
        echo -e "${GREEN}✅ Test deux elements reussi${NC}"
    else
        echo -e "${RED}❌ Test deux elements echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_TWO"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$TWO_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test deux elements${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec pointeur NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

int main(void)
{
    pw_reverse_array(NULL, 5);
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

# Test avec taille negative
echo -e "${YELLOW}🧪 Test avec taille negative...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    int test[] = {1, 2, 3};
    printf("Avant: ");
    print_array(test, 3);
    printf("\n");
    pw_reverse_array(test, -1);
    printf("Apres: ");
    print_array(test, 3);
    printf("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NEGATIVE="Avant: [1, 2, 3]$
Apres: [1, 2, 3]$"
    if [ "$NEGATIVE_OUTPUT" = "$EXPECTED_NEGATIVE" ]; then
        echo -e "${GREEN}✅ Test taille negative reussi${NC}"
    else
        echo -e "${RED}❌ Test taille negative echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NEGATIVE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NEGATIVE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test taille negative${NC}"
    TEST_RESULT=1
fi

# Test avec tableau de nombres negatifs
echo -e "${YELLOW}🧪 Test avec nombres negatifs...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    int test[] = {-1, -2, -3, -4};
    printf("Avant: ");
    print_array(test, 4);
    printf("\n");
    pw_reverse_array(test, 4);
    printf("Apres: ");
    print_array(test, 4);
    printf("\n");
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_NUMS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NEGATIVE_NUMS="Avant: [-1, -2, -3, -4]$
Apres: [-4, -3, -2, -1]$"
    if [ "$NEGATIVE_NUMS_OUTPUT" = "$EXPECTED_NEGATIVE_NUMS" ]; then
        echo -e "${GREEN}✅ Test nombres negatifs reussi${NC}"
    else
        echo -e "${RED}❌ Test nombres negatifs echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_NEGATIVE_NUMS"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$NEGATIVE_NUMS_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test nombres negatifs${NC}"
    TEST_RESULT=1
fi

# Test avec double inversion pour verifier que ca revient a l'original
echo -e "${YELLOW}🧪 Test double inversion...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

void print_array(int *arr, int size)
{
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

int main(void)
{
    int test[] = {1, 2, 3, 4, 5};
    int original[] = {1, 2, 3, 4, 5};
    
    printf("Original: ");
    print_array(test, 5);
    printf("\n");
    
    // Premiere inversion
    pw_reverse_array(test, 5);
    printf("1ere inversion: ");
    print_array(test, 5);
    printf("\n");
    
    // Deuxieme inversion (doit revenir a l'original)
    pw_reverse_array(test, 5);
    printf("2eme inversion: ");
    print_array(test, 5);
    printf("\n");
    
    // Verifier si on a bien retrouve l'original
    int same = 1;
    for (int i = 0; i < 5; i++) {
        if (test[i] != original[i]) {
            same = 0;
            break;
        }
    }
    
    if (same) {
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

# Test avec grand tableau
echo -e "${YELLOW}🧪 Test avec grand tableau...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'etudiant
void pw_reverse_array(int *arr, int size);

int main(void)
{
    int test[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    printf("Premier element avant: %d\n", test[0]);
    printf("Dernier element avant: %d\n", test[9]);
    
    pw_reverse_array(test, 10);
    
    printf("Premier element apres: %d\n", test[0]);
    printf("Dernier element apres: %d\n", test[9]);
    
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LARGE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_LARGE="Premier element avant: 1$
Dernier element avant: 10$
Premier element apres: 10$
Dernier element apres: 1$"
    if [ "$LARGE_OUTPUT" = "$EXPECTED_LARGE" ]; then
        echo -e "${GREEN}✅ Test grand tableau reussi${NC}"
    else
        echo -e "${RED}❌ Test grand tableau echoue${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_LARGE"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$LARGE_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test grand tableau${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 022 valide avec succes${NC}"
    echo -e "${GREEN}La fonction inverse correctement les tableaux!${NC}"
else
    echo -e "\n${RED}❌ Exercice 022 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"