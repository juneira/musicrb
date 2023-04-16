# frozen_string_literal: true

class Music
  # Media is a class used to reference any music with any format
  class Media
    attr_reader :title, :artist, :album, :genre

    def to_s
      "#{title} | #{artist} | #{album} | #{genre}"
    end
  end

  # PlayList is a class used to create and play a list of musics
  class PlayList
    attr_reader :name, :list

    def initialize(name)
      @name = name
      @list = []
      @current_media = 0
      @playing = false
    end

    def to_s
      "Playlist: #{name}\n#{list_to_s}"
    end

    def load(file_path)
      @list << Media.load(file_path)
    end

    def play
      stop_others_others_play_lists
      @playing = true

      @current_media = 0 if @current_media >= @list.length
      media = @list[@current_media]

      return if media == nil

      intern_play(media)

      media
    end

    def prev
      @current_media = (@current_media - 1) % list.length
      play
    end

    def next
      @current_media = (@current_media + 1) % list.length
      play
    end

    private

    def list_to_s
      @list.map(&:to_s).each_with_index.reduce("") do |str, (media_str, idx)|
        show_icon = (@playing && idx == @current_media)
        track_str = "#{idx + 1} - #{media_str}\n"

        str += show_icon ? "► #{track_str}" : track_str
      end
    end

    def stop_others_others_play_lists
      ObjectSpace.each_object(Music::PlayList) { |play_list| play_list.instance_variable_set("@playing", false) }
    end
  end
end
