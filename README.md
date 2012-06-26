# jekyll-yui-css

Takes (potentially) multiple CSS files from a directory, compresses them with [YUI Compressor](http://developer.yahoo.com/yui/compressor/), and outputs a single CSS file each time your site is generated with Jekyll.

## Installation

### Dependencies

* [jekyll](https://github.com/mojombo/jekyll) `gem install jekyll`
* [ruby-yui-compressor](https://github.com/sstephenson/ruby-yui-compressor) `gem install yui-compressor`

Note: YUI Compressor requires Java. On Ubuntu, you can install this with `sudo apt-get install openjdk-7-jre-headless`.

### Instructions

1. Copy `yui_css.rb` to the `_plugins` directory of your Jekyll project.
2. Follow configuration instructions below.
3. Run `jekyll` to generate your site. If everything worked, you should see a line in the terminal like this:

    Compressing CSS with YUI... Done! Outputted to: ./_site/assets/style.css

## Configuration

jekyll-yui-css accepts two configuration parameters in the standard Jekyll `_config.yml` file:

* `css_source_dir` is the path to the directory in which the original CSS files are contained, relative to `source`. Defaults to `css`.
* `css_output_file` is the path to the file in which to save the compressed CSS, relative to `destination`. Should have a leading slash and end in `.css`. Defaults to `/css/style.css`.

You _must_ list your CSS files in Jekyll's `exclude` configuration parameter. If you don't, if the source and output filenames are the same, Jekyll will not save the compressed file or, if the filenames are different, Jekyll will make the original, uncompressed files available in the `destination` directory (in addition to the compressed one).

(Note: You may specify the _directory_ in which the CSS files are in for the `exclude` setting in `_config.yml`, but you should only do this if the directory only contains CSS, otherwise the other files will not be carried over to the `destination`.)

As an example, consider this project structure:

    _layouts/
    _plugins/
      yui_css.rb
    _posts/
    _site/
    assets/
      footer.png
      header.png
      special.css
      style.css
    _config.yml
    index.html

and this `_config.yml`:

    # ...
    source:      .
    exclude:     special.css, style.css
    destination: ./_site
    plugins:     ./_plugins

    css_source_dir:  assets
    css_output_file: /assets/style.css
    # ...

with a layout including:

    <link href="/assets/style.css" rel="stylesheet" type="text/css">

In this case, `assets/special.css` and `assets/style.css` would be minified, combined, and outputted to `_site/assets/style.css`, which would then be included in the layout file via the `<link>` tag.

If you have any questions/problems, please let me know!

## Notes

I wrote this because I wasn't satisfied with the approached used by [jekyll-cssminify](https://github.com/donaldducky/jekyll-cssminify). If you're wondering what's different, jekyll-yui-css:

* allows the user to customize the filename of the output file,
* does not require a custom liquid tag in your layout,
* includes safety measures to prevent overwriting the source CSS files,
* uses YUI Compressor via the Ruby wrapper instead of [juicer](https://github.com/cjohansen/juicer) through the command line, and
* utilizes the standard Jekyll `_config.yml` file instead of a custom one.
