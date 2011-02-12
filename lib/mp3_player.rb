module Mp3Player

  require "uri"
  
  # This module contains the view helper <tt>mp3_player</tt>
  module ViewHelper
    
    DEFAULT_OPTIONS = {
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
      # These options are boolean values that should be converted to "yes" or "no" for the flash object
      # * :autostart => should the track start playing on page load?
      # * :loop => should the track loop continuously?
      # * :animation => should the mp3 player open when clicked?
      # * :noinfo => should the track name be displayed?
      :autostart => false, 
      :loop      => false,
      :animation => true,
      :noinfo    => true,
      :remaining => false,
      :buffer    => 5,
      # * :width => width of the player when open in pixels
      # * :class => class of the div wrapping the player
      :width => 290, 
      :class => "mp3_player",
      :initialvolume => 60,
    }

    # This is the helper method you'll call in the view. <tt><%= mp3_player @song.mp3.url %></tt>
    # See the options above for more info on customising the player to match your site
    def mp3_player(path_to_file, options = {}) 
      increment_player_count     

      # apply default options
      options = options.reverse_merge(DEFAULT_OPTIONS)

      # ensure options are valid?
      options.assert_valid_keys(DEFAULT_OPTIONS.keys)

      # clean up options...
      options.each do |key, value|
        case value
        
        # convert booleans to 'yes'/'no'          
        when true
          options[key] = "yes"
        when false
          options[key] = "no"
          
        # add '0x' to colors and add color params          
        when /[A-Za-z0-9]{6}/
          options[key] = "0x#{value}"
        end
      end

      # add the soundFile param
      options[:soundFile] = path_to_file
      options.delete(:class)
      # turn the whole thing into a meaty string
      output = <<-HTML
        <div class=\"#{options[:class]}\" id=\"mp3_player_#{player_count}\">
          <object type="application/x-shockwave-flash" data="/player.swf" height="24" width=\"#{options[:width]}\">
            <param name="movie" value="/player.swf" />
            <param name="FlashVars" value="#{options.to_param}" />
            <param name="quality" value="high" />
            <param name="menu" value="true" />
            <param name="wmode" value="transparent" />
          </object>
        </div>
      HTML
      output.try(:html_safe) # => your awesome mp3_player
    end
  
    module_function :mp3_player


    def increment_player_count
      @player_count ||= 0
      @player_count += 1
    end
    
    attr_reader :player_count
  end

end