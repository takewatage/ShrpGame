extends Sprite2D

var speed = 5
var is_controll = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if is_controll:
        var input = Input.get_axis("move_left", "move_right")
        
        position.x += input * speed
        
        if position.x > 675:
            position.x = 45
        if position.x < 45:
            position.x = 675

