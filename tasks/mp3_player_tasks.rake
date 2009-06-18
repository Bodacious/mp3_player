require 'fileutils'
require "#{File.dirname(__FILE__)}/../lib/mp3_player"

desc "Adds the required files for playing mp3s"
task :mp3_player do
  Mp3Player::Setup.setup
end
