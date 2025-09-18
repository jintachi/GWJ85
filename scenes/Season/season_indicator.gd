## The node for displaying the current season and time within.
extends Control

#region Declarations
@export var season_clock : TextureRect
@export var season_progress : TextureProgressBar
@export var season_label : Label

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
	
	season_progress.max_value = season_length * progress_resolution
	season_progress.step = 1. / progress_resolution
	
	if season_clock:
		season_clock.pivot_offset = Vector2(64, 64)
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
	
	match(active_season):
		Genum.Season.SPRING:
			season_label.text = "SPRING"
		Genum.Season.SUMMER:
			season_label.text = "SUMMER"
		Genum.Season.FALL:
			season_label.text = "FALL"
		Genum.Season.WINTER:
			season_label.text = "WINTER"

func _advance_clock() -> void:
	var value = tick_count * progress_resolution
	
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(season_progress, "value", value, 0.5)
	tween.play()
#endregion

#region Signal Callbacks
func _on_game_tick() -> void:
	tick_count += 1
	
	print(tick_count)
	if tick_count > season_length:
		_advance_season()
	
	_advance_clock()
