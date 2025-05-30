#!/bin/bash

# Script de test pour l'exercice 025 : Vérifier si alphabétique
# Usage: ./test_ex025.sh

EXERCISE_DIR="ex025"
SOURCE_FILE="pw_is_alphabetic.c"
TEST_FILE="test_main.c"
EXECUTABLE="test_program"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Test de l'exercice 025 : Vérifier si alphabétique ===${NC}"

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
int pw_is_alphabetic(char *str);

int main(void)
{
    // Test de la fonction pw_is_alphabetic avec différentes chaînes
    printf("Test avec \"Hello\": %d\n", pw_is_alphabetic("Hello"));
    printf("Test avec \"HelloWorld\": %d\n", pw_is_alphabetic("HelloWorld"));
    printf("Test avec \"Hello World\": %d\n", pw_is_alphabetic("Hello World"));
    printf("Test avec \"Hello123\": %d\n", pw_is_alphabetic("Hello123"));
    printf("Test avec \"Test!\": %d\n", pw_is_alphabetic("Test!"));
    printf("Test avec \"\": %d\n", pw_is_alphabetic(""));
    printf("Test avec NULL: %d\n", pw_is_alphabetic(NULL));
    printf("Test avec \"ABC\": %d\n", pw_is_alphabetic("ABC"));
    printf("Test avec \"abc\": %d\n", pw_is_alphabetic("abc"));
    printf("Test avec \"AbCdEf\": %d\n", pw_is_alphabetic("AbCdEf"));
    
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
echo "Test avec \"Hello\": 1$"
echo "Test avec \"HelloWorld\": 1$"
echo "Test avec \"Hello World\": 0$"
echo "Test avec \"Hello123\": 0$"
echo "Test avec \"Test!\": 0$"
echo "Test avec \"\": 1$"
echo "Test avec NULL: 0$"
echo "Test avec \"ABC\": 1$"
echo "Test avec \"abc\": 1$"
echo "Test avec \"AbCdEf\": 1$"

EXEC_STATUS=$?

# Définir la sortie attendue
EXPECTED_OUTPUT="Test avec \"Hello\": 1$
Test avec \"HelloWorld\": 1$
Test avec \"Hello World\": 0$
Test avec \"Hello123\": 0$
Test avec \"Test!\": 0$
Test avec \"\": 1$
Test avec NULL: 0$
Test avec \"ABC\": 1$
Test avec \"abc\": 1$
Test avec \"AbCdEf\": 1$"

# Vérifier si la sortie est correcte
if [ "$OUTPUT_VISIBLE" = "$EXPECTED_OUTPUT" ]; then
    echo -e "${GREEN}✅ Test réussi! La fonction vérifie correctement si une chaîne est alphabétique${NC}"
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
    echo "pw_is_alphabetic(\"Hello\") -> attendu: 1 (que des lettres)"
    echo "pw_is_alphabetic(\"HelloWorld\") -> attendu: 1 (que des lettres)"
    echo "pw_is_alphabetic(\"Hello World\") -> attendu: 0 (contient un espace)"
    echo "pw_is_alphabetic(\"Hello123\") -> attendu: 0 (contient des chiffres)"
    echo "pw_is_alphabetic(\"Test!\") -> attendu: 0 (contient un caractère spécial)"
    echo "pw_is_alphabetic(\"\") -> attendu: 1 (chaîne vide)"
    echo "pw_is_alphabetic(NULL) -> attendu: 0 (pointeur NULL)"
    echo "pw_is_alphabetic(\"ABC\") -> attendu: 1 (majuscules)"
    echo "pw_is_alphabetic(\"abc\") -> attendu: 1 (minuscules)"
    echo "pw_is_alphabetic(\"AbCdEf\") -> attendu: 1 (mélange majuscules/minuscules)"
    echo "======================="
    
    TEST_RESULT=1
fi

# Test individuel pour vérifier le comportement avec "Hello"
echo -e "${YELLOW}🧪 Test individuel avec 'Hello'...${NC}"

# Créer un fichier de test pour une seule chaîne
cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("Hello"));
    return (0);
}
EOF

# Recompiler avec le test individuel
gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test individuel réussi${NC}"
    else
        echo -e "${RED}❌ Test individuel échoué - Sortie: '$SINGLE_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test individuel${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne contenant des chiffres
echo -e "${YELLOW}🧪 Test avec chiffres...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("abc123"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    DIGITS_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$DIGITS_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test avec chiffres réussi${NC}"
    else
        echo -e "${RED}❌ Test avec chiffres échoué - Sortie: '$DIGITS_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test avec chiffres${NC}"
    TEST_RESULT=1
fi

# Test avec caractères spéciaux
echo -e "${YELLOW}🧪 Test avec caractères spéciaux...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("Hello@World"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPECIAL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPECIAL_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test caractères spéciaux réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères spéciaux échoué - Sortie: '$SPECIAL_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères spéciaux${NC}"
    TEST_RESULT=1
fi

# Test avec NULL
echo -e "${YELLOW}🧪 Test avec NULL...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic(NULL));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    NULL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$NULL_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test NULL réussi${NC}"
    else
        echo -e "${RED}❌ Test NULL échoué - Sortie: '$NULL_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test NULL${NC}"
    TEST_RESULT=1
fi

# Test avec chaîne vide
echo -e "${YELLOW}🧪 Test avec chaîne vide...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic(""));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    EMPTY_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$EMPTY_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test chaîne vide réussi${NC}"
    else
        echo -e "${RED}❌ Test chaîne vide échoué - Sortie: '$EMPTY_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test chaîne vide${NC}"
    TEST_RESULT=1
fi

# Test avec seulement des majuscules
echo -e "${YELLOW}🧪 Test avec majuscules uniquement...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("ABCDEFGHIJKLMNOPQRSTUVWXYZ"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    UPPER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$UPPER_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test majuscules uniquement réussi${NC}"
    else
        echo -e "${RED}❌ Test majuscules uniquement échoué - Sortie: '$UPPER_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test majuscules uniquement${NC}"
    TEST_RESULT=1
fi

# Test avec seulement des minuscules
echo -e "${YELLOW}🧪 Test avec minuscules uniquement...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("abcdefghijklmnopqrstuvwxyz"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    LOWER_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$LOWER_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test minuscules uniquement réussi${NC}"
    else
        echo -e "${RED}❌ Test minuscules uniquement échoué - Sortie: '$LOWER_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test minuscules uniquement${NC}"
    TEST_RESULT=1
fi

# Test avec espace en début
echo -e "${YELLOW}🧪 Test avec espace en début...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic(" Hello"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SPACE_START_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SPACE_START_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test espace en début réussi${NC}"
    else
        echo -e "${RED}❌ Test espace en début échoué - Sortie: '$SPACE_START_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test espace en début${NC}"
    TEST_RESULT=1
fi

# Test avec caractères de contrôle
echo -e "${YELLOW}🧪 Test avec caractères de contrôle...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("Hello\tWorld"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    CONTROL_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$CONTROL_OUTPUT" = "0$" ]; then
        echo -e "${GREEN}✅ Test caractères de contrôle réussi${NC}"
    else
        echo -e "${RED}❌ Test caractères de contrôle échoué - Sortie: '$CONTROL_OUTPUT' (attendu: '0$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test caractères de contrôle${NC}"
    TEST_RESULT=1
fi

# Test avec un seul caractère alphabétique
echo -e "${YELLOW}🧪 Test avec un seul caractère...${NC}"

cat > "$TEST_FILE" << 'EOF'
#include <unistd.h>
#include <stdio.h>

// Prototype de la fonction de l'étudiant
int pw_is_alphabetic(char *str);

int main(void)
{
    printf("%d\n", pw_is_alphabetic("A"));
    return (0);
}
EOF

gcc -Wall -Wextra -Werror -o "$EXECUTABLE" "$SOURCE_FILE" "$TEST_FILE" 2> compilation_errors.txt

if [ $? -eq 0 ]; then
    SINGLE_CHAR_OUTPUT=$(./"$EXECUTABLE" | cat -e)
    if [ "$SINGLE_CHAR_OUTPUT" = "1$" ]; then
        echo -e "${GREEN}✅ Test un seul caractère réussi${NC}"
    else
        echo -e "${RED}❌ Test un seul caractère échoué - Sortie: '$SINGLE_CHAR_OUTPUT' (attendu: '1$')${NC}"
        TEST_RESULT=1
    fi
else
    echo -e "${RED}❌ Erreur de compilation du test un seul caractère${NC}"
    TEST_RESULT=1
fi

# Nettoyage
rm -f "$EXECUTABLE" "$TEST_FILE" compilation_errors.txt

if [ $EXEC_STATUS -eq 0 ] && [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✅ Exercice 025 validé avec succès${NC}"
    echo -e "${GREEN}La fonction vérifie correctement si une chaîne ne contient que des lettres alphabétiques!${NC}"
else
    echo -e "\n${RED}❌ Exercice 025 non validé${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Fin des tests ===${NC}"