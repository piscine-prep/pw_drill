#!/bin/bash

# Script de test pour l'exercice 001 : Hello Powercoders
# Usage: ./test_ex001.sh

EXERCISE_DIR="ex001"
SOURCE_FILE="pw_hello_powercoders.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 001 : Hello Powercoders ===${NC}"

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
void pw_hello_powercoders(void);

int main(void)
{
    // Test de la fonction pw_hello_powercoders
    pw_hello_powercoders();
    
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

# Executer le programme et capturer la sortie
./"$EXECUTABLE" > program_output.txt
EXEC_STATUS=$?

echo -e "${YELLOW}📋 Sortie du programme (avec cat -e pour voir les caracteres caches):${NC}"
cat -e program_output.txt

echo -e "${YELLOW}📋 Resultat attendu:${NC}"
echo "Hello, Powercoders!" | cat -e

# Verifier si la sortie est correcte
EXPECTED="Hello, Powercoders!"
OUTPUT=$(cat program_output.txt)

if [ "$OUTPUT" = "$EXPECTED" ]; then
    echo -e "${GREEN}✅ Test reussi! La fonction affiche correctement 'Hello, Powercoders!' avec retour a la ligne${NC}"
    TEST_RESULT=0
else
    echo -e "${RED}❌ Test echoue!${NC}"
    echo -e "${RED}Sortie attendue: '$EXPECTED'${NC}"
    echo -e "${RED}Sortie obtenue: '$OUTPUT'${NC}"
    
    # Comparer caractere par caractere pour diagnostic
    echo -e "${YELLOW}📋 Comparaison detaillee:${NC}"
    echo -n "Attendu: "
    echo "Hello, Powercoders!" | cat -e
    echo -n "Obtenu:  "
    cat -e program_output.txt
    
    TEST_RESULT=1
fi

# Verifier specifiquement la presence du retour a la ligne
if cat -e program_output.txt | grep -q '\$'; then
    echo -e "${GREEN}✅ Retour a la ligne correctement present${NC}"
else
    echo -e "${RED}❌ Retour a la ligne manquant${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt program_output.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 001 valide avec succes${NC}"
else
    echo -e "\n${RED}❌ Exercice 001 non valide${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"