#!/bin/bash

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
