# :nodoc:
class Mp3PlayerGenerator < Rails::Generator::Base
  
  attr_accessor :audio_dirname
  
  def initialize(runtime_args, runtime_options = {})
    # specify the name of the audio directory
    filename = runtime_args.split(/\s+/).first
    filename.chop! if filename.last == "/"
    self.audio_dirname = filename.blank? ? "audio" : filename
    super
  end
  
  def manifest
    record do |m|
      m.directory('public')
      m.file('player.swf', 'public/player.swf')
      m.directory("public/#{audio_dirname}")
      m.file("test.mp3", "public/#{audio_dirname}/test.mp3")
    end
  end
  
  def usage_message
    "to generate files for mp3_player use script/generate mp3_player [audio_file_name]
     eg. - script/generate mp3_player my_mp3s # => creates public/my_mp3s"
  end
end