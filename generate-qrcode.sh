#!/bin/bash

# Fonction d'affichage de l'usage
usage() {
  echo "Usage: $0 <texte_a_encoder> [<chemin_de_sortie>] [-s taille]"
  exit 1
}

# Vérifier si au moins un argument est passé
if [ $# -lt 1 ]; then
  usage
fi

# Initialisation des variables
TEXT=$1
OUTPUT_PATH="./qrcode.png"  # Chemin par défaut
SIZE=30  # Taille par défaut

# Vérifier si le deuxième argument est fourni et qu'il ne commence pas par un tiret (indiquant une option)
if [ $# -ge 2 ] && [[ $2 != -* ]]; then
  OUTPUT_PATH=$2
  shift 2
else
  shift 1
fi

# Traitement des options
while getopts ":s:" opt; do
  case $opt in
    s)
      SIZE=$OPTARG
      ;;
    \?)
      echo "Option invalide: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "L'option -$OPTARG requiert un argument." >&2
      usage
      ;;
  esac
done

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
  echo "QR code généré avec succès : $OUTPUT_FILE"
else
  echo "Échec de la génération du QR code"
fi
