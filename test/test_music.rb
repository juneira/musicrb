require 'minitest/autorun'
require 'musicrb'

class MusicTest < Minitest::Test
  MILLISECONDS = 1_000

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

  def test_forward_10_seconds
    forward_in_seconds = 10 * MILLISECONDS # 10 seconds

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(forward_in_seconds)

    assert_equal Music.time, forward_in_seconds
  end

  def test_forward_20_seconds
    forward_in_seconds = 20 * MILLISECONDS # 20 seconds

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(forward_in_seconds)

    assert_equal Music.time, forward_in_seconds
  end

  def test_forward_30_seconds
    forward_in_seconds = 30 * MILLISECONDS # 30 seconds

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(forward_in_seconds)

    assert_equal Music.time, forward_in_seconds
  end

  def test_backward_10_seconds
    backward_in_seconds = 10 * MILLISECONDS # 10 seconds

    # Media initialized in 30 seconds
    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(30 * 1000) # 30 seconds

    Music.backward(backward_in_seconds)

    assert_equal Music.time, 20 * MILLISECONDS
  end

  def test_backward_20_seconds
    backward_in_seconds = 20 * MILLISECONDS # 20 seconds

    # Media initialized in 30 seconds
    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(30 * 1000) # 30 seconds

    Music.backward(backward_in_seconds)

    assert_equal Music.time, 10 * MILLISECONDS
  end

  def test_backward_30_seconds
    backward_in_seconds = 30 * MILLISECONDS # 30 seconds

    # Media initialized in 30 seconds
    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.forward(30 * 1000) # 30 seconds

    Music.backward(backward_in_seconds)

    assert_equal Music.time, 0 * MILLISECONDS
  end

  def test_backward_10_seconds_when_media_has_less_10_seconds_playing
    backward_in_seconds = 10 * MILLISECONDS # 10 seconds

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.backward(backward_in_seconds)

    assert_equal Music.time, 0 * MILLISECONDS
  end

  def test_volume_0_percent
    volume = 0 # 0 %

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.volume = volume

    assert_equal Music.volume, volume
  end

  def test_volume_50_percent
    volume = 50 # 50 %

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.volume = volume

    assert_equal Music.volume, volume
  end

  def test_volume_100_percent
    volume = 100 # 100 %

    Music.play("#{__dir__}/fixtures/test.mp3")
    Music.volume = volume

    assert_equal Music.volume, volume
  end
end
