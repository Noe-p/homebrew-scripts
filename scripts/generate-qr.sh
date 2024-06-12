#!/bin/bash

# Définition des couleurs
BLEU='\033[0;34m'
ORANGE='\033[0;33m'
GRIS_CLAIR='\033[0;37m'
VERT='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # Pas de couleur
ROUGE='\033[0;31m'

# Fonction d'affichage de l'aide
show_help() {
    echo -e "${VERT}Utilisation:${NC} $0 <texte_a_encoder> [<chemin_de_sortie>] [OPTIONS]"
    echo -e "Génère un QR code à partir du texte fourni."
    echo ""
    echo -e "${VERT}Options:${NC}"
    echo -e "  ${ORANGE}-s, --size${NC} SIZE    Définir la taille du QR code. Par défaut, c'est 30."
    echo -e "  ${ORANGE}-h, --help${NC}       Afficher cette aide et quitter."
    echo ""
    echo -e "${VERT}Exemples:${NC}"
    echo -e "  ${ORANGE}$0 'Bonjour le monde'${NC}             Génère un QR code avec le texte 'Bonjour le monde' et le sauvegarde dans ./qrcode.png."
    echo -e "  ${ORANGE}$0 'Bonjour le monde' /chemin/vers/dossier${NC}  Génère un QR code et le sauvegarde dans le dossier spécifié."
    echo -e "  ${ORANGE}$0 'Bonjour le monde' /chemin/vers/fichier.png${NC}  Génère un QR code et le sauvegarde dans le fichier spécifié."
    echo -e "  ${ORANGE}$0 'Bonjour le monde' -s 50${NC}       Génère un QR code avec une taille de 50."
}

# Fonction d'affichage de l'usage
usage() {
  echo -e "${ROUGE}Usage: $0 <texte_a_encoder> [<chemin_de_sortie>] [OPTIONS]${NC}"
  exit 1
}

# Vérifier si au moins un argument est passé
if [ $# -lt 1 ]; then
  usage
fi

# Initialisation des variables
TEXT=""
OUTPUT_PATH=""
SIZE=30  # Taille par défaut

# Parcourir les arguments pour détecter --help ou -h
for arg in "$@"; do
  case $arg in
    -h|--help)
      show_help
      exit 0
      ;;
  esac
done

# Traiter les arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -s|--size)
      SIZE="$2"
      shift # shift past argument
      shift # shift past value
      ;;
    *)
      if [ -z "$TEXT" ]; then
        TEXT="$1"
      elif [ -z "$OUTPUT_PATH" ]; then
        OUTPUT_PATH="$1"
      fi
      shift # shift past argument
      ;;
  esac
done

# Vérifier si TEXT est vide
if [ -z "$TEXT" ]; then
  usage
fi

# Si OUTPUT_PATH est vide, utiliser le chemin par défaut
if [ -z "$OUTPUT_PATH" ]; then
  OUTPUT_PATH="./qrcode.png"
fi

# Vérifier si OUTPUT_PATH est un répertoire et ajuster le chemin de sortie en conséquence
if [ -d "$OUTPUT_PATH" ]; then
  OUTPUT_FILE="$OUTPUT_PATH/qrcode.png"
else
  OUTPUT_FILE="$OUTPUT_PATH"
fi

# Générer le QR code
qrencode -o "$OUTPUT_FILE" -s "$SIZE" "$TEXT"

# Vérifier si la génération a réussi
if [ $? -eq 0 ]; then
  echo -e "${VERT}QR code généré avec succès : ${NC}$OUTPUT_FILE"
else
  echo -e "${ROUGE}Échec de la génération du QR code${NC}"
fi
