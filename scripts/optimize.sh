#!/bin/bash
BLEU='\033[0;34m'
ORANGE='\033[0;33m'
GRIS_CLAIR='\033[0;37m'
VERT='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # Pas de couleur
ROUGE='\033[0;31m'

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

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done

    printf "    \b\b\b\b\b\b"
}

optimize_images() {
    local source=$1
    local degree=${2:-50}
    local format=${3:-"webP"}
    local quality=$((100 - degree))

    if [ -d "$source" ]; then
        local total_files=0
        local current_file=0

        shopt -s nullglob
        for file in "$source"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webP,WEBP,gif,GIF,bmp,BMP,tiff,TIFF}; do
            if [ -f "$file" ]; then
                total_files=$((total_files + 1))
            fi
        done

        for file in "$source"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webP,WEBP,gif,GIF,bmp,BMP,tiff,TIFF}; do
            if [ -f "$file" ]; then
                echo -ne "Optimizing ${ORANGE}$file${NC}..."
                mogrify -format "$format" -quality "$quality" "$file" &
                spinner $!
                current_file=$((current_file + 1))
                echo "$current_file/$total_files"

                if [ "$(identify -format '%m' "$file" | tr '[:upper:]' '[:lower:]')" != "$(echo "$format" | tr '[:upper:]' '[:lower:]')" ]; then
                    if [ "$(echo "$format" | tr '[:upper:]' '[:lower:]')" != "$(echo "$file" | rev | cut -d'.' -f1 | rev | tr '[:upper:]' '[:lower:]')" ]; then
                        rm "$file"
                    fi
                fi
            fi
        done
    elif [ -f "$source" ]; then
        if [[ $source == *.jpg || $source == *.JPG || $source == *.jpeg || $source == *.JPEG || $source == *.png || $source == *.PNG || $source == *.webP || $source == *.WEBP || $source == *.gif || $source == *.GIF || $source == *.bmp || $source == *.BMP || $source == *.tiff || $source == *.TIFF ]]; then
            echo -e "Optimizing ${ORANGE}$source${NC}..."
            mogrify -format "$format" -quality "$quality" "$source" &
            spinner $!
            if [ "$(identify -format '%m' "$source" | tr '[:upper:]' '[:lower:]')" != "$(echo "$format" | tr '[:upper:]' '[:lower:]')" ]; then
                if [ "$(echo "$format" | tr '[:upper:]' '[:lower:]')" != "$(echo "$source" | rev | cut -d'.' -f1 | rev | tr '[:upper:]' '[:lower:]')" ]; then
                    rm "$source"
                fi
            fi
        fi
    else
        echo -e "${ROUGE}Invalid source: $source${NC}"
    fi
}

resize_images() {
    local source=$1
    local degree=${2:-50}

    if [ -d "$source" ]; then
        local total_files=0
        local current_file=0

        shopt -s nullglob
        for file in "$source"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webP,WEBP,gif,GIF,bmp,BMP,tiff,TIFF}; do
            if [ -f "$file" ]; then
                total_files=$((total_files + 1))
            fi
        done

        for file in "$source"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webP,WEBP,gif,GIF,bmp,BMP,tiff,TIFF}; do
            if [ -f "$file" ]; then
                echo -ne "Resizing ${ORANGE}$file${NC}..."

                if [ "$degree" -gt 0 ]; then
                    local resize_factor=$((100 - degree))
                    mogrify -resize "${resize_factor}%" "$file" &
                    spinner $!
                fi

                if [ "$degree" -eq 100 ]; then
                    convert "$file" -define webP:extent=500kb "$file" &
                    spinner $!
                fi

                current_file=$((current_file + 1))
                echo "$current_file/$total_files"
            fi
        done
    elif [ -f "$source" ]; then
        if [[ $source == *.jpg || $source == *.JPG || $source == *.jpeg || $source == *.JPEG || $source == *.png || $source == *.PNG || $source == *.webP || $source == *.WEBP || $source == *.gif || $source == *.GIF || $source == *.bmp || $source == *.BMP || $source == *.tiff || $source == *.TIFF ]]; then
            echo -e "Resizing ${ORANGE}$source${NC}..."

            if [ "$degree" -gt 0 ]; then
                local resize_factor=$((100 - degree))
                mogrify -resize "${resize_factor}%" "$source" &
                spinner $!
            fi

            if [ "$degree" -eq 100 ]; then
                convert "$source" -define webP:extent=500kb "$source" &
                spinner $!
            fi
        fi
    else
        echo -e "${ROUGE}Invalid source: $source${NC}"
    fi
}

optimize_video() {
    local source=$1
    local degree=${2:-50}
    local min_crf=0
    local max_crf=51

    local quality=$(awk "BEGIN {print int($min_crf + ($degree / 99) * ($max_crf - $min_crf))}")

    local preset="medium"
    local audio_bitrate="128k"

    optimize_file() {
        local file=$1
        local temp_file="${file%.*}_temp.mp4"
        echo -ne "Optimizing vidéo ${ORANGE}$file${NC}..."
        ffmpeg -i "$file" -vcodec libx264 -crf "$quality" -preset "$preset" -acodec aac -b:a "$audio_bitrate" -movflags +faststart -y "$temp_file" > /dev/null 2>&1 &
        spinner $!
        
        if [ $? -eq 0 ]; then
            mv "$temp_file" "$file"
        fi
    }

    if [ -d "$source" ]; then
        local total_files=0
        local current_file=0

        shopt -s nullglob
        for file in "$source"/*.{mp4,MP4,avi,AVI,mov,MOV,mkv,MKV,flv,FLV,wmv,WMV,webm,WEBM}; do
            if [ -f "$file" ];then
                total_files=$((total_files + 1))
            fi
        done

        for file in "$source"/*.{mp4,MP4,avi,AVI,mov,MOV,mkv,MKV,flv,FLV,wmv,WMV,webm,WEBM}; do
            if [ -f "$file" ]; then
                optimize_file "$file"
                current_file=$((current_file + 1))
                echo "$current_file/$total_files"
            fi
        done

    elif [ -f "$source" ]; then
        if [[ $source == *.mp4 || $source == *.MP4 || $source == *.avi || $source == *.AVI || $source == *.mov || $source == *.MOV || $source == *.mkv || $source == *.MKV || $source == *.flv || $source == *.FLV || $source == *.wmv || $source == *.WMV || $source == *.webm || $source == *.WEBM ]]; then
            optimize_file "$source"
        fi
    else
        echo -e "${ROUGE}Invalid source: $source${NC}"
    fi
}

copy_medias_to_rush() {
    shopt -s nullglob

    if [ -d "$search_dir" ]; then
        files=("$search_dir"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webP,WEBP,gif,GIF,bmp,BMP,tiff,TIFF,mp4,MP4,avi,AVI,mov,MOV,mkv,MKV,flv,FLV,wmv,WMV,webm,WEBM})

        if [ ${#files[@]} -gt 0 ]; then
            parent_dir=$(dirname "$search_dir")
            rush_dir="$parent_dir/rush_$(date '+%d-%m-%Y_%H-%M-%S')"
            mkdir -p "$rush_dir"
            cp -n "${files[@]}" "$rush_dir/"
            echo -e "${VERT}Files copied to ${ORANGE}$rush_dir${NC}"
        else
            echo -e "${ROUGE}No media files found in $search_dir${NC}"
        fi
    elif [ -f "$search_dir" ]; then
        source_filename=$(basename "$search_dir")
        parent_dir=$(dirname "$search_dir")
        rush_dir="$parent_dir/rush_$(date '+%d-%m-%Y_%H-%M-%S')"
        mkdir -p "$rush_dir"
        cp -n "$search_dir" "$rush_dir/"
        echo -e "${VERT}File copied to ${ORANGE}$rush_dir${NC}"
    else
        echo -e "${ROUGE}Invalid source: $search_dir${NC}"
    fi
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

resize_logo() {
    local logo="$1"
    local sizes=(512 384 192 152 144 128 96 72 48)

    if [ ! -d "logos" ]; then
        mkdir logos
    fi

    TIMER_START=$(date +%s)

    for size in "${sizes[@]}"; do
        echo -ne "Resizing logo to ${ORANGE}${size}x${size}${NC} ..."
        convert "$logo" -resize "${size}x${size}" "logos/logo_${size}x${size}.png" &
        spinner $!
        cwebp "logos/logo_${size}x${size}.png" -o "logos/logo_${size}x${size}.webp" > /dev/null 2>&1 &
        spinner $!
        rm "logos/logo_${size}x${size}.png"
        echo -e " ${VERT}Done${NC}"
    done

    TIMER_END=$(date +%s)
    TIMER_DIFF=$((TIMER_END - TIMER_START))
    echo -e "\n${VERT}Optimization and resizing completed in ${ORANGE}$TIMER_DIFF seconds${NC}"
}


search_dir="."
degree=50
format="webP"
dir_rush="$search_dir/rush_$(date '+%d-%m-%Y_%H-%M-%S')"

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
    copy_medias_to_rush
    optimize_medias_and_resize "$dir_rush"
else
    optimize_medias_and_resize "$search_dir"
fi