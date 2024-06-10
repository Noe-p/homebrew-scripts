#!/bin/bash

# Fonction pour optimiser les images
optimize_images() {
    local source="$1"
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

