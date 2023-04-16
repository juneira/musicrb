require 'minitest/autorun'
require 'musicrb'

class PlayListTest < Minitest::Test
  FIRST_MUSIC_METADATA = [
    'Retro Platforming',
    'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
    'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
    'Instrumental'
  ].freeze

  SECOND_MUSIC_METADATA = [
    'Impact Moderato',
    'Kevin MacLeod',
    'YouTube Audio Library',
    'Cinematic'
  ].freeze

  def test_build_play_list
    playlist_name = 'playlist'

    play_list = Music::PlayList.new(playlist_name)
    assert_equal play_list.name, playlist_name
  end

  def test_load_two_medias
    media = load_medias.list.first

    assert_equal [media.title, media.artist, media.album, media.genre], FIRST_MUSIC_METADATA
  end

  def test_load_not_found_media
    play_list = Music::PlayList.new('any')
    play_list.load "#{__dir__}/fixtures/not_found.mp3"

    raise 'error: test_load_not_found_media'
  rescue ArgumentError => e
    assert_equal e.to_s, 'File does not exist'
  end

  def test_play_once
    play_list = load_medias
    media = play_list.play

    assert_equal [media.title, media.artist, media.album, media.genre], FIRST_MUSIC_METADATA
  end

  def test_play_twice
    play_list = load_medias
    play_list.play
    media = play_list.play

    assert_equal [media.title, media.artist, media.album, media.genre], FIRST_MUSIC_METADATA
  end

  def test_next_once
    play_list = load_medias
    media = play_list.next

    assert_equal [media.title, media.artist, media.album, media.genre], SECOND_MUSIC_METADATA
  end

  def test_next_twice
    play_list = load_medias
    play_list.next
    media = play_list.next

    assert_equal [media.title, media.artist, media.album, media.genre], FIRST_MUSIC_METADATA
  end

  def test_prev_once
    play_list = load_medias
    play_list.instance_variable_set(:@current_media, 1)

    media = play_list.prev

    assert_equal [media.title, media.artist, media.album, media.genre], FIRST_MUSIC_METADATA
  end

  def test_prev_twice
    play_list = load_medias
    play_list.instance_variable_set(:@current_media, 1)

    play_list.prev
    media = play_list.prev

    assert_equal [media.title, media.artist, media.album, media.genre], SECOND_MUSIC_METADATA
  end

  def test_autoplay
    play_list = load_medias
    play_list.play
    meta = Music.meta

    assert_equal [meta[:title], meta[:artist], meta[:album], meta[:genre]], FIRST_MUSIC_METADATA
    Music.forward(142500)

    sleep(1)
    meta = Music.meta

    assert_equal [meta[:title], meta[:artist], meta[:album], meta[:genre]], SECOND_MUSIC_METADATA
  end

  private

  def load_medias
    play_list = Music::PlayList.new('any')
    play_list.load "#{__dir__}/fixtures/test.mp3"
    play_list.load "#{__dir__}/fixtures/test.wav"
    play_list
  end
end
