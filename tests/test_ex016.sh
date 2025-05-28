#!/bin/bash

# Script de test pour l'exercice 016 : Modifier une valeur via pointeur
# Usage: ./test_ex016.sh

EXERCISE_DIR="ex016"
SOURCE_FILE="pw_set_value.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 016 : Modifier une valeur via pointeur ===${NC}"

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

// Prototype de la fonction de l'étudiant
void pw_set_value(int *ptr);

int main(void)
{
    // Test de la fonction pw_set_value avec différentes valeurs
    int value1 = 10;
    printf("Avant: %d\n", value1);
    pw_set_value(&value1);
    printf("Apres: %d\n", value1);
    
    int value2 = -5;
    printf("Avant: %d\n", value2);
    pw_set_value(&value2);
    printf("Apres: %d\n", value2);
    
    int value3 = 0;
    printf("Avant: %d\n", value3);
    pw_set_value(&value3);
    printf("Apres: %d\n", value3);
    
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
echo "Avant: 10$"
echo "Apres: 42$"
echo "Avant: -5$"
echo "Apres: 42$"
echo "Avant: 0$"
echo "Apres: 42$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Avant: 10$
Apres: 42$
Avant: -5$
Apres: 42$
Avant: 0$
Apres: 42$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction modifie correctement les valeurs via pointeur${NC}"
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
    echo "pw_set_value(&value1) avec value1=10 -> doit donner 42"
    echo "pw_set_value(&value2) avec value2=-5 -> doit donner 42"
    echo "pw_set_value(&value3) avec value3=0 -> doit donner 42"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec un seul pointeur
echo -e "${YELLOW}🧪 Test individuel avec une valeur...${NC}"

# Créer un fichier de test pour une seule valeur
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_set_value(int *ptr);

int main(void)
{
    int test_value = 100;
    printf("Avant: %d\n", test_value);
    pw_set_value(&test_value);
    printf("Apres: %d\n", test_value);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_SINGLE="Avant: 100$
Apres: 42$"
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

# Test avec zéro
echo -e "${YELLOW}🧪 Test avec valeur zéro...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_set_value(int *ptr);

int main(void)
{
    int zero_value = 0;
    printf("Avant: %d\n", zero_value);
    pw_set_value(&zero_value);
    printf("Apres: %d\n", zero_value);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_ZERO="Avant: 0$
Apres: 42$"
    if [ "$ZERO_OUTPUT" = "$EXPECTED_ZERO" ]; then
        echo -e "${GREEN}✅ Test avec zéro réussi${NC}"
    else
        echo -e "${RED}❌ Test avec zéro échoué${NC}"
        echo -e "${RED}Sortie attendue:${NC}"
        echo "$EXPECTED_ZERO"
        echo -e "${RED}Sortie obtenue:${NC}"
        echo "$ZERO_OUTPUT"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec zéro${NC}"
    TEST_RESULT=1
fi

# Test avec NULL (vérifier qu'il n'y a pas de segfault)
echo -e "${YELLOW}🧪 Test avec valeur négative...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_set_value(int *ptr);

int main(void)
{
    int negative_value = -999;
    printf("%d\n", negative_value);
    pw_set_value(&negative_value);
    printf("%d\n", negative_value);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NEGATIVE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    EXPECTED_NEGATIVE="-999$
42$"
    if [ "$NEGATIVE_OUTPUT" = "$EXPECTED_NEGATIVE" ]; then
        echo -e "${GREEN}✅ Test valeur négative réussi${NC}"
    else
        echo -e "${RED}❌ Test valeur négative échoué${NC}"
        echo -e "${RED}Sortie attendue: '$EXPECTED_NEGATIVE'${NC}"
        echo -e "${RED}Sortie obtenue: '$NEGATIVE_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test valeur négative${NC}"
    TEST_RESULT=1
fi

# Test avec valeur négative
echo -e "${YELLOW}🧪 Test avec plusieurs pointeurs...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
void pw_set_value(int *ptr);

int main(void)
{
    int a = 1, b = 2, c = 3;
    
    pw_set_value(&a);
    pw_set_value(&b);
    pw_set_value(&c);
    
    printf("%d %d %d\n", a, b, c);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    MULTIPLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$MULTIPLE_OUTPUT" = "42 42 42$" ]; then
        echo -e "${GREEN}✅ Test plusieurs pointeurs réussi${NC}"
    else
        echo -e "${RED}❌ Test plusieurs pointeurs échoué - Sortie: '$MULTIPLE_OUTPUT' (attendu: '42 42 42$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test plusieurs pointeurs${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 016 validé avec succès${NC}"
    echo -e "${GREEN}La fonction modifie correctement les valeurs via pointeur!${NC}"
else
    echo -e "\n${RED}❌ Exercice 016 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"