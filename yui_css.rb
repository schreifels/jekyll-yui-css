require 'yui/compressor'
require 'pathname'
require 'fileutils'

module Jekyll
  # Prevent Jekyll from deleting the file after generation
  # (see https://gist.github.com/920651)
  class YuiCssFile < StaticFile
    def write(dest)
      # do nothing
    end
  end

  class YuiCssGenerator < Generator
    safe true

    def generate(site)
      print 'Compressing CSS with YUI...'

      # Setup config
      source     = site.config['css_source_dir']  || 'css'
      output_rel = site.config['css_output_file'] || '/css/style.css' # relative to destination
      output     = site.config['destination'] + output_rel

      # Get uncompressed CSS
      uncompressed = ''
      Dir["#{source}/*.css"].each do |path|
        begin
          # Don't accidentally overwrite the source file (like I did)
          if Pathname.new(path).realpath == Pathname.new(output).realpath
            raise 'Your output CSS file matches one of the source files. Please edit css_output_file in _config.yml to change this.'
          end
        rescue Errno::ENOENT
          # Pathname will raise an exception if the path doesn't exist. We'll
          # ignore it since the output path may not (yet) exist.
        end

        uncompressed += File.open(path, 'r').read
      end

      # Compress the CSS
      compressor = YUI::CssCompressor.new
      compressed = compressor.compress(uncompressed)

      # Create output dir if necessary
      FileUtils.mkdir_p(File.dirname(output))

      # Write to output file
      File.open(output, 'w') do |f|
        f.write(compressed)
      end

      puts ' Done! Outputted to: ' + output

      # Make sure our file doesn't get removed
      # (args: site, site.source, relative_dir, filename)
      site.static_files << YuiCssFile.new(site, site.source, File.dirname(output_rel), File.basename(output))
    end
  end
end
