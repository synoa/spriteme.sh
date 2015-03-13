#!/bin/bash
 
# uses imagemagick to stich together all images in a folder and
# then writes a css file with the correct offsets along with a
# test html page for verification that its all good

# Script taken from
# http://jaymz.eu/blog/2010/05/building-css-sprites-with-bash-imagemagick/#codesyntax_1
# Originally by jaymz.

# Modified for use with auto-creating
# a Sass file 2015 by Kevin Gimbel <kevingimbel.com>
# You'll find a lot of " >> $css >> $scss" calls that
# write the contents to both files.
#
# Additional comments added by Kevin Gimbel


if [ $# -gt 0 ]
then
 
    if [ $3 ]
    then
        ext="."$3; # the extension to iterate over for input files
    else
        ext=".gif"; # the extension to iterate over for input files
    fi
 
    name=$1; # output will be placed in a folder named this
 
    if [ $2 ]
    then
        classname=$2;
    else
        classname=$1;
    fi
    # creating the files (sass, css and test page)
    scss="$name/_$classname.scss";
    css="$name/test.css"
    html="$name/test.html";
 
    # re-creating the folders if they exists
    rm -fr $name;
    mkdir $name;
    touch $css $scss $html;
 
    echo "Generating sprite file...";
    # here ImageMagick creates the sprite 
    convert *$ext -append $name/$classname$ext;
    echo "Sprite complete! - Creating css & test output...";
    
    # The Testpage is constructed 
    echo -e "<html>\n<head>\n\t<link rel=\"stylesheet\" href=\"`basename $css`\" />\n</head>\n<body>\n\t<h1>Sprite test page</h1>\n" >> $html
    
    # the initial class for all sprites is create, usage example class="sprite sprite-icon"
    echo -e ".$classname {\n\tbackground:url('$classname$ext') no-repeat top left;
    display:inline-block;\n}" >> $css >> $scss;
    counter=0;
    offset=0;
    for file in *$ext
    do
        width=`identify -format "%[fx:w]" "$file"`;
        height=`identify -format "%[fx:h]" "$file"`;
        idname=`basename "$file" $ext`;
        clean=${idname// /-}
        echo ".$classname-$clean {" >> $css >> $scss;
        echo -e "\tbackground-position:0 -${offset}px;" >> $css >> $scss;
        echo -e "\twidth: ${width}px;" >> $css >> $scss;
        echo -e "\theight: ${height}px;\n}" >> $css >> $scss;
 
        echo -e "<a href=\"#\" class=\"$classname $classname-$clean\" id=\"$clean\"></a>\n" >> $html;
 
        let offset+=$height;
        let counter+=1;
        echo -e "\t#$counter done";
    done
     
    echo -e "<h2>Full sprite:</h2>\n<img src=\"$classname$ext\" />" >> $html;
    echo -e "</body>\n</html>" >> $html;
 
    echo -e "\nComplete! - $counter sprites created, css written & test page output. ~jaymz";
 
else
 
    echo -e "There should be at least 1 argument!\n\tspriteme.sh output_folder classname input_extension"
 
fi
