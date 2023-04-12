#include <ruby/ruby.h>
#include <unistd.h>
#include <vlc/vlc.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

VALUE rb_cMusic;
VALUE rb_cMedia;

libvlc_instance_t *inst;
libvlc_media_t *m;
libvlc_media_player_t *mp;

VALUE
rb_music_meta(VALUE msc)
{
	if (m == NULL || mp == NULL)
		return Qnil;

	libvlc_state_t state = libvlc_media_player_get_state(mp);
	if (state != libvlc_Playing)
		return Qnil;

	char *title = libvlc_media_get_meta(m, libvlc_meta_Title);
	char *artist = libvlc_media_get_meta(m, libvlc_meta_Artist);
	char *album = libvlc_media_get_meta(m, libvlc_meta_Album);
	char *genre = libvlc_media_get_meta(m, libvlc_meta_Genre);

	if (title == NULL || artist == NULL || album == NULL || genre == NULL)
		return Qnil;

	VALUE meta = rb_hash_new();
	rb_hash_aset(meta, ID2SYM(rb_intern("title")), rb_str_new_cstr(title));
	rb_hash_aset(meta, ID2SYM(rb_intern("artist")), rb_str_new_cstr(artist));
	rb_hash_aset(meta, ID2SYM(rb_intern("album")), rb_str_new_cstr(album));
	rb_hash_aset(meta, ID2SYM(rb_intern("genre")), rb_str_new_cstr(genre));

	return meta;
}

VALUE
rb_music_time(VALUE msc)
{
	return INT2NUM(libvlc_media_player_get_time(mp));
}

void
intern_stop()
{
	if (m == NULL || mp == NULL) return ;

	/* Stop playing */
	libvlc_media_player_stop(mp);

	/* Free the media_player */
	libvlc_media_player_release(mp);

	m = NULL;
	mp = NULL;
}

VALUE
rb_music_stop(VALUE msc)
{
	if (m == NULL || mp == NULL) return Qnil;

	intern_stop();

	return Qnil;
}

void intern_play(libvlc_media_t *cmedia)
{
	/* Stop music if already playing */
	if (mp != NULL)
		intern_stop();

	/* Set new media */
	m = cmedia;

	/* Create a media player */
	mp = libvlc_media_player_new_from_media(m);

	/* Play the media_player */
	libvlc_media_player_play(mp);

	/* Wait the media_player */
	while (libvlc_media_player_get_state(mp) != libvlc_Playing);
}

VALUE
rb_music_play(VALUE msc, VALUE rpath)
{
	/* Convert Ruby String to C String */
	char *cpath = rb_string_value_cstr(&rpath);

	/* Check if rpath is a valid path of file */
	if (access(cpath, F_OK) != 0)
		rb_raise(rb_eArgError, "File does not exist");

	/* Create a new media */
	libvlc_media_t *cmedia = libvlc_media_new_path(inst, cpath);

	/* Play media */
	intern_play(cmedia);

	return rb_music_meta(msc);
}

VALUE
rb_music_forward(VALUE msc, VALUE rmseconds)
{
	if(mp == NULL) return Qnil;

	/* Convert number of Ruby to int of C */
	int cmseconds = NUM2INT(rmseconds);

	/* Get time of media player */
	int time = libvlc_media_player_get_time(mp);

	/* Add milliseconds for this time */
	libvlc_media_player_set_time(mp, time + cmseconds);

	return Qnil;
}

VALUE
rb_music_backward(VALUE msc, VALUE rmseconds)
{
	if(mp == NULL) return Qnil;

	/* Convert number of Ruby to int of C */
	int cmseconds = NUM2INT(rmseconds);

	/* Get time of media player */
	int time = libvlc_media_player_get_time(mp);

	/* Remove milliseconds for this time */
	int current_time = time - cmseconds;

	/* Ensure that value is positive */
	if(current_time < 0) current_time = 0;

	/* Set the time */
	libvlc_media_player_set_time(mp, current_time);

	return Qnil;
}

VALUE
rb_media_load(VALUE mda, VALUE rpath)
{
	/* Convert Ruby String to C String */
	char *cpath = rb_string_value_cstr(&rpath);

	/* Check if rpath is a valid path of file */
	if (access(cpath, F_OK) != 0)
		rb_raise(rb_eArgError, "File does not exist");

	/* Create a new media */
	libvlc_media_t *cmedia = libvlc_media_new_path(inst, cpath);

	/* Parse the media to retrieve its metadata */
	libvlc_media_parse(cmedia);

	/* Get metadata of media */
	char *title = libvlc_media_get_meta(cmedia, libvlc_meta_Title);
	char *artist = libvlc_media_get_meta(cmedia, libvlc_meta_Artist);
	char *album = libvlc_media_get_meta(cmedia, libvlc_meta_Album);
	char *genre = libvlc_media_get_meta(cmedia, libvlc_meta_Genre);

	if (title == NULL || artist == NULL || album == NULL || genre == NULL)
		return Qnil;

	/* Convert to a Ruby type */
	VALUE rbmedia = Data_Wrap_Struct(rb_cObject, 0, free, cmedia);

	/* Call Media.new */
	VALUE media_obj = rb_funcall(rb_cMedia, rb_intern("new"), 0);

	/* Set media wraped */
	rb_iv_set(media_obj, "@media_intern", rbmedia);

	/* Set the attributes of object media */
	rb_iv_set(media_obj, "@title", rb_str_new_cstr(title));
	rb_iv_set(media_obj, "@artist", rb_str_new_cstr(artist));
	rb_iv_set(media_obj, "@album", rb_str_new_cstr(album));
	rb_iv_set(media_obj, "@genre", rb_str_new_cstr(genre));

	return media_obj;
}

VALUE
rb_media_play(VALUE mda)
{
	libvlc_media_t *cmedia;

	/* Get the struct media in Ruby object */
	VALUE rmedia = rb_ivar_get(mda, rb_intern("@media_intern"));

	/* Convert to struct C */
	Data_Get_Struct(rmedia, libvlc_media_t, cmedia);

	/* Play media */
	intern_play(cmedia);
}

void
Init_musicrb(void)
{
	/* Load the VLC engine */
	inst = libvlc_new(0, NULL);

	rb_cMusic = rb_const_get(rb_cObject, rb_intern("Music"));
	rb_define_singleton_method(rb_cMusic, "play", rb_music_play, 1);
	rb_define_singleton_method(rb_cMusic, "forward", rb_music_forward, 1);
	rb_define_singleton_method(rb_cMusic, "backward", rb_music_backward, 1);
	rb_define_singleton_method(rb_cMusic, "stop", rb_music_stop, 0);
	rb_define_singleton_method(rb_cMusic, "meta", rb_music_meta, 0);
	rb_define_singleton_method(rb_cMusic, "time", rb_music_time, 0);

	rb_cMedia = rb_const_get(rb_cMusic, rb_intern("Media"));
	rb_define_singleton_method(rb_cMedia, "load", rb_media_load, 1);
	rb_define_method(rb_cMedia, "play", rb_media_play, 0);
}
