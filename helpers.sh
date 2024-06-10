#!/bin/bash

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

copy_medias_to_rush() {
    local search_dir="$1"
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
