# Music RB
[![Gem Version](https://badge.fury.io/rb/musicrb.svg)](https://badge.fury.io/rb/musicrb)

A player for music to our Ruby ❤️

## Requirement
The lib [vlc](https://www.videolan.org/) is required to use this gem.

To install the lib vlc on Ubuntu
```sh
sudo apt-get install vlc libvlc-dev
```

## Usage
Install gem:
```
gem install musicrb
```

Basic Use:
```ruby
require 'musicrb'

# To play a music
Music.play("/path/of/music.mp3")

# To change volume
Music.volume = 50 #50%

# To show volume
Music.volume

# To forward music in milliseconds
Music.forward(1000)

# To backward music in milliseconds
Music.backward(1000)

# To show time music in milliseconds
Music.time

# To show metadata of music
Music.meta

# To stop
Music.stop
```

Playlist Use:
```ruby
# To create a new playlist
playlist = Music::PlayList.new('any')

# To load musics
playlist.load "/path/of/music1.mp3"
playlist.load "/path/of/music2.mp3"

# To play a playlist
playlist.play

# To play the next music of playlist
playlist.next

# To play the previous music of playlist
playlist.prev

# To show the list of the playlist
puts playlist
```

## Tests

To run tests:
```ruby
rake test
```

## Important!

This gem was tested only on:

OS: *Linux - Ubuntu 22.04.1 LTS*

Ruby: *2.7.7 version*
