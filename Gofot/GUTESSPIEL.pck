GDPC                �                                                                         P   res://.godot/exported/133200997/export-8db4635f7828aa4b16a7b3f8a01fb7a1-Main.scn�      �      ��҃%�m5�����y    T   res://.godot/exported/133200997/export-d1f2f0391780c92118c3d139e517b07a-block.scn   �      6      E�9���L�ؓ����    ,   res://.godot/global_script_class_cache.cfg   (             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctexp      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �+      a       ��{+O��<~J�7#O       res://Scripts/Game.gd           �      �v�(���z�x2�Ut.       res://Szene/Main.tscn.remap �'      a       �_�����,Qq��`       res://Szene/block.tscn.remap '      b       ����kԧ����5d0r�       res://icon.svg   (      �      C��=U���^Qu��U3       res://icon.svg.import   P&      �       ����əoLx�5����       res://project.binaryP,      ?      ��|`�S��\�P��;    ��K��&extends Node2D

var TETROMINOS
var START_POS
var COLORS

var map
var currentTetromino
var currentRotaion
var currentPos

var nextMoveTime
var moveDelay

var keyDelay
var nextKeyPressTime

@onready
var o_blocks = $Blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	START_POS = Vector2i(441,39)
	
	COLORS =   [Color(0.10,0.87,0.91),Color(0.19,0.12,0.58),
				Color(0.87,0.46,0.12),Color(0.89,0.81,0.08),
				Color(0.09,0.77,0.06),Color(0.71,0.27,0.81),
				Color(0.86,0.20,0.15)]
				
	TETROMINOS = 	[[[0x0,0xF,0x0,0x0],			#I 1
					  [0x4,0x4,0x4,0x4]],			#I 2
					 [[0x8,0xE,0x0,0x0],			#J 1
					  [0xC,0x8,0x8,0x0],			#J 2
					  [0xE,0x2,0x0,0x0],			#J 3
					  [0x4,0x4,0xC,0x0]],			#J 4
					 [[0x2,0xE,0x0,0x0],			#L 1
					  [0x8,0x8,0xC,0x0],			#L 2
					  [0xE,0x8,0x0,0x0],			#L 3
					  [0xC,0x4,0x4,0x0]],			#L 4
					 [[0xC,0xC,0x0,0x0]],			#O 1
					 [[0x8,0xC,0x4,0x0],			#S 1
					  [0x0,0x6,0xC,0x0]],			#S 2
					 [[0x4,0xE,0x0,0x0],			#T 1
					  [0x4,0x6,0x4,0x0],			#T 2
					  [0x0,0xE,0x4,0x0],			#T 3
					  [0x4,0xC,0x4,0x0]],			#T 4
					 [[0x0,0xC,0x6,0x0],			#Z 1
					  [0x4,0xC,0x8,0x0]]]			#Z 2
	
	
	map = []
	for i in range(20):
		var line = []
		for j in range(10):
			line.append(-1)
		map.append(line)
		
	currentTetromino = 2
	currentRotaion = 0
	currentPos = Vector2i(3, 0)
	
	moveDelay = 0.75
	nextMoveTime = 0
	
	keyDelay = 0.2
	nextKeyPressTime = [0, 0, 0, 0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nextMoveTime -= delta
	
	if nextMoveTime <= 0:
		nextMoveTime += moveDelay
		moveTetromino(0,1,0)
	
	processInput(delta)
	
	checkForLine(map)
	
	var currentMap = insertTetromino(map, getCurrentTetromino(), currentPos, currentTetromino)
	renderBlocks(currentMap)


func processInput(delta):
	for i in range(len(nextKeyPressTime)):
		nextKeyPressTime[i] -= delta
		
	if (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)) and nextKeyPressTime[0] <= 0:
			nextKeyPressTime[0] = keyDelay
			moveTetromino(-1,0,0)
	
	if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) and nextKeyPressTime[1] <= 0:
			nextKeyPressTime[1] = keyDelay
			moveTetromino(1,0,0)
			
	if (Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) and nextKeyPressTime[2] <= 0:
			nextKeyPressTime[2] = keyDelay
			moveTetromino(0,1,0)
			
	if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) and nextKeyPressTime[3] <= 0:
			nextKeyPressTime[3] = keyDelay
			moveTetromino(0,0,1)


func checkForLine(array):
	var fullLines = 0
	for i in range(len(array)):
		var lineFull = true
		for block in array[i]:
			if block == -1:
				lineFull = false
				break
		if lineFull:
			fullLines += 1
			for j in range(i, 1, -1):
				array[j] = array[j-1]
	
	

func getCurrentTetromino():
	return TETROMINOS[currentTetromino][currentRotaion % len(TETROMINOS[currentTetromino])]

func moveTetromino(x, y, r):
	currentPos.x += x
	currentPos.y += y
	currentRotaion += r +4
	currentRotaion %= 4
	
	if tetrominoOverlap(map, getCurrentTetromino(), currentPos):
		
		currentPos.x -= x
		currentPos.y -= y
		currentRotaion -= r +4
		currentRotaion %= 4
		
		if y != 0:
			map = insertTetromino(map, getCurrentTetromino(), currentPos, currentTetromino)
			
			currentTetromino = randi() % 7
			currentRotaion = randi() % 4
			currentPos = Vector2i(3, 0)

func insertTetromino(array, tetromino, pos, color):
	var newMap = copyMap(array)
	for i in range(4):
		for j in range(4):
			if tetromino[j] << i & 0b1000:
				newMap[pos.y + j][pos.x + i] = color
	return newMap

func copyMap(array):
	var arrayCopy = []
	for i in array:
		var lineCopy = []
		for j in i:
			lineCopy.append(j)
		arrayCopy.append(lineCopy)
	return arrayCopy
	
func tetrominoOverlap(map, tetromino, pos):
	for i in range(4):
		for j in range(4):
			if tetromino[j] << i & 0b1000:
				if pos.x + i < 0 or pos.x + i >= len(map[j]):
					return true
				if pos.y + j < 0 or pos.y + j >= len(map):
					return true
				if map[pos.y + j][pos.x + i] != -1:
					return true
	return false

func renderBlocks(blocks):
	for o_child in o_blocks.get_children():
		o_blocks.remove_child(o_child)
		o_child.free()
	
	var s_block = load("res://Szene/block.tscn")
	for i in range(20):
		for j in range(10):
			if blocks[i][j] != -1:
				var o_block = s_block.instantiate()
				o_block.position = START_POS + Vector2i(j,i) *30
				o_block.modulate = COLORS[blocks[i][j]]
				o_blocks.add_child(o_block)
!���yRSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    diffuse_texture    normal_texture    specular_texture    specular_color    specular_shininess    texture_filter    texture_repeat    script 	   _bundled           local://CanvasTexture_ok6sv �         local://PackedScene_m22y0 �         CanvasTexture    	         PackedScene    
      	         names "         Block    scale    texture 	   Sprite2D    	   variants       
     �A  �A                node_count             nodes        ��������       ����                          conn_count              conns               node_paths              editable_instances              version       	      RSRC@&4���~^RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    diffuse_texture    normal_texture    specular_texture    specular_color    specular_shininess    texture_filter    texture_repeat    script 	   _bundled       Script    res://Scripts/Game.gd ��������      local://CanvasTexture_gqykx �         local://PackedScene_41vsa �         CanvasTexture    	         PackedScene    
      	         names "         Node2D    Game    script    Blocks    Backgorund 	   modulate    z_index 	   position    scale    texture 	   Sprite2D    UI    CanvasLayer    	   variants                    q�>��(>��`>  �?   ����
    �D �C
     �C  D                node_count             nodes     /   ��������        ����                       ����                            ����               
      ����                           	                        ����              conn_count              conns               node_paths              editable_instances              version       	      RSRC,}��m�i ���GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ `^�����v%�([remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c2piajfq2522o"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 �m�w���Rf���-.[remap]

path="res://.godot/exported/133200997/export-d1f2f0391780c92118c3d139e517b07a-block.scn"
�c�L�U=;S;G�[remap]

path="res://.godot/exported/133200997/export-8db4635f7828aa4b16a7b3f8a01fb7a1-Main.scn"
�l�4˛��-��@��list=Array[Dictionary]([])
e�<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
�L�D*�   �~�����#   res://Szene/block.tscnEY��m�B   res://Szene/Main.tscn�y7��\   res://icon.svg��[��,w�vt�EYECFG      application/config/name         Tetris Clone   application/run/main_scene          res://Szene/Main.tscn      application/config/features$   "         4.1    Forward Plus       application/config/icon         res://icon.svg  4   rendering/textures/vram_compression/import_etc2_astc         c