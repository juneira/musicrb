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

Play/Stop music:
```ruby
require 'musicrb'

# To play a music
Music.play("/path/of/music.mp3")

#To stop
Music.stop
```

## Important!

This gem was tested only on:

OS: *Linux - Ubuntu 22.04.1 LTS*

Ruby: *2.7.7 version*
