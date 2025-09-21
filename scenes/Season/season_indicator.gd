## The node for displaying the current season and time within.
extends Control

#region Declarations
@export var season_clock : TextureRect
@export var season_progress : TextureProgressBar
@export var season_label : RichTextLabel

@export var active_season := Genum.Season.SPRING
@export var season_length : float = 30
@export var progress_resolution : float = 1
var tick_count: float = 0
#endregion

#region Built-Ins
func _ready() -> void:
	GameGlobalEvents.game_tick.connect(_on_game_tick)
	
	if not season_progress:
		return
	
	_update_season_label(active_season)
	_set_initial_rotation(active_season)
	
	season_progress.max_value = season_length * progress_resolution
	season_progress.step = 1. / progress_resolution
	
	if season_clock:
		season_clock.pivot_offset = Vector2(season_clock.size/2)
#endregion

#region Privates
func _advance_season() -> void:
	if not season_clock and not season_label:
		push_error("There is either no season clock or season label")
		return
	
	active_season = (active_season + 1) % 4
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(season_clock, "rotation", PI / 2, 1).as_relative()
	tick_count = 0
	
	_update_season_label(active_season)


func _advance_clock() -> void:
	var value = tick_count * progress_resolution
	
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(season_progress, "value", value, 0.5)
	tween.play()
	
func _update_season_label(season : Genum.Season) -> void :
	
	season_label.clear()
	
	match(season):
		Genum.Season.SPRING:
			season_label.push_color(Color8(231, 176, 108))
			season_label.append_text("SPRING")
			MusicManager.play_song(&"Spring Theme", 0, true)
		Genum.Season.SUMMER:
			season_label.push_color(Color8(277, 148, 84))
			season_label.append_text("SUMMER")
			MusicManager.play_song(&"Summer Theme", 0, true)
		Genum.Season.FALL:
			season_label.push_color(Color8(195, 109, 68))
			season_label.append_text("FALL")
			MusicManager.play_song(&"Fall Theme", 0, true)
		Genum.Season.WINTER:
			season_label.push_color(Color8(247, 236, 174))
			season_label.append_text("WINTER")
			MusicManager.play_song(&"Winter Theme", 0, true)

	season_label.pop_all()

func _set_initial_rotation(season : Genum.Season) -> void:
	
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CIRC)
	
	var _rotation_distance : float
	
	match(season):
		Genum.Season.SPRING:
			_rotation_distance = 0 # No change, image starts on spring
		Genum.Season.SUMMER:
			_rotation_distance += 90
		Genum.Season.FALL:
			_rotation_distance += 180
		Genum.Season.WINTER:
			_rotation_distance -= 90
			
	tween.tween_property(season_clock, "rotation_degrees",_rotation_distance, 0).as_relative()
	tween.play()
	
#endregion

#region Signal Callbacks
func _on_game_tick() -> void:
	tick_count += 1
	
	print(tick_count)
	if tick_count > season_length:
		_advance_season()
	
	_advance_clock()
