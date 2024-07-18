package code.game {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	import code.menu.Pause;
	import code.menu.GameOver;
	import code.Main;
	import code.misc.SoundControl;
	
	public class Game {
		private var level:Level;
		private var player:Player;		
		private var pause:Pause;
		private var gameOver:GameOver;
		
		private const START_LEVEL:int = 1;
		public var lvl:int;		
		private var start:Boolean;
		
		public var movieClip:MovieClip;
		var soundControl:SoundControl;
		
		public function Game(screenWidth:int, screenHeight:int, soundControl:SoundControl) {
			this.soundControl = soundControl;
			level = new Level(screenWidth, screenHeight, soundControl);
			player = new Player(screenWidth, screenHeight);
			pause = new Pause(soundControl);
			gameOver = new GameOver(soundControl);
			
			movieClip = new MovieClip();
			lvl = START_LEVEL;
		}

		public function initialize(currentLevel:int):void{
			lvl = currentLevel;
			level.startLevel(lvl);
			player.initialize(level.movieClip.player_mc);
			level.initialize(player);
			
			for(var i:int=0; i<movieClip.numChildren; i++){
				movieClip.removeChildAt(i);
			}
			movieClip.addChild(level.movieClip);
		}
		
		public function enterFrameHandler(event:Event):void{
			if(Main.gameState == "game"){				
				if(start){
					Main.gameState = "enter pause";
					start = false;
				}if(!player.alive){
					Main.gameState = "enter gameover";
				}				
				player.enterFrameHandler(event);
				level.enterFrameHandler(event);
			}else if(Main.gameState == "enter pause"){
				player.pause();
				pause.initialize();
				movieClip.addChild(pause.movieClip);
				Main.gameState = "pause";
			}else if(Main.gameState == "pause"){
				pause.enterFrameHandler(event);
			}else if(Main.gameState == "resume game"){
				player.resume();				
				movieClip.removeChild(pause.movieClip);
				Main.gameState = "game";
			}else if(Main.gameState == "exit game"){
				lvl = START_LEVEL;
				clearGame(event);			
				Main.gameState = "enter mainmenu";
			}else if(Main.gameState == "enter gameover"){
				gameOver.initialize();
				movieClip.addChild(gameOver.movieClip);
				Main.gameState = "gameover";
			}else if(Main.gameState == "gameover"){
				gameOver.enterFrameHandler(event);
			}else if(Main.gameState == "restart game"){
				player.initialize(level.movieClip.player_mc);
				level.initialize(player);
				clearGame(event);
				Main.gameState = "game";
			}else if(Main.gameState == "next level"){
				lvl++;
				movieClip = new MovieClip();
				Main.gameState = "enter game";
				//Main.gameState = "change level";
			}
		}
		
		public function onColision(event:Event):void{
			if(Main.gameState == "game"){
				level.onColision(event);
				player.onColision(event);
			}
		}		
		
		private function clearGame(event:Event):void{
			if(movieClip.contains(pause.movieClip)){
				movieClip.removeChild(pause.movieClip);
			}if(movieClip.contains(gameOver.movieClip)){
				movieClip.removeChild(gameOver.movieClip);
			}
			soundControl.currentBGM.stop();
		}
		
		public function lostFocus(event:Event):void{
			Main.gameState = "enter pause";
		}
		
		public function keyDownHandler(event:KeyboardEvent):void{
			if(Main.gameState == "game"){
				if(event.keyCode == Keyboard.ESCAPE){
					start = true;
				}
				player.keyDownHandler(event);
			}else if(Main.gameState == "pause"){				
				pause.keyDownHandler(event);
			}else if(Main.gameState == "gameover"){
				gameOver.keyDownHandler(event);
			}
		}
		
		public function keyUpHandler(event:KeyboardEvent):void{
			if(Main.gameState == "game"){
				if(event.keyCode == Keyboard.ESCAPE){
					start = false;
				}
				player.keyUpHandler(event);
			}else if(Main.gameState == "pause"){
				pause.keyUpHandler(event);
			}else if(Main.gameState == "gameover"){
				gameOver.keyUpHandler(event);
			}
		}
	}
}