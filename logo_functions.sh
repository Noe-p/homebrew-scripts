#!/bin/bash

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
