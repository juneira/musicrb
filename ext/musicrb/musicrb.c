#include <ruby/ruby.h>
#include <unistd.h>
#include <vlc/vlc.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

VALUE rb_cMusic;

libvlc_instance_t* inst;
libvlc_media_t* m;
libvlc_media_player_t* mp;

VALUE
rb_music_meta(VALUE msc)
{
  if(m == NULL || mp == NULL) return Qnil;

  libvlc_state_t state = libvlc_media_player_get_state(mp);
  if(state != libvlc_Playing) return Qnil;

  char *title = libvlc_media_get_meta(m, libvlc_meta_Title);
  char *artist = libvlc_media_get_meta(m, libvlc_meta_Artist);
  char *album = libvlc_media_get_meta(m, libvlc_meta_Album);
  char *genre = libvlc_media_get_meta(m, libvlc_meta_Genre);

  if(title == NULL || artist == NULL || album == NULL || genre == NULL) return Qnil;

  VALUE meta = rb_hash_new();
  rb_hash_aset(meta, ID2SYM(rb_intern("title")), rb_str_new_cstr(title));
  rb_hash_aset(meta, ID2SYM(rb_intern("artist")), rb_str_new_cstr(artist));
  rb_hash_aset(meta, ID2SYM(rb_intern("album")), rb_str_new_cstr(album));
  rb_hash_aset(meta, ID2SYM(rb_intern("genre")), rb_str_new_cstr(genre));

  return meta;
}

VALUE
rb_music_stop(VALUE msc)
{
  if(m == NULL || mp == NULL) return Qnil;
  
  /* Stop playing */
  libvlc_media_player_stop(mp);

  /* Free the media */
  libvlc_media_release(m);

  /* Free the media_player */
  libvlc_media_player_release(mp);
  
  m = NULL;
  mp = NULL;

  return Qnil;
}

VALUE
rb_music_play(VALUE msc, VALUE rpath)
{
  /* Stop music if already playing */
  if(mp != NULL) {
    rb_music_stop(msc);
  }

  /* Convert Ruby String to C String */
  char *cpath = rb_string_value_cstr(&rpath);

  /* Check if rpath is a valid path of file */
  if(access(cpath, F_OK) != 0) {
    rb_raise(rb_eArgError, "File does not exist");
  }

  /* Create a new media */
  m = libvlc_media_new_path(inst, cpath);

  /* Create a media player */
  mp = libvlc_media_player_new_from_media(m);

  /* Play the media_player */
  libvlc_media_player_play(mp);
 
  /* Wait the media_player */
  while(libvlc_media_player_get_state(mp) != libvlc_Playing);

  return rb_music_meta(msc);
}

void
Init_musicrb(void)
{
  /* Load the VLC engine */
  inst = libvlc_new(0, NULL);

  rb_cMusic = rb_define_class("Music", rb_cObject);
  rb_define_singleton_method(rb_cMusic, "play", rb_music_play, 1);
  rb_define_singleton_method(rb_cMusic, "stop", rb_music_stop, 0);
  rb_define_singleton_method(rb_cMusic, "meta", rb_music_meta, 0);
}
