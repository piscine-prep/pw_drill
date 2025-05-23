#!/bin/bash

# Script de test pour l'exercice 004 : Afficher les chiffres
# Usage: ./test_ex004.sh

EXERCISE_DIR="ex004"
SOURCE_FILE="pw_print_digits.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 004 : Afficher les chiffres ===${NC}"

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

// Prototype de la fonction de l'étudiant
void pw_print_digits(void);

int main(void)
{
    // Test de la fonction pw_print_digits
    pw_print_digits();
    
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
echo "0123456789$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="0123456789$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction affiche correctement '0123456789' avec retour à la ligne${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test échoué!${NC}"
    echo -e "${RED}Sortie attendue: '$EXPECTED_OUTPUT'${NC}"
    echo -e "${RED}Sortie obtenue: '$OUTPUT_VISIBLE'${NC}"
    
    # Comparer caractère par caractère pour diagnostic
    echo -e "${YELLOW}📋 Comparaison détaillée:${NC}"
    echo -n "Attendu: "
    echo "0123456789" | cat -e
    echo -n "Obtenu:  "
    echo "$OUTPUT_VISIBLE"
    
    TEST_RESULT=1
fi

# Vérifier spécifiquement la présence du retour à la ligne
if echo "$OUTPUT_VISIBLE" | grep -q '\$'; then
    echo -e "${GREEN}✅ Retour à la ligne correctement présent${NC}"
else
    echo -e "${RED}❌ Retour à la ligne manquant${NC}"
    TEST_RESULT=1
fi

# Vérifier que tous les chiffres sont présents dans l'ordre
DIGITS_ONLY=$(echo "$OUTPUT_VISIBLE" | sed 's/\$$//')
if [ "$DIGITS_ONLY" = "0123456789" ]; then
    echo -e "${GREEN}✅ Tous les chiffres sont présents dans l'ordre correct${NC}"
else
    echo -e "${RED}❌ Les chiffres ne sont pas dans l'ordre correct ou manquants${NC}"
    echo -e "${RED}Chiffres obtenus: '$DIGITS_ONLY'${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 004 validé avec succès${NC}"
else
    echo -e "\n${RED}❌ Exercice 004 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"