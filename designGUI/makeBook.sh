#!/bin/bash

htmlDest="html"
infoDest="info"
docbookDest="docbook"
masterDoc="DesignGUI.texinfo"
chapNumbers="01 02 03 04 05 06 07 50"

function collateChaptersImg {
    chapters=""
    for n in $chapNumbers
    do
	chapters="$chapters chapter-$n"
    done	     

    imgPath="./misc"
    for chapter in $chapters
    do
	imgPath="$imgPath:./$chapter/img"
    done
}

function doPdf {
    makeinfo -I $imgPath --pdf $masterDoc
    cd -
    clean_all
}

function doDocbook {
    cleanupDestination $docbookDest
    texi2any --output=$docbookDest/ --transliterate-file-names --split=node \
	     --no-number-sections --docbook $masterDoc 
}

function doInfo {
    prepareDestination $infoDest
    makeinfo -I $imgPath --output=$infoDest/ $masterDoc
}

function doHtml {
    prepareDestination $htmlDest
    cp misc/style.css $htmlDest
#    texi2any --no-validate -I $imgPath --output=$htmlDest/ --html --css-ref=style.css $masterDoc
    texi2any -c ICONS=true -I $imgPath --output=$htmlDest/ --html -c FORMAT_MENU=menu \
	     -c CONTENTS_OUTPUT_LOCATION=inline --css-ref=style.css  $masterDoc 
}

function cleanupDestination {
    # Clean up dest $1
    rm -rf "$1"
    mkdir "$1"
}
function prepareDestination {
    # Clean up dest $1 and copy all bitmaps there
    cleanupDestination "$1"
    for dir in $chapters
    do
	if [ -d $dir/img ]; then
	    cp $dir/img/*.png "$1" 2> /dev/null
   	    cp $dir/img/*.jpg "$1" 2> /dev/null
       	    cp $dir/img/*.gif "$1" 2> /dev/null
	fi
    done
    cp ./misc/*.png "$1" 2> /dev/null
    cp ./misc/*.jpg "$1" 2> /dev/null
    cp ./misc/*.gif "$1" 2> /dev/null
}

function package_html {
    doHtml
    tar cfz `basename $masterDoc .texinfo`-html.tgz html
}

function clean_all {
    rm   *.log *.toc  *.aux  *.cp *.cps *.fn *.ky *.tp *.vr *.fns *.pg
}

function usage {
    echo "Usage: $0 (docbook|html|pdf|package|clean)"
}

collateChaptersImg

case "$1" in 
    docbook)
	echo "Build documentation in docbook."
	doDocbook
	;;
    html) 
	echo 'Build documentation in html.'
	doHtml
	;;
    pdf)
	echo 'Build documentation in PDF.'
	doPdf
	;;
    info)
	echo 'Build documentation for Texinfo.'
	doInfo
	;;
    package)
	echo 'Build html documentation and archive it.'
	doHtml
	package_html
	;;
    clean)
	echo "Delete all the intermediate files."
	clean_all
	;;
    *)
	usage
	exit
esac
