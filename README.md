# Optimize Script README

## Introduction

The `optimize` script is designed to optimize and resize images and videos within a specified folder or file. It provides several options to customize the optimization process, including the ability to copy media to a separate folder before processing, setting the degree of optimization, and selecting the output format.

## Installation

```sh
brew tap Noe-p/optimize
brew install optimize
```

## Utilisation

```sh
optimize [DOSSIER|FICHIER] [OPTIONS]
```

Optimizes and resizes images and videos in the specified **FOLDER** or **FILE**.

### Options

- `-r, --rush`  
  Copies the media to a "rush" folder before optimizing and resizing.

- `-d, --degree` DEGREE  
  Sets the degree of optimization from 0 to 99. The default is 50.

- `-f, --format` FORMAT  
  Chooses the output format (png, jpg, webp). The default is webp.

- `-l, --logo` LOGO  
  Resizes a logo to standard sizes (512, 384, 192, etc.).

- `-h, --help`  
  Displays this help message and exits.

## Exemples

- `optimize .`  
  Optimizes media in the current folder with a default degree of 50 and in webp format.

- `optimize ./photo.png`  
  Optimizes the specified image with a default degree of 50 and in webp format.

- `optimize . -d 80`  
  Optimizes media in the current folder with a degree of 80 and in webp format.

- `optimize . -r`  
  Copies the media to a "rush" folder, then optimizes with a default degree of 50 and in webp format.

- `optimize ./photo.png --degree 10 --format png`  
  Optimizes the specified image with a degree of 10 and in png format.

- `optimize -l logo.png`  
  Resizes the specified logo to standard sizes.

## Notes

- Ensure that you have the necessary dependencies installed for the script to run, such as `mogrify` and `convert` (part of the ImageMagick suite).
- The script supports various image formats including jpg, jpeg, png, webp, gif, bmp, and tiff.
- The degree of optimization determines the quality and size reduction, with 0 being the least optimized (highest quality) and 99 being the most optimized (lowest quality).

## Installation

To use this script, ensure it is executable and sourced properly:

```sh
chmod +x optimize.sh
```

Then, run the script using the `optimize` command as described above.

For any questions or further assistance, please refer to the script comments and documentation or contact the author.
