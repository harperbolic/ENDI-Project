extends Panel

@onready var scene_selector: MenuButton = $Container/SceneSelector
@onready var popup = scene_selector.get_popup()

func _ready() -> void:
	add_scenes()
	popup.id_pressed.connect(change_scene)

func add_scenes():
	for r in Scene.scenes:
		popup.add_item(r)

func change_scene(id):
	var scene_str : String = popup.get_item_text(id)
	Scene.load_scene(scene_str)
