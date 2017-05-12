#!/bin/bash
##############################################################################
# extract frames from movie $1 every $2 seconds
# resize them to $3 pixels wide
# montage them side by side - save as barcode_raw.png
# resize 1px height, then resize to 1080 again and save as barcode_smooth.png
##############################################################################
# Author: leonidas@mokaal.com
# Version: 0.3 11-05-2017
##############################################################################

#init default variables
width=2400
height=1080
slice=1
interval=4
file=''
preserve=false


if [ $# -lt 1 ]
	then
	echo ""
	echo "Usage: barcoder.sh {-f path/to/filename} [-i grab_frame_every_seconds] [-s frame_resize_width] [-H output_height_pixels] [-p]"
	echo ""
	exit 1;
fi
echo " "
while getopts "f:i:s:w:H:ph" flag ; do
  case "$flag" in
  	f) 
		echo "* File is $OPTARG"
		file="${OPTARG}" 
		;; 
    i) 
		echo "* Setting Interval to $OPTARG seconds"
		interval="${OPTARG}" 
		;;
    s) 
		echo "* Slice width is $OPTARG pixels"
		slice="${OPTARG}" 
		;;
    w) 
		echo "* Image width is $OPTARG pixels" #not used currently
		width="${OPTARG}" 
		;;
    H) 
		echo "* Image height is $OPTARG pixels"
		height="${OPTARG}" 
		;;
	p)  
		echo "* Preserving intermediate files"
		preserve=true
		;;
	h) 
		echo "BARCODER ::: Creates 'barcode' like images from movie files."
		echo "Usage: barcoder.sh -f filename [-h] [-H height_in_pixels] [-s slice_width_pixels] [-i screenshot_interval_seconds] [-p]"
		echo " -p : Preserves still frames and narrow resized frames."
		echo " -h : Prints this message and exits. "
		echo ""
		echo " If only -f is set (which is required), the defaults are:"
		echo " > Screenshot every 4 seconds, "
		echo " > 1080 pixels height "
		echo " > 1 pixel slice width. "
		echo " > Intermediate images are deleted by default."
		echo ""
		echo " Width depends on video file duration vs interval and slice width. "
		echo ""
		exit 1;
		;;
    *) error "Unexpected option ${flag}" ;;
  esac
  
done

shift $(( OPTIND - 1 ))

echo "...."
echo "Options set and starting"
echo "...."

echo "Extracting frames every $interval seconds..."
mkdir frames
mkdir narrow
ffmpeg -i $file -loglevel -8 -vf fps=1/"$interval" frames/frame%05d.jpg
cd frames
echo "Resizing to $slice pixels wide..."
mogrify -resize "$slice"x$height! -quality 100 -path ../narrow *.jpg
cd ../narrow
echo "Stitching side by side..."
convert +append *.jpg ../barcode_raw.png
#montage -geometry +0+0 -tile x1 *.jpg ../barcode_raw2.png
cd ..
echo "Squashing barcode to smooth it out..."
convert barcode_raw.png -geometry x1! temp.png

echo "Resizing to 1080 height..."
convert temp.png -geometry x$height! barcode_smooth.png

echo "Removing temp file..."
rm temp.png
if !($preserve); then
	echo "Deleting intermediate files..."
	rm -rf narrow
	rm -rf frames
fi

echo "Your barcodes are ready. "
echo "barcode_raw.png is the original and barcode_smooth.png is... smooooth!"
