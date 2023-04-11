# frozen_string_literal: true

class Music
  # Media is a class used to reference any music with any format
  class Media
    attr_reader :title, :artist, :album, :genre
  end

  # PlayList is a class used to create and play a list of musics
  class PlayList
    attr_reader :name, :list

    def initialize(name)
      @name = name
      @list = []
      @current_media = 0
    end

    def load(file_path)
      @list << Media.load(file_path)
    end

    def play
      @current_media = 0 if @current_media == -1 || @current_media >= @list.length
      media = @list[@current_media]

      @list.first&.play

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
  end
end
