require "uri"
module Mp3Player
  
  # This module contains the view helper <tt>mp3_player</tt>
  module ViewHelper

    # These are the names of the colour params you can set to style the mp3_player
    # (all colours should be expressed as 6 figure hex values minus the '#')
    # * :bg => background colour
    # * :left_bg => background color of the left tab
    # * :right_bg => background colour of the right tab
    # * :right_bg_hover => colour of the right background as the cursor hovers over
    # * :left_icon => the color of the speaker icon on the left
    # * :right_icon => colour of the play/pause icon on the right
    # * :right_icon_hover => colour of the play/pause icon as the cursor hovers over
    # * :text => colour of the text
    # * :slider => colour of the slider bar
    # * :loader => colour of the loaded data so far
    # * :track => colour of the track on the slider
    # * :border => colour of the buffer border
    COLOR_OPTIONS = {
      :bg               => "BBBBBB", 
      :left_bg          => "AAAAAA", 
      :right_bg         => "AAAAAA", 
      :right_bg_hover   => "EEEEEE", 
      :left_icon        => "222222", 
      :right_icon       => "222222", 
      :right_icon_hover => "222222", 
      :text             => "222222", 
      :slider           => "333333", 
      :loader           => "DDDFFF", 
      :track            => "888888", 
      :border           => "333333",
    }

    # These options are boolean values that should be converted to "yes" or "no" for the flash object
    # * :autostart => should the track start playing on page load?
    # * :loop => should the track loop continuously?
    # * :animation => should the mp3 player open when clicked?
    BOOLEAN_OPTIONS = {
      :autostart => false, 
      :loop      => false,
      :animation => true, # TODO - get this to work?! 
    }

    # * :width => width of the player when open in pixels
    # * :id => id of the div wrapping the player
    # * :class => class of the div wrapping the player
    OTHER_OPTIONS = {
      :width => 290, 
      :class => "mp3_player",
      :id    => nil,
    }

    # This is the helper method you'll call in the view. <tt><%= mp3_player @song.mp3.url %></tt>
    # See the options above for more info on customising the player to match your site
    def mp3_player(path_to_file, options = {})
      # convert booleans to 'yes'/'no'
      BOOLEAN_OPTIONS.each {|key, value| options[value] == true ? options[key] = "yes" : options[key] = "no"}

      # set defaults
      default_options = COLOR_OPTIONS.merge(BOOLEAN_OPTIONS.merge(OTHER_OPTIONS))
      options.reverse_merge! default_options

      # ensure options are valid
      options.assert_valid_keys(default_options.keys)

      # extract color options
      color_options   = options.select {|key,value| COLOR_OPTIONS.include?(key) }

      # extract boolean options
      boolean_options = options.select {|key,value| BOOLEAN_OPTIONS.include?(key) }

      # add '0x' to colors and add color params
      flash_vars = color_options.collect {|key, value| "#{key.to_s.gsub("_", "")}=0x#{value}" }

      # add boolean params
      flash_vars += boolean_options.collect {|key,value| "#{key}=#{value}" }

      # add the soundFile param
      flash_vars << "soundFile=#{path_to_file}"

      # join params with an ampersand
      flash_vars = flash_vars.join("&amp;").to_s

      # turn the whole thing into a meaty string
      output = <<-HTML
        <div class=\"#{options[:class]}\"#{ " id=\"#{options[:id]}\"" if options[:id]}>
          <object type="application/x-shockwave-flash" data="/player.swf" height="24" width=\"#{options[:width]}\">
            <param name="movie" value="/player.swf" />
            <param name="FlashVars" value="#{URI.escape flash_vars}" />
            <param name="quality" value="high" />
            <param name="menu" value="true" />
            <param name="wmode" value="transparent" />
          </object>
        </div>
      HTML
      output # => your awesome mp3_player
    end
  
    module_function :mp3_player
    
  end

end