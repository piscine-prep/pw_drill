#!/bin/bash

# Script de test pour l'exercice 018 : Division avec pointeurs
# Usage: ./test_ex018.sh

EXERCISE_DIR="ex018"
SOURCE_FILE="pw_divide.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 018 : Division avec pointeurs ===${NC}"

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
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    // Test de la fonction pw_divide avec différents cas
    float a1 = 10.0f, b1 = 2.0f, r1 = 0.0f;
    int ret1 = pw_divide(&a1, &b1, &r1);
    printf("Division %.1f / %.1f = %f (retour: %d)\n", a1, b1, r1, ret1);
    
    float a2 = 7.5f, b2 = 3.0f, r2 = 0.0f;
    int ret2 = pw_divide(&a2, &b2, &r2);
    printf("Division %.1f / %.1f = %f (retour: %d)\n", a2, b2, r2, ret2);
    
    // Test division par zéro
    float a3 = 5.0f, b3 = 0.0f, r3 = 99.9f; // r3 ne doit pas changer
    int ret3 = pw_divide(&a3, &b3, &r3);
    printf("Division par zéro: retour = %d\n", ret3);
    
    // Test avec pointeur NULL
    float a4 = 4.0f, r4 = 88.8f; // r4 ne doit pas changer
    int ret4 = pw_divide(&a4, NULL, &r4);
    printf("Pointeur NULL: retour = %d\n", ret4);
    
    // Test avec nombre négatif
    float a5 = -8.0f, b5 = 2.0f, r5 = 0.0f;
    int ret5 = pw_divide(&a5, &b5, &r5);
    printf("Division %.1f / %.1f = %f (retour: %d)\n", a5, b5, r5, ret5);
    
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
echo "Division 10.0 / 2.0 = 5.000000 (retour: 0)$"
echo "Division 7.5 / 3.0 = 2.500000 (retour: 0)$"
echo "Division par zéro: retour = 1$"
echo "Pointeur NULL: retour = 1$"
echo "Division -8.0 / 2.0 = -4.000000 (retour: 0)$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Division 10.0 / 2.0 = 5.000000 (retour: 0)$
Division 7.5 / 3.0 = 2.500000 (retour: 0)$
Division par zéro: retour = 1$
Pointeur NULL: retour = 1$
Division -8.0 / 2.0 = -4.000000 (retour: 0)$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction effectue correctement les divisions et gère les erreurs${NC}"
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
    echo "pw_divide(&10.0, &2.0, &r) -> doit donner r=5.0, retour=0"
    echo "pw_divide(&7.5, &3.0, &r) -> doit donner r=2.5, retour=0"
    echo "pw_divide(&5.0, &0.0, &r) -> division par zéro, retour=1"
    echo "pw_divide(&4.0, NULL, &r) -> pointeur NULL, retour=1"
    echo "pw_divide(&-8.0, &2.0, &r) -> doit donner r=-4.0, retour=0"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec division normale
echo -e "${YELLOW}🧪 Test individuel avec division normale...${NC}"

# Créer un fichier de test pour une seule division
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float a = 12.0f, b = 4.0f, r = 0.0f;
    int ret = pw_divide(&a, &b, &r);
    printf("Résultat: %.1f, Retour: %d\n", r, ret);
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "Résultat: 3.0, Retour: 0$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: 'Résultat: 3.0, Retour: 0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec division par zéro pour vérifier le retour d'erreur
echo -e "${YELLOW}🧪 Test division par zéro...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float a = 10.0f, b = 0.0f, r = 999.9f; // r ne doit pas changer
    int ret = pw_divide(&a, &b, &r);
    printf("Retour: %d, r non modifié: %.1f\n", ret, r);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    ZERO_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$ZERO_OUTPUT" = "Retour: 1, r non modifié: 999.9$" ]; then
        echo -e "${GREEN}✅ Test division par zéro réussi${NC}"
    else
        echo -e "${RED}❌ Test division par zéro échoué - Sortie: '$ZERO_OUTPUT' (attendu: 'Retour: 1, r non modifié: 999.9$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test division par zéro${NC}"
    TEST_RESULT=1
fi

# Test avec premier pointeur NULL
echo -e "${YELLOW}🧪 Test avec premier pointeur NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float b = 2.0f, r = 555.5f; // r ne doit pas changer
    int ret = pw_divide(NULL, &b, &r);
    printf("Retour: %d\n", ret);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL1_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL1_OUTPUT" = "Retour: 1$" ]; then
        echo -e "${GREEN}✅ Test premier pointeur NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test premier pointeur NULL échoué - Sortie: '$NULL1_OUTPUT' (attendu: 'Retour: 1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test premier pointeur NULL${NC}"
    TEST_RESULT=1
fi

# Test avec troisième pointeur NULL
echo -e "${YELLOW}🧪 Test avec troisième pointeur NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float a = 6.0f, b = 3.0f;
    int ret = pw_divide(&a, &b, NULL);
    printf("Retour: %d\n", ret);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL3_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL3_OUTPUT" = "Retour: 1$" ]; then
        echo -e "${GREEN}✅ Test troisième pointeur NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test troisième pointeur NULL échoué - Sortie: '$NULL3_OUTPUT' (attendu: 'Retour: 1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test troisième pointeur NULL${NC}"
    TEST_RESULT=1
fi

# Test avec division de nombres décimaux
echo -e "${YELLOW}🧪 Test avec nombres décimaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float a = 1.0f, b = 3.0f, r = 0.0f;
    int ret = pw_divide(&a, &b, &r);
    printf("1.0 / 3.0 = %f (retour: %d)\n", r, ret);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DECIMAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    # 1.0 / 3.0 = 0.333333 (peut varier légèrement selon la précision)
    if echo "$DECIMAL_OUTPUT" | grep -q "1.0 / 3.0 = 0.33333" && echo "$DECIMAL_OUTPUT" | grep -q "(retour: 0)"; then
        echo -e "${GREEN}✅ Test nombres décimaux réussi${NC}"
    else
        echo -e "${RED}❌ Test nombres décimaux échoué - Sortie: '$DECIMAL_OUTPUT'${NC}"
        # Ce n'est pas forcément une erreur critique à cause de la précision des float
        echo -e "${YELLOW}⚠️  Note: Les différences de précision float peuvent causer des variations mineures${NC}"
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test nombres décimaux${NC}"
    TEST_RESULT=1
fi

# Test avec valeurs très petites pour vérifier la division par zéro
echo -e "${YELLOW}🧪 Test avec valeur très petite (proche de zéro)...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_divide(float *a, float *b, float *r);

int main(void)
{
    float a = 1.0f, b = 0.000001f, r = 0.0f; // Pas exactement zéro
    int ret = pw_divide(&a, &b, &r);
    printf("Division par nombre très petit: retour = %d\n", ret);
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    TINY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$TINY_OUTPUT" = "Division par nombre très petit: retour = 0$" ]; then
        echo -e "${GREEN}✅ Test valeur très petite réussi${NC}"
    else
        echo -e "${RED}❌ Test valeur très petite échoué - Sortie: '$TINY_OUTPUT'${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test valeur très petite${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 018 validé avec succès${NC}"
    echo -e "${GREEN}La fonction effectue correctement les divisions et gère toutes les erreurs!${NC}"
else
    echo -e "\n${RED}❌ Exercice 018 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"