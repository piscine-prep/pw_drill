#!/bin/bash

# Script de test pour l'exercice 012 : Combinaisons de bits
# Usage: ./test_ex012.sh

EXERCISE_DIR="ex012"
SOURCE_FILE="pw_print_bits.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 012 : Combinaisons de bits ===${NC}"

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
void pw_print_bits(void);

int main(void)
{
    // Test de la fonction pw_print_bits
    pw_print_bits();
    
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
echo "Generation de toutes les combinaisons de bits..."
./"$EXECUTABLE" > program_output.txt
EXEC_STATUS=$?

# Verifier le nombre de lignes (doit etre exactement 256)
LINE_COUNT=$(wc -l < program_output.txt)
echo "Nombre de lignes generees: $LINE_COUNT"

if [ "$LINE_COUNT" -eq 256 ]; then
    echo -e "${GREEN}✅ Nombre correct de combinaisons (256)${NC}"
    COUNT_TEST=0
else
    echo -e "${RED}❌ Nombre incorrect de combinaisons. Attendu: 256, Obtenu: $LINE_COUNT${NC}"
    COUNT_TEST=1
fi

# Afficher les premieres et dernieres lignes avec cat -e pour verifier le format
echo -e "${YELLOW}📋 Premieres lignes avec cat -e:${NC}"
head -10 program_output.txt | cat -e

echo -e "${YELLOW}📋 Dernieres lignes avec cat -e:${NC}"
tail -10 program_output.txt | cat -e

# Verifier quelques combinaisons specifiques
echo -e "${YELLOW}🧪 Verification des combinaisons specifiques...${NC}"

# Verifier la premiere ligne (00000000)
FIRST_LINE=$(head -1 program_output.txt)
if [ "$FIRST_LINE" = "00000000" ]; then
    echo -e "${GREEN}✅ Premiere combinaison correcte (00000000)${NC}"
    FIRST_TEST=0
else
    echo -e "${RED}❌ Premiere combinaison incorrecte. Attendu: '00000000', Obtenu: '$FIRST_LINE'${NC}"
    FIRST_TEST=1
fi

# Verifier la derniere ligne (11111111)
LAST_LINE=$(tail -1 program_output.txt)
if [ "$LAST_LINE" = "11111111" ]; then
    echo -e "${GREEN}✅ Derniere combinaison correcte (11111111)${NC}"
    LAST_TEST=0
else
    echo -e "${RED}❌ Derniere combinaison incorrecte. Attendu: '11111111', Obtenu: '$LAST_LINE'${NC}"
    LAST_TEST=1
fi

# Verifier quelques lignes au milieu
TENTH_LINE=$(sed -n '10p' program_output.txt)
if [ "$TENTH_LINE" = "00001001" ]; then
    echo -e "${GREEN}✅ 10eme combinaison correcte (00001001)${NC}"
    TENTH_TEST=0
else
    echo -e "${RED}❌ 10eme combinaison incorrecte. Attendu: '00001001', Obtenu: '$TENTH_LINE'${NC}"
    TENTH_TEST=1
fi

# Verifier que chaque ligne contient exactement 8 caracteres (sans compter le retour a la ligne)
echo -e "${YELLOW}🧪 Verification de la longueur des lignes...${NC}"
INVALID_LENGTH_COUNT=$(awk 'length($0) != 8' program_output.txt | wc -l)

if [ "$INVALID_LENGTH_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ Toutes les lignes ont la bonne longueur (8 caracteres)${NC}"
    LENGTH_TEST=0
else
    echo -e "${RED}❌ $INVALID_LENGTH_COUNT lignes ont une longueur incorrecte${NC}"
    echo "Exemples de lignes avec longueur incorrecte:"
    awk 'length($0) != 8 {print NR ": " $0 " (longueur: " length($0) ")"}' program_output.txt | head -5
    LENGTH_TEST=1
fi

# Verifier que toutes les lignes ne contiennent que des 0 et des 1
echo -e "${YELLOW}🧪 Verification du contenu des lignes...${NC}"
INVALID_CONTENT_COUNT=$(grep -v '^[01]*$' program_output.txt | wc -l)

if [ "$INVALID_CONTENT_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ Toutes les lignes ne contiennent que des 0 et des 1${NC}"
    CONTENT_TEST=0
else
    echo -e "${RED}❌ $INVALID_CONTENT_COUNT lignes contiennent des caracteres invalides${NC}"
    echo "Exemples de lignes avec contenu invalide:"
    grep -v '^[01]*$' program_output.txt | head -5
    CONTENT_TEST=1
fi

# Verifier qu'il n'y a pas de doublons
echo -e "${YELLOW}🧪 Verification des doublons...${NC}"
UNIQUE_COUNT=$(sort program_output.txt | uniq | wc -l)

if [ "$UNIQUE_COUNT" -eq 256 ]; then
    echo -e "${GREEN}✅ Aucun doublon detecte${NC}"
    DUPLICATE_TEST=0
else
    echo -e "${RED}❌ Des doublons ont ete detectes. Combinaisons uniques: $UNIQUE_COUNT${NC}"
    echo "Exemples de doublons:"
    sort program_output.txt | uniq -d | head -5
    DUPLICATE_TEST=1
fi

# Verifier que les retours a la ligne sont presents
echo -e "${YELLOW}🧪 Verification des retours a la ligne...${NC}"
OUTPUT_WITH_MARKERS=$(cat program_output.txt | cat -e)
NEWLINE_COUNT=$(echo "$OUTPUT_WITH_MARKERS" | grep '\$$' | wc -l)

if [ "$NEWLINE_COUNT" -eq 256 ]; then
    echo -e "${GREEN}✅ Tous les retours a la ligne sont presents${NC}"
    NEWLINE_TEST=0
else
    echo -e "${RED}❌ Retours a la ligne manquants. Attendu: 256, Trouve: $NEWLINE_COUNT${NC}"
    NEWLINE_TEST=1
fi

# Calcul du resultat final
TOTAL_TESTS=$((COUNT_TEST + FIRST_TEST + LAST_TEST + TENTH_TEST + LENGTH_TEST + CONTENT_TEST + DUPLICATE_TEST + NEWLINE_TEST))

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt program_output.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TOTAL_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 012 valide avec succes${NC}"
    echo -e "${GREEN}Toutes les 256 combinaisons de bits ont ete generees correctement!${NC}"
else
    echo -e "\n${RED}❌ Exercice 012 non valide${NC}"
    echo -e "${RED}Problemes detectes: $TOTAL_TESTS${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"