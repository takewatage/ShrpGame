extends RigidBody2D

class_name Item

## 種類.
## 進化テーブル
enum eItem {
    WORDPRESS,
    JS,
    VUE,
    FIGMA,
    DOCKER,
    PHP,
    LARAVEL,
    REACTNATIVE,
    MYSQL,
    SHRP,
}

## 名前テーブル.
const NAMES = {
    eItem.WORDPRESS: "Wordpress",
    eItem.JS: "Js",
    eItem.VUE: "Vue",
    eItem.FIGMA: "Figma",
    eItem.DOCKER: "Docker",
    eItem.PHP: "Php",
    eItem.LARAVEL: "Laravel",
    eItem.REACTNATIVE: "Reactnative",
    eItem.MYSQL: "Mysql",
    eItem.SHRP: "Shrp",
}

## テクスチャテーブル.
const TEXTURES = {
    eItem.WORDPRESS: "res://assets/images/items/item1.png",
    eItem.JS: "res://assets/images/items/item2.png",
    eItem.VUE: "res://assets/images/items/item3.png",
    eItem.FIGMA: "res://assets/images/items/item4.png",
    eItem.DOCKER: "res://assets/images/items/item5.png",
    eItem.PHP: "res://assets/images/items/item6.png",
    eItem.LARAVEL: "res://assets/images/items/item7.png",
    eItem.REACTNATIVE: "res://assets/images/items/item8.png",
    eItem.MYSQL: "res://assets/images/items/item9.png",
    eItem.SHRP: "res://assets/images/items/item10.png",
}

# -----------------------------------------------
# export.
# -----------------------------------------------
## アイテムID
@export var id:eItem
## スコア
@export var score:int


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass
        
    
    

## 当たった時
func _on_body_entered(body: Node) -> void:

    if not body is Item:
        return 
        
    if self.is_queued_for_deletion():
        return # すでに破棄要求されている.
    if body.is_queued_for_deletion():
        return # すでに破棄要求されている.

    # ヒットした.
    var other = body as Item
    
    if id != other.id:
        return # 一致していないので何も起こらない.
        
    # IDが一致していたら合成可能.
    if id < eItem.SHRP:
        # 中間地点取得
        var pos = (position + other.position) / 2
        var item = Common.createItem(id + 1, pos)
        item.position = pos
        
        var _se = Common.eSe.MARGE
        #shrpを作ったら特殊SE
        if eItem.SHRP == item.id:
            _se = Common.eSe.MAKE_SHRP
            
        var current_scene = get_tree().get_current_scene()
        
        Common.playSE(_se)
        current_scene.call_deferred("popPartical", pos)
    else:
        Common.playSE(Common.eSe.MAKE_SHRP)
        
    # お互いに消滅する.
    queue_free()
    other.queue_free()

    
# クリア後の挙動
func jumpOut() -> void:
    var bottol_center = Vector2(360, 640)
    var force_direction = (position - bottol_center).normalized()
    
    var shot_speed = 250.0
    var shot_force = shot_speed * force_direction

    for child in Common.getLayer('wall').get_children():
        if child.is_class("RigidBody2D"):
            var collision_shape = child.get_node("CollisionShape2D")
            if collision_shape:
                collision_shape.set_deferred('disabled', true)
                
    apply_central_impulse(shot_force)
    


