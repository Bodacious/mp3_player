# This plugin is based on the Audio Player Worpress Plugin by Martin Laine
# http://www.1pixelout.net/code/audio-player-wordpress-plugin/
module Mp3Player
  
  # This module contains the view helper <tt>mp3_player</tt>
  module ViewHelper
    # This is the path to the folder that mp3_player expects your .mp3 files to be kept. Defaults to "/audio"
    AUDIO_PATH = "/audio"

    # These are the names of the colour params you can set to style the mp3_player
    # (all colours should be expressed as 6 figure hex values minus the '#')
    # * :bg => background colour, defaults to "BBBBBB"
    # * :left_bg => background color of the left tab, defaults to "AAAAAA"
    # * :right_bg => background colour of the right tab, defaults to "AAAAAA"
    # * :right_bg_hover => colour of the right background as the cursor hovers over, defaults to "EEEEEE"
    # * :left_icon => the color of the speaker icon on the left, defaults to "222222"
    # * :right_icon => colour of the play/pause icon on the right, defaults to "222222"
    # * :right_icon_hover => colour of the play/pause icon as the cursor hovers over, defaults to "222222"
    # * :text => colour of the text, defaults to "222222"
    # * :slider => colour of the slider bar, defaults to "333333"
    # * :loader => colour of the loaded data so far, defaults to "DDDFFF"
    # * :track => colour of the track on the slider, defaults to "888888"
    # * :border => colour of the buffer border, defaults to "333333"  
    COLOR_PARAMS = [:bg, :left_bg, :right_bg, :right_bg_hover, :left_icon, :right_icon, :right_icon_hover, :text, :slider, :loader, :track, :border]

    # These options are boolean values that should be converted to "yes" or "no" for the flash object
    # * :autostart => should the track start playing on page load? defaults to false
    # * :loop => should the track loop continuously? defaults to false
    BOOLEAN_PARAMS = [:autostart, :loop]

    # * :width => width of the player when open in pixels, defaults to 290
    # * :id => id of the div wrapping the player, defaults to "#{track_name}_player"
    # * :class => class of the div wrapping the player, defaults to "mp3_player"
  	OTHER_PARAMS = [:width, :class, :id]




    # This is the helper method you'll call in the view. <b><%= mp3_player "Pulling The Plug On The Party" %></b>
    # See the options above for more info on customising the player to match your site
    def mp3_player(track_name, options = {})
      BOOLEAN_PARAMS.map {|k| options[k] == true ? options[k] = "yes" : options[k] = "no"}
      options.reverse_merge!(:id => "#{track_name.split(" ").join("_")}_player", :class => "mp3_player", :width => 290,:text => "222222", :bg => "bbbbbb", 
      											:left_bg => "AAAAAA", :right_bg => "AAAAAA", :right_bg_hover => "EEEEEE", 
      											:left_icon => "222222", :right_icon => "222222", :right_icon_hover => "555555", 
      											:slider => "333333", :loader => "DDDFFF", :track => "888888",:border => "333333")
      options.assert_valid_keys(COLOR_PARAMS + BOOLEAN_PARAMS + OTHER_PARAMS)
      concat "\n"
      concat "<div id=\"#{options[:id]}\" class=\"#{options[:class]}\">\n"
      concat "  <object type=\"application/x-shockwave-flash\" data=\"/player.swf\" height=\"24\" width=\"" + options[:width].to_s + "\">\n"
      concat "    <param name=\"movie\" value=\"/player.swf\" />\n"
      params = ""
      OTHER_PARAMS.map {|k| options.delete(k) }
      COLOR_PARAMS.map { |k| options[k] = "0x#{options[k]}"}
      options.each {|k,v| params << "#{k.to_s.gsub("_", "")}=#{v.to_s}&amp;"}
    	concat "    <param name=\"FlashVars\" value=\"#{params}playerID=#{track_name}&amp;soundFile=#{AUDIO_PATH}/" + track_name + ".mp3\" />\n"
      concat "    <param name=\"quality\" value=\"high\" />\n"
      concat "    <param name=\"menu\" value=\"true\" />\n"
    	concat "    <param name=\"wmode\" value=\"transparent\" />\n"
    	concat "  </object>\n"
    	concat "</div>\n"
      nil
    end
  end
  
  # These methods are used to set up your application with the required .js and .swf files
  # Mp3Player::Setup.setup is called from rake mp3_player
  module Setup
    
    
    # This method is called from the rake task <b>rake mp3_player</b>.
    # It's used to copy files to your <em>public/</em> directory
    def self.setup
      create_audio_file
      copy_test_mp3_file
      copy_js_file # not used atm
      copy_swf_file
    end
    
    protected
    
    # creates the audio folder where mp3 files should be stored
    def self.create_audio_file
      if File.exist?("#{RAILS_ROOT}/public/audio")
        puts "exists public/audio/"
      else
        Dir.chdir("#{RAILS_ROOT}/public/") do
          Dir.mkdir("audio")
        end
        puts "create public/audio/"
      end
    end
    
    # copies an mp3 file to <em>public/audio/</em> which you can use to test the player
    def self.copy_test_mp3_file
      unless File.exist?("#{RAILS_ROOT}/public/audio/test.mp3")
        File.open("#{RAILS_ROOT}/public/audio/test.mp3", "wb") { |file| file.write(File.read("#{File.dirname(__FILE__)}/../extras/test.mp3")) }
        puts "create public/audio/test.mp3"
      else
        puts "exists public/audio/test.mp3"
      end
    end
    
    # :stopdoc:
    # this js.file is not neccessary
    # copies the neccessary javascript file to the javasripts folder
    def self.copy_js_file
      unless File.exist? "#{RAILS_ROOT}/public/javascripts/audio_player.js"
        File.open("#{RAILS_ROOT}/public/javascripts/audio_player.js", "wb") { |file| file.write(File.read("#{File.dirname(__FILE__)}/../extras/audio-player.js")) }
        puts "create public/javascripts/audio_player.js"
      else
        puts "exists public/javascripts/audio_player.js"
      end
    end
    # :startdoc:
    
    # copies the neccessary shock-wave file to the public folder
    def self.copy_swf_file
      unless File.exist? "#{RAILS_ROOT}/public/player.swf"
        File.open("#{RAILS_ROOT}/public/player.swf", "w") { |file| file.write(File.read("#{File.dirname(__FILE__)}/../extras/player.swf")) }
        puts "create public/player.swf"
      else
        puts "exists public/player.swf"
      end
    end
  end
  
  
end
