#include <ruby/ruby.h>
#include <vlc/vlc.h>

#include <stdio.h>
#include <stdlib.h>

VALUE rb_cMusic;

libvlc_instance_t* inst;
libvlc_media_player_t* mp;

VALUE
rb_music_stop(VALUE msc)
{
  /* Stop playing */
  libvlc_media_player_stop(mp);
 
  /* Free the media_player */
  libvlc_media_player_release(mp);
  mp = NULL;

  return msc;
}

VALUE
rb_music_play(VALUE msc, VALUE rpath)
{
  libvlc_media_t* m;

  /* Convert Ruby String to C String */
  char *cpath = rb_string_value_cstr(&rpath);

  /* Create a new media */
  m = libvlc_media_new_path(inst, cpath);

  /* Stop music if already playing */
  if(mp != NULL){
    rb_music_stop(msc);
  }

  /* Create a media player */
  mp = libvlc_media_player_new_from_media(m);

  /* No need to keep the media now */
  libvlc_media_release(m);
 
  /* play the media_player */
  libvlc_media_player_play(mp);
 
  return msc;
}

void
Init_musicrb(void)
{
  /* Load the VLC engine */
  inst = libvlc_new(0, NULL);

  rb_cMusic = rb_define_class("Music", rb_cObject);
  rb_define_singleton_method(rb_cMusic, "play", rb_music_play, 1);
  rb_define_singleton_method(rb_cMusic, "stop", rb_music_stop, 0);
}
