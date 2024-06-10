#!/bin/bash

# Importation des fichiers de fonctions
source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/helpers.sh"
source "$(dirname "$0")/image_functions.sh"
source "$(dirname "$0")/video_functions.sh"
source "$(dirname "$0")/logo_functions.sh"

show_help() {
    echo -e "${VERT}Utilisation:${NC} optimize [DOSSIER|FICHIER] [OPTIONS]"
    echo -e "Optimise et redimensionne les images et vidéos dans le ${ORANGE}DOSSIER${NC} ou le ${ORANGE}FICHIER${NC} spécifié."
    echo ""
    echo -e "${VERT}Options:${NC}"
    echo -e "  ${ORANGE}-r, --rush${NC}       Copie les médias vers un dossier rush avant d'optimiser et de redimensionner."
    echo -e "  ${ORANGE}-d, --degree${NC} DEGREE  Définir le degré d'optimisation de 0 à 99. Par défaut, c'est 50."
    echo -e "  ${ORANGE}-f, --format${NC} FORMAT  Choisir le format de sortie (png, jpg, webp). Par défaut, c'est webp."
    echo -e "  ${ORANGE}-l, --logo${NC} LOGO    Redimensionner un logo aux tailles standard (512, 384, 192, etc.)."
    echo -e "  ${ORANGE}-h, --help${NC}       Afficher cette aide et quitter."
    echo ""
    echo -e "${VERT}Exemples:${NC}"
    echo -e "  ${ORANGE}optimize .${NC}             Optimise les médias dans le dossier actuel avec un degré par défaut de 50 et en format webp."
    echo -e "  ${ORANGE}optimize ./photo.png${NC}  Optimise l'image spécifiée avec un degré par défaut de 50 et en format webp."
    echo -e "  ${ORANGE}optimize . -d 80${NC}      Optimise les médias dans le dossier actuel avec un degré de 80 et en format webp."
    echo -e "  ${ORANGE}optimize . -r${NC}         Copie les médias vers un dossier rush, puis les optimise avec un degré par défaut de 50 et en format webp."
    echo -e "  ${ORANGE}optimize ./photo.png --degree 10 --format png${NC}  Optimise l'image spécifiée avec un degré de 10 et en format png."
    echo -e "  ${ORANGE}optimize -l logo.png${NC}  Redimensionne le logo spécifié aux tailles standard."
}

optimize_medias_and_resize() {
    TIMER_START=$(date +%s)
    resize_images "$search_dir" "$degree"
    optimize_images "$search_dir" "$degree" "$format"
    optimize_video "$search_dir" "$degree"
    TIMER_END=$(date +%s)
    TIMER_DIFF=$((TIMER_END - TIMER_START))
    echo -e "\n${VERT}Optimization and resizing completed in ${ORANGE}$TIMER_DIFF seconds${NC}"
}

search_dir="."
degree=50
format="webP"
rush=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--rush)
            rush=true
            ;;
        -d|--degree)
            degree="$2"
            shift
            ;;
        -f|--format)
            format="$2"
            shift
            ;;
        -l|--logo)
            logo="$2"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            search_dir="$1"
            ;;
    esac
    shift
done

if [ "$degree" -lt 0 ] || [ "$degree" -gt 99 ]; then
    echo "Le degré d'optimisation doit être compris entre 0 et 99. Valeur actuelle: $degree."
    echo "Utilisez l'option -h ou --help pour obtenir de l'aide."
    exit 1
fi

if [ -n "$logo" ]; then
    resize_logo "$logo"
    exit 0
fi

if [ "$rush" = true ]; then
    copy_medias_to_rush "$search_dir"
    optimize_medias_and_resize "$dir_rush" "$degree" "$format"
else
    optimize_medias_and_resize "$search_dir" "$degree" "$format"
fi
