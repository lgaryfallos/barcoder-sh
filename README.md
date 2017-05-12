# Barcoder

Barcoder is a bash script that creates barcodes out of movie files.

# What is a Movie Barcode

  - You take a frame from the movie every X seconds
  - You squash them to Y pixels wide
  - You lay them side by side
  - Then you squash them to 1 pixel height and back to your required height to get the frames avarage color
  - The result is a smooth barcode-like image that shows the average colors of most scenes in a movie
  - Kinda like a movie fingerprint
  
# Requirements

  - Imagemagick
  - ffmpeg

*(Only tested on OSX El Capitan and Sierra, but should work on any bash console with imagemagick and ffmpeg, it's pretty straighforward)*

### Usage

It's simple.
Make the script executable, and run it on the movie (in a folder preferrably since we will be creating subfolders) with your desired parameters.

Arguments:

 - -f filename : *The video to parse (required)*
 - -i XX : *interval for snapshots (default 4 seconds)*
 - -H XX : *height of output in pixels (default 1080)*
 - -s XX : *width of slice in pixels (default 1)*
 - -p : *If set preserves frames and slices which are otherwise deleted*
 - -o : *Set output prefix (default: barcode)*
 - -h : *Prints a semihelpful help message*

### Example

*Snap every 90 seconds with a slice width of 3 pixels*
```sh
$ cd movie_directory
$ /path/to/barcoder.sh -f moviename.avi -i 90 -s 3
```
*Snap every 2 seconds, and preserve intermediate files
```sh
$ cd movie_directory
$ /path/to/barcoder.sh -f videofile.mkv -i 2 -p
```

*Custom output fileprefix
```sh
$ cd movie_directory
$ /path/to/barcoder.sh -f videofile.mkv -o mymoviebarcode
```
*(will create mymoviebarcode_raw.png and mymoviebarcode_smooth.png instead of barcode_raw and _smooth)*

The script will create 2 folders "narrow" and "frames" where the slices and the full frames will be stored respectively. These are deleted (so make sure you do this in a clean folder to avoid unpleasant surprises) unless you specify the -p option to preserve them.

The barcode will be barcode_raw.png for the unsmoothed version and barcode_smooth.png for the smooth version (which has been squashed and resized again).



### Todo

 - Give option to define dimensions and derive interval from dimensions and slice width
 - Give option to define dimensions, grab movie length and derive interval or slice width

License
----
I don't think it's needed, but in any case, do whatever you want with it, so 
**MIT**

I made this for my very talented cinematographer friend [Yiannis Manolopoulos](http://www.yiannismanolopoulos.com/).

We started with the montage of the images, and then I thought, this should be really easy to automate. And as it turns out, it was :)

**Free Software, Hell Yeah!**

