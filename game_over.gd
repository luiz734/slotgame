extends Control

@onready var menu_button: MainMenuButton= $Background/Options/Menu
@onready var quit_button: MainMenuButton = $Background/Options/Quit
@onready var transition: Transition = $Transition
@onready var percentage_label = %PercentageLabel
var menu_prefab = preload("res://main_menu.tscn")

func on_menu_clicked():
    transition.start()
    await transition.finished
    get_tree().change_scene_to_packed(menu_prefab)
    
func on_quit_pressed():
    get_tree().quit()

func _ready():
    assert(menu_button, "Missing menu_button reference")
    assert(quit_button, "Missing quit_button reference")
    assert(transition, "Missing transition reference")
    assert(percentage_label, "Missing percentage_label reference")
    menu_button.clicked.connect(on_menu_clicked)
    quit_button.clicked.connect(on_quit_pressed)
    var p = GameState.correct_answers * 10
    percentage_label.text = str(p) + "%"

func _process(delta):
    pass
