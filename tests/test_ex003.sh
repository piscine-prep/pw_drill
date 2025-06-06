#!/bin/bash

# Script de test pour l'exercice 003 : Alphabet a l'envers
# Usage: ./test_ex003.sh

EXERCISE_DIR="ex003"
SOURCE_FILE="pw_reverse_alphabet.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 003 : Alphabet a l'envers ===${NC}"

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
void pw_reverse_alphabet(void);

int main(void)
{
    // Test de la fonction pw_reverse_alphabet
    pw_reverse_alphabet();
    
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
echo "zyxwvutsrqponmlkjihgfedcba$"

EXEC_STATUS=$?

# Definir la sortie attendue
EXPECTED_OUTPUT="zyxwvutsrqponmlkjihgfedcba$"

# Verifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction affiche correctement l'alphabet a l'envers${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test echoue!${NC}"
    echo -e "${RED}Sortie attendue: '$EXPECTED_OUTPUT'${NC}"
    echo -e "${RED}Sortie obtenue: '$OUTPUT_VISIBLE'${NC}"
    
    # Comparer caractere par caractere pour diagnostic
    echo -e "${YELLOW}📋 Comparaison detaillee:${NC}"
    echo "Attendu: zyxwvutsrqponmlkjihgfedcba (suivi d'un retour a la ligne)"
    echo "Obtenu:  $OUTPUT_VISIBLE"
    
    # Verifier la longueur
    EXPECTED_LENGTH=27  # 26 lettres + 1 caractere '$' pour le retour a la ligne
    ACTUAL_LENGTH=${#OUTPUT_VISIBLE}
    echo "Longueur attendue: $EXPECTED_LENGTH caracteres"
    echo "Longueur obtenue: $ACTUAL_LENGTH caracteres"
    
    TEST_RESULT=1
fi

# Verifier specifiquement la presence du retour a la ligne
if echo "$OUTPUT_VISIBLE" | grep -q '\$'; then
    echo -e "${GREEN}✅ Retour a la ligne correctement present${NC}"
else
    echo -e "${RED}❌ Retour a la ligne manquant${NC}"
    TEST_RESULT=1
fi

# Verifier que toutes les lettres de l'alphabet sont presentes dans l'ordre inverse
echo -e "${YELLOW}🧪 Verification de l'ordre des lettres...${NC}"
ALPHABET_ONLY=$(echo "$OUTPUT_VISIBLE" | sed 's/\$//')
EXPECTED_ALPHABET="zyxwvutsrqponmlkjihgfedcba"

if [ "$ALPHABET_ONLY" = "$EXPECTED_ALPHABET" ]; then
    echo -e "${GREEN}✅ Ordre des lettres correct${NC}"
else
    echo -e "${RED}❌ Ordre des lettres incorrect${NC}"
    echo "Attendu: $EXPECTED_ALPHABET"
    echo "Obtenu:  $ALPHABET_ONLY"
    TEST_RESULT=1
fi

# Verifier qu'il n'y a pas d'espaces ou de caracteres indesirables
if echo "$ALPHABET_ONLY" | grep -q '[^a-z]'; then
    echo -e "${RED}❌ Caracteres indesirables detectes (espaces, chiffres, majuscules, etc.)${NC}"
    TEST_RESULT=1
else
    echo -e "${GREEN}✅ Aucun caractere indesirable detecte${NC}"
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 003 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 003 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"