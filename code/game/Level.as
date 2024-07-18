package code.game {
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import code.Main;
	import code.misc.SoundControl;
	
	public class Level {
		var movieClip:MovieClip;
		var platforms:Vector.<MovieClip>;
		var floors:Vector.<MovieClip>;
		var walls:Vector.<MovieClip>;
		var boxes:Vector.<MovieClip>;
		var objectPoint:MovieClip;
		var player:Player;
		var playerStartX:int;
		var playerStartY:int;
		
		var horizontalDistance:int;
		var verticalDistance:int;
		
		private var levelWidth:int;
		private var levelHeight:int;
		private var screenWidth:int;
		private var screenHeight:int;
		
		var objectText:TextField;
		
		var soundControl:SoundControl;
		var bgmStage01:BGMStage01;
		
		public function Level(screenWidth:int, screenHeight:int, soundControl:SoundControl) {
			this.soundControl = soundControl;
			this.screenWidth = screenWidth;
			this.screenHeight = screenHeight;
			
			horizontalDistance = screenWidth/2;
			verticalDistance = screenHeight/2;
			
			bgmStage01 = new BGMStage01();
		}
		
		public function startLevel(level:int):void{
			if(level == 0){
				movieClip = new Level01_mc();
			}else if(level == 1){
				movieClip = new Stage01_mc;
				soundControl.currentBGM.stop();
				soundControl.playBGM(bgmStage01, 0, -1);
			}
			playerStartX = movieClip.player_mc.x;
			playerStartY = movieClip.player_mc.y;
			if(movieClip is Stage01_mc){
				levelWidth = 10760;
			}else{
				levelWidth = movieClip.width;
			}			
			levelHeight = movieClip.height;
			
			objectText = new TextField();
		}
		
		public function initialize(player:Player):void{
			this.player = player;
			player.movieClip.x = playerStartX;
			player.movieClip.y = playerStartY;
			
			movieClip.x = 0;
			movieClip.y = 0;
			
			platforms = new Vector.<MovieClip>();
			floors = new Vector.<MovieClip>();
			walls = new Vector.<MovieClip>();
			boxes = new Vector.<MovieClip>();
			examineLevel(movieClip);
		}
		
		private function examineLevel(target:DisplayObjectContainer):void{
			for(var i:int=0; i<target.numChildren; i++){
				if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(Platform_mc)){
					walls.push(target.getChildAt(i));
				}if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(PlatformTeste_mc)){
					platforms.push(target.getChildAt(i));
				}if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(Floor_mc)){
					floors.push(target.getChildAt(i));
				}if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(FloorTeste_mc)){
					floors.push(target.getChildAt(i));
				}if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(Wall_mc)){
					walls.push(target.getChildAt(i));
				}if(getQualifiedClassName(target.getChildAt(i)) == getQualifiedClassName(Stairs_mc)){
					//examineLevel(DisplayObjectContainer(target.getChildAt(i)));
				}if(target.getChildAt(i) is Box_mc){
					boxes.push(target.getChildAt(i));
				}if(target.getChildAt(i) is TeacherRoomDoor_mc && movieClip is Stage01_mc){
					objectPoint = MovieClip(target.getChildAt(i));
				}if(target.getChildAt(i) is ClassRoomDoor_mc && movieClip is Level01_mc){
					objectPoint = MovieClip(target.getChildAt(i));
				}
			}
		}
		
		public function enterFrameHandler(event:Event):void{			
			if(player.up && player.dy < 0){
				if(player.movieClip.y - player.movieClip.height/2 + movieClip.y <= verticalDistance && movieClip.y - (player.dy) * player.GRAVITY*1000 <= 0){
					//player.movieClip.y = verticalDistance - player.movieClip.height/2;					
					movieClip.y -= (player.dy+player.GRAVITY) * player.GRAVITY*1000;
				}
			}if(!player.inGround && player.dy > 0){
				var floorTarget:MovieClip = floors[0];
				var hasFloor:Boolean = false;
				for(var i:int=0; i<floors.length; i++){
					if(player.movieClip.y > floorTarget.y ||
					   player.movieClip.x < floorTarget.x || player.movieClip.x > floorTarget.x + floorTarget.width){
						floorTarget = floors[i];
					}else if(player.movieClip.y < floors[i].y && 
							 player.movieClip.x >= floors[i].x && player.movieClip.x <= floors[i].x + floors[i].width &&
							 floors[i].y - player.movieClip.y < floorTarget.y - player.movieClip.y){
						floorTarget = floors[i];
					}else if(i == floors.length - 1){
						hasFloor = true;
					}
				}
				//trace(hasFloor);
				if(player.movieClip.y - player.movieClip.height/2 + movieClip.y >= verticalDistance){
					if(hasFloor){
						if(floorTarget.y + movieClip.y - (player.dy+player.GRAVITY) * player.GRAVITY*1000 > screenHeight - floorTarget.height){
							movieClip.y -= (player.dy+player.GRAVITY) * player.GRAVITY*1000;
						}else if(floorTarget.y + movieClip.y > screenHeight - floorTarget.height){
							movieClip.y -= (floorTarget.y + movieClip.y) - (screenHeight - floorTarget.height);
						}
					}else if(levelHeight + movieClip.y - (player.dy+player.GRAVITY) * player.GRAVITY*1000 >= screenHeight){
						movieClip.y -= (player.dy+player.GRAVITY) * player.GRAVITY*1000;
					}
				}
				//trace("p.y: "+player.movieClip.y);
				//trace("f.y: "+(floorTarget.y + movieClip.y)+", Original f.y: "+floorTarget.y);
			}
			
			//if((player.left && !player.right && !player.down) || (player.dx > 0 && player.movieClip.scaleX < 0)){
			if(player.dx > 0 && player.movieClip.scaleX < 0){
				if(player.movieClip.x + movieClip.x <= horizontalDistance && movieClip.x + player.speed <= 0){
					movieClip.x += player.speed;
				}
			}if(player.dx > 0 && player.movieClip.scaleX > 0){
				//trace(levelWidth);
				//trace(movieClip.x+", "+movieClip.width);
				if(player.movieClip.x + movieClip.x >= horizontalDistance && movieClip.x - player.speed >= screenWidth - levelWidth){
					movieClip.x -= player.speed;
				}
			}
			
			if(player.movieClip.y + (player.dy+player.GRAVITY) * player.GRAVITY*1000 >= levelHeight + player.movieClip.height){
				player.alive = false;
			}
		}
				
		public function onColision(event:Event):void{
			for(var i:int=0; i<platforms.length; i++){
				var considerParent:Boolean;
				if(platforms[i].parent == movieClip){					
					considerParent = false;
				}else{
					considerParent = true;					
				}
				if(player.collide(platforms[i], considerParent)){
					player.inGround = true;
					break;
				}else if(i == platforms.length-1){
					player.inGround = false;
				}
			}for(i=0; i<walls.length; i++){
				if(player.collide(walls[i])){
					player.inGround = true;
					break;
				}else if(platforms.length == 0){
					player.inGround = false;
				}
			}for(i=0; i<boxes.length; i++){
				if(player.collide(boxes[i])){
					player.inGround = true;
					break;
				}else if(platforms.length == 0 && walls.length == 0){
					player.inGround = false;
				}
			}for(i=0; i<floors.length; i++){
				if(player.collide(floors[i])){
					player.inGround = true;
					break;
				}else if(platforms.length == 0 && walls.length == 0 && boxes.length == 0){
					player.inGround = false;
				}
			}
			
			for(i=0; i<floors.length; i++){
				if(player.collideSide(floors[i], player.movieClip.scaleX)){
					player.pushObjectInRange = false;
					if(player.movieClip.scaleX > 0){
						player.hitWall = "right";
					}else{
						player.hitWall = "left";
					}
					break;
				}else if(i == floors.length-1){
					player.hitWall = "";
					player.pushObjectInRange = false;
				}
			}for(i=0; i<walls.length; i++){
				if(player.collideSide(walls[i], player.movieClip.scaleX)){
					if(walls[i] is Wall_mc){
						player.pushObjectInRange = true;
					}else{
						player.pushObjectInRange = false;
					}
					if(player.movieClip.scaleX > 0){
						player.hitWall = "right";
					}else{
						player.hitWall = "left";
					}
					break;
				}else if(floors.length == 0){
					player.hitWall = "";
					player.pushObjectInRange = false;
				}
			}for(i=0; i<boxes.length; i++){
				if(player.collideSide(boxes[i], player.movieClip.scaleX)){
					if(player.movieClip.scaleX > 0){
						player.hitWall = "right";
					}else{
						player.hitWall = "left";
					}
					player.pushObjectInRange = true;
					/*if(player.push){
						if(player.dx + player.acceleration/5 <= player.dxMax/5){
							player.dx += player.acceleration/5;
						}else if(player.dx + player.acceleration/5 > player.dxMax/5){
							player.dx = player.dxMax/5;
						}
						trace(player.dx+" / "+player.dxMax/5);
						player.speed = player.dx * 10;
						player.movieClip.x += player.speed*movieClip.scaleX;
						boxes[i].x += player.speed*player.movieClip.scaleX;						
					}*/
					
					break;
				}else if(floors.length == 0 && walls.length == 0){
					player.hitWall = "";
					player.pushObjectInRange = false;
				}
			}
			//trace(player.hitWall);
			
			if(objectPoint != null && player.movieClip.hitTestObject(objectPoint)){
				if(player.interaction && !movieClip.contains(objectText)){
					objectText.setTextFormat(new TextFormat("Arial", 30.0, 0x000000, true));
					if(movieClip is Level01_mc){
						objectText.text = "PROTÓTIPO DE AMBIENTAÇÃO CONCLUÍDO";
					}else if(movieClip is Stage01_mc){
						objectText.text = "PROTÓTIPO DE ANIMAÇÃO CONCLUÍDO";
					}					
					objectText.width = objectText.textWidth;
					objectText.height = objectText.textHeight;
					objectText.selectable = false;  
					objectText.border = true;
					objectText.autoSize = TextFieldAutoSize.LEFT;
					objectText.x = (objectPoint.x + 100.5 - objectText.width + objectPoint.x)/2
					objectText.y = objectPoint.y - objectText.height - 50;
					movieClip.addChild(objectText);
					
					var timer:Timer = new Timer(5000);
					timer.addEventListener(TimerEvent.TIMER,
						function timeTick(event:TimerEvent):void{
							if(movieClip is Level01_mc){
								Main.gameState = "next level";
							}else if(movieClip is Stage01_mc){
								Main.gameState = "exit game";
							}							
							movieClip.removeChild(objectText);
							event.target.removeEventListener(TimerEvent.TIMER, timeTick);
						});
					timer.start();
				}
			}
		}
	}
}