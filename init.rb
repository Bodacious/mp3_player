require 'mp3_player'
# includes the view helper to ActionView::Base
ActionView::Base.send(:include, Mp3Player::ViewHelper)
