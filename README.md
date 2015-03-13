# SpriteMe.sh

Spritemesh (get the pun?) is a bash script that creates a sprite file from a given directory. It
will also create a CSS, SCSS and HTML file so one can view the new sprite directly in the browser. 

This script is the first modification from [Jaymz's
Script](http://jaymz.eu/blog/2010/05/building-css-sprites-with-bash-imagemagick/#codesyntax_1) and
in fact only adding the creation of a SCSS file. 

### Install
Clone this repo to your local machine, place the `spriteme.sh` file in a path of your choice and
then make it executeable and add it to the `PATH`.

```sh
git clone git@github.com:synoa/spriteme.sh.git ~/apps/sh
cd ~/apps/sh
chmod +x spriteme.sh/spriteme.sh
```

Now edit your `bashrc` (or similar) and add the directory to your `PATH` (if it isn't already)

```sh
export PATH="$PATH:$HOME/apps/sh"
```
Make sure to exclude the `$PATH` variable when exporting, otherwise **ONLY** the apps/sh will be in
your `PATH`!

### Usage

Using this script is pretty streight forward. It has 3 parameters as shown below

```sh
# spriteme.sh output_dir classname file_format
# given you are in a folder with images
# skin/frontend/awesome/default/images/brands 

spriteme.sh ../ brands png
```
This will create a brands.png file in `skin/frontend/awesome/default/images` from all PNGs found in
the brands directory. The CSS Class will be `brands`. The CSS then looks like: 

```css
.brands-new-balance {
  background-position: 0 -120px;
  width: 100px;
  heigth: 45px;  
}

.brands-vans {
  background-position: 0 -165px;
  width: 100px;
  height: 45px;  
}
```
For now, the generated SCSS *is not* copied to the correct directory but will stay where it is
created! This is on the to do list of optimizations.

### Using with NPM

Since most projects will either have Grunt or Gulp as task runner, this bash script can be
integrated easily into the workflow. With `npm run` scripts can be run that are pre-defined inside
the `package.json` like so:

```json
...
"scripts": {
    "build": "~~~awesome-build-script~~~",
    "test": "~~~run-test-here~~~"
  }
...
```

These two example commands can then be run with `npm run build` and `npm run test`. Here's how
SpriteMe.sh fits into this.

```json
...
"scripts": {
    "sprite": "cd ./directory/with/png/files && spriteme.sh ../sprite brands png"
  }
...
```

This way a directory called `sprite` is created that holds the CSS, SCSS and HTML from the created
sprite. Important here is that you **must** use go to the directory first! 
