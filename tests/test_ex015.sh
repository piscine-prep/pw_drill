#!/bin/bash

# Script de test pour l'exercice 015 : Tailles des types avec sizeof
# Usage: ./test_ex015.sh

EXERCISE_DIR="ex015"
SOURCE_FILE="pw_sizeof.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 015 : Tailles des types avec sizeof ===${NC}"

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
void pw_sizeof(void);

int main(void)
{
    // Test de la fonction pw_sizeof
    pw_sizeof();
    
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
echo -e "${YELLOW}📋 Résultat de référence avec cat -e:${NC}"
echo "char: 1 octets$"
echo "short: 2 octets$"
echo "int: 4 octets$"
echo "long: 8 octets$"
echo "float: 4 octets$"
echo "double: 8 octets$"

EXEC_STATUS=$?

# Obtenir les tailles réelles sur le système actuel pour la validation
CHAR_SIZE=$(gcc -c -x c -o /dev/null - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(char));}" 2>/dev/null && echo 1 || echo 1)
SHORT_SIZE=$(gcc -x c -o temp_sizeof - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(short)); return 0;}" 2>/dev/null && ./temp_sizeof 2>/dev/null && rm -f temp_sizeof || echo 2)
INT_SIZE=$(gcc -x c -o temp_sizeof - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(int)); return 0;}" 2>/dev/null && ./temp_sizeof 2>/dev/null && rm -f temp_sizeof || echo 4)
LONG_SIZE=$(gcc -x c -o temp_sizeof - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(long)); return 0;}" 2>/dev/null && ./temp_sizeof 2>/dev/null && rm -f temp_sizeof || echo 8)
FLOAT_SIZE=$(gcc -x c -o temp_sizeof - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(float)); return 0;}" 2>/dev/null && ./temp_sizeof 2>/dev/null && rm -f temp_sizeof || echo 4)
DOUBLE_SIZE=$(gcc -x c -o temp_sizeof - <<< "#include <stdio.h>; int main(){printf(\"%zu\", sizeof(double)); return 0;}" 2>/dev/null && ./temp_sizeof 2>/dev/null && rm -f temp_sizeof || echo 8)

# Nettoyage des fichiers temporaires
rm -f temp_sizeof

# Construire la sortie attendue basée sur les tailles réelles du système
EXPECTED_OUTPUT="char: ${CHAR_SIZE} octets$
short: ${SHORT_SIZE} octets$
int: ${INT_SIZE} octets$
long: ${LONG_SIZE} octets$
float: ${FLOAT_SIZE} octets$
double: ${DOUBLE_SIZE} octets$"

echo -e "${YELLOW}📋 Tailles détectées sur ce système:${NC}"
echo "char: ${CHAR_SIZE} octets"
echo "short: ${SHORT_SIZE} octets"
echo "int: ${INT_SIZE} octets"
echo "long: ${LONG_SIZE} octets"
echo "float: ${FLOAT_SIZE} octets"
echo "double: ${DOUBLE_SIZE} octets"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction affiche correctement toutes les tailles${NC}"
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
    echo "Vérification des tailles avec sizeof pour chaque type"
    echo "Les tailles peuvent varier selon l'architecture (32-bit vs 64-bit)"
    echo "======================="
    
    TEST_RESULT=1
fi

# Vérifier que chaque ligne contient le format attendu
echo -e "${YELLOW}🧪 Vérification du format des lignes...${NC}"

# Vérifier que toutes les lignes sont présentes
CHAR_LINE=$(echo "$OUTPUT_VISIBLE" | grep "char:" | head -1)
SHORT_LINE=$(echo "$OUTPUT_VISIBLE" | grep "short:" | head -1)
INT_LINE=$(echo "$OUTPUT_VISIBLE" | grep "int:" | head -1)
LONG_LINE=$(echo "$OUTPUT_VISIBLE" | grep "long:" | head -1)
FLOAT_LINE=$(echo "$OUTPUT_VISIBLE" | grep "float:" | head -1)
DOUBLE_LINE=$(echo "$OUTPUT_VISIBLE" | grep "double:" | head -1)

FORMAT_TEST=0

if [ -z "$CHAR_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'char' manquante${NC}"
    FORMAT_TEST=1
fi

if [ -z "$SHORT_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'short' manquante${NC}"
    FORMAT_TEST=1
fi

if [ -z "$INT_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'int' manquante${NC}"
    FORMAT_TEST=1
fi

if [ -z "$LONG_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'long' manquante${NC}"
    FORMAT_TEST=1
fi

if [ -z "$FLOAT_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'float' manquante${NC}"
    FORMAT_TEST=1
fi

if [ -z "$DOUBLE_LINE" ]; then
    echo -e "${RED}❌ Ligne pour 'double' manquante${NC}"
    FORMAT_TEST=1
fi

if [ $FORMAT_TEST -eq 0 ]; then
    echo -e "${GREEN}✅ Toutes les lignes de types sont présentes${NC}"
fi

# Vérifier le nombre total de lignes (doit être exactement 6)
LINE_COUNT=$(echo "$OUTPUT_VISIBLE" | wc -l)
if [ "$LINE_COUNT" -eq 6 ]; then
    echo -e "${GREEN}✅ Nombre correct de lignes (6)${NC}"
else
    echo -e "${RED}❌ Nombre incorrect de lignes. Attendu: 6, Obtenu: $LINE_COUNT${NC}"
    TEST_RESULT=1
fi

# Vérifier que chaque ligne se termine par un retour à la ligne
NEWLINE_COUNT=$(echo "$OUTPUT_VISIBLE" | grep '\$' | wc -l)
if [ "$NEWLINE_COUNT" -eq 6 ]; then
    echo -e "${GREEN}✅ Tous les retours à la ligne sont présents${NC}"
else
    echo -e "${RED}❌ Retours à la ligne manquants. Attendu: 6, Trouvé: $NEWLINE_COUNT${NC}"
    TEST_RESULT=1
fi

# Vérifier que les tailles sont des nombres valides
echo -e "${YELLOW}🧪 Vérification que les tailles sont des nombres...${NC}"
NUMBERS_VALID=1

# Extraire les nombres de chaque ligne et vérifier qu'ils sont valides
CHAR_NUM=$(echo "$CHAR_LINE" | sed 's/char: \([0-9]*\) octets\$/\1/')
SHORT_NUM=$(echo "$SHORT_LINE" | sed 's/short: \([0-9]*\) octets\$/\1/')
INT_NUM=$(echo "$INT_LINE" | sed 's/int: \([0-9]*\) octets\$/\1/')
LONG_NUM=$(echo "$LONG_LINE" | sed 's/long: \([0-9]*\) octets\$/\1/')
FLOAT_NUM=$(echo "$FLOAT_LINE" | sed 's/float: \([0-9]*\) octets\$/\1/')
DOUBLE_NUM=$(echo "$DOUBLE_LINE" | sed 's/double: \([0-9]*\) octets\$/\1/')

# Vérifier que tous les nombres extraits sont des entiers positifs
for num in "$CHAR_NUM" "$SHORT_NUM" "$INT_NUM" "$LONG_NUM" "$FLOAT_NUM" "$DOUBLE_NUM"; do
    if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -eq 0 ]; then
        echo -e "${RED}❌ Taille invalide détectée: '$num'${NC}"
        NUMBERS_VALID=0
    fi
done

if [ $NUMBERS_VALID -eq 1 ]; then
    echo -e "${GREEN}✅ Toutes les tailles sont des nombres valides${NC}"
else
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ] && [ $FORMAT_TEST -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 015 validé avec succès${NC}"
    echo -e "${GREEN}La fonction affiche correctement les tailles de tous les types!${NC}"
else
    echo -e "\n${RED}❌ Exercice 015 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"