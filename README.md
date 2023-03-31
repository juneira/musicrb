# Music RB
A player for music to our Ruby ❤️

## Requirement
The lib [vlc](https://www.videolan.org/) is required to use this gem.

To install the lib vlc on Ubuntu
```sh
sudo apt-get install libvlc-dev
```

## Usage
Install gem:
```
gem install musicrb
``

To play a music:
```ruby
Music.play("/path/of/music.mp3")
```

To stop a music:
```ruby
Music.stop
```

## Important!

This gem was tested only on:

OS: *Linux - Ubuntu 22.04.1 LTS*

Ruby: *2.7.7 version*
