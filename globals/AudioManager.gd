extends AudioStreamPlayer2D

var invalid_placement_sfx := preload("res://assets/sfx/Point Invalid 2.wav")
var invalid_placement_sfx_1 := preload("res://assets/sfx/Point Invalid.wav")

func _play_music(music: AudioStream, volume = -7):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level():
	pass
	#

func play_effect(aud_stream: AudioStream, volume = 0.0, loops = false):
	var fx_player = AudioStreamPlayer2D.new()
	fx_player.stream = aud_stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	if not loops: 
		fx_player.finished.connect(fx_player.queue_free)
	else:
		return fx_player
	
