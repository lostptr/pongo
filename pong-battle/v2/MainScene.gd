extends Node2D

onready var slow_mo_tween: Tween = $SlowMoTween

onready var winner_tex: TextureRect = $GUI/MatchUI/MatchResults/WinnerTex
onready var looser_tex: TextureRect = $GUI/MatchUI/MatchResults/LooserTex
onready var pause_menu: Control = $GUI/PauseMenu
var winner_name: String

func _ready():
	pause_menu.main_scene = self
	slow_mo_tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 0.2, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	disable_movement()

func disable_movement():
	get_tree().paused = true

func enable_movement():
	get_tree().paused = false

func trigger_ending():
	pause_menu.enabled = false
	$GUI/MatchUI/AnimationPlayer.play("end_game")
	slow_mo_tween.start()
	
func show_results():
	disable_movement()
	$GUI/MatchUI/MatchResults/WinnerTextContainer/WinnerName.text = winner_name
	slow_mo_tween.stop_all()
	Engine.time_scale = 1
	$GUI/MatchUI/AnimationPlayer.play("show_results")

func _on_Player1_defeated():
	self.winner_name = "Player 2"
	self.looser_tex.modulate = Color("#ff3891").darkened(0.5)
	self.winner_tex.modulate = Color("#00fff8").lightened(0.4)
	trigger_ending()

func _on_Player2_defeated():
	self.winner_name = "Player 1"
	self.looser_tex.modulate = Color("#00fff8").darkened(0.5)
	self.winner_tex.modulate = Color("#ff3891").lightened(0.4)
	trigger_ending()

func _on_TryAgainButton_pressed():
	SceneTransition.switch_scene(self, SceneTransition.MainGame)

func _on_MainMenuButton_pressed():
	enable_movement()
	SceneTransition.switch_scene(self, SceneTransition.MainMenu)
