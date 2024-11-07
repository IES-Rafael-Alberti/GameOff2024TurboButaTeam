extends TextureButton

@export var face = Texture
var back

# Called when the node enters the scene tree for the first time.
func _ready():
	back = GameManager.cardBack
	set_texture_normal(back)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
