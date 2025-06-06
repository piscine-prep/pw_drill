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

// Prototype de la fonction de l'etudiant
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
echo "0123456789$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="0123456789$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction affiche correctement '0123456789' avec retour a la ligne${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test echoue!${NC}"
    echo -e "${RED}Sortie attendue: '$EXPECTED_OUTPUT'${NC}"
    echo -e "${RED}Sortie obtenue: '$OUTPUT_VISIBLE'${NC}"
    
    # Comparer caractere par caractere pour diagnostic
    echo -e "${YELLOW}📋 Comparaison detaillee:${NC}"
    echo -n "Attendu: "
    echo "0123456789" | cat -e
    echo -n "Obtenu:  "
    echo "$OUTPUT_VISIBLE"
    
    TEST_RESULT=1
fi

# Verifier specifiquement la presence du retour a la ligne
if echo "$OUTPUT_VISIBLE" | grep -q '\$'; then
    echo -e "${GREEN}✅ Retour a la ligne correctement present${NC}"
else
    echo -e "${RED}❌ Retour a la ligne manquant${NC}"
    TEST_RESULT=1
fi

# Verifier que tous les chiffres sont presents dans l'ordre
DIGITS_ONLY=$(echo "$OUTPUT_VISIBLE" | sed 's/\$$//')
if [ "$DIGITS_ONLY" = "0123456789" ]; then
    echo -e "${GREEN}✅ Tous les chiffres sont presents dans l'ordre correct${NC}"
else
    echo -e "${RED}❌ Les chiffres ne sont pas dans l'ordre correct ou manquants${NC}"
    echo -e "${RED}Chiffres obtenus: '$DIGITS_ONLY'${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 004 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 004 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"