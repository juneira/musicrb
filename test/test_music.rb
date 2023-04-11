require 'minitest/autorun'
require 'musicrb'

class MusicTest < Minitest::Test
  def test_play_when_file_exists
    result = Music.play("#{__dir__}/fixtures/test.mp3")
    Music.stop

    expected = {
      title: 'Retro Platforming',
      artist: 'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
      album: 'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
      genre: 'Instrumental'
    }

    assert_equal expected, result
  end

  def test_play_when_calls_twice
    Music.play("#{__dir__}/fixtures/test.mp3")
    result = Music.play("#{__dir__}/fixtures/test.mp3")
    Music.stop

    expected = {
      title: 'Retro Platforming',
      artist: 'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
      album: 'FesliyanStudios.com ASCAP IPI 792929876, 792929974',
      genre: 'Instrumental'
    }

    assert_equal expected, result
  end

  def test_play_when_file_does_not_exist
    Music.play("#{__dir__}/fixtures/does_not_exist.mp3")
    raise 'error: test_play_when_file_does_not_exist'
  rescue ArgumentError => e
    assert_equal e.to_s, 'File does not exist'
  end

  def test_stop_when_is_playing
    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.stop

    assert_nil Music.meta
  end

  def test_stop_twice
    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.stop
    Music.stop

    assert_nil Music.meta
  end
end
