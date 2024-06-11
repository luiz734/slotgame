extends Control

@onready var play_button: MainMenuButton = $Background/Options/PLAY
@onready var scores_button: MainMenuButton= $Background/Options/SCORES
@onready var quit_button: MainMenuButton = $Background/Options/QUIT
@onready var transition: Transition = $Transition

var game_prefab = preload("res://main.tscn")

func on_play_clicked():
    transition.start()
    await transition.finished
    get_tree().change_scene_to_packed(game_prefab)
    
func on_scores_pressed():
    print_debug("not implemented")
    
func on_quit_pressed():
    get_tree().quit()
    
# Called when the node enters the scene tree for the first time.
func _ready():
    assert(play_button, "Missing play_button reference")
    assert(scores_button, "Missing scores_button reference")
    assert(quit_button, "Missing quit_button reference")
    play_button.clicked.connect(on_play_clicked)
    scores_button.clicked.connect(on_scores_pressed)
    quit_button.clicked.connect(on_quit_pressed)
