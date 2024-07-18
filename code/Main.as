package code{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.DisplayObject;
	
	import code.game.*;
	import code.menu.*;
	import code.misc.*;
	import flash.utils.getQualifiedClassName;
		
	public class Main extends MovieClip{
		private var soundControl:SoundControl;
		private var load:Load;
		private var mainMenu:MainMenu;
		private var credits:Credits;
		private var game:Game;
		private var menuAnimations:MenuAnimations;
		private var transition:Transition;
		
		public static var gameState:String = "loading";
		
		public function Main(){
			gotoAndStop(1);
			stage.addChildAt(load_mc, 1);
			load = new Load(Load_mc(stage.getChildAt(1)), stage);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.ENTER_FRAME, onColision);
			stage.addEventListener(Event.DEACTIVATE, lostFocus);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function initialize():void{
			gotoAndStop(2);
			
			soundControl = new SoundControl();
			mainMenu = new MainMenu(soundControl);
			credits = new Credits(soundControl);
			game = new Game(stage.stageWidth, stage.stageHeight, soundControl);
			menuAnimations = new MenuAnimations(soundControl);
			transition = new Transition(soundControl);
		}
		
		private function enterFrameHandler(event:Event):void{
			if(Main.gameState == "loading"){
				load.enterFrameHandler(event);
			}else if(Main.gameState == "load finished"){
				initialize();
				mainMenu.initialize();
				changeMovieClip(mainMenu.movieClip, "mainmenu");
				stage.addChild(menuAnimations.movieClip);
				Main.gameState = "transition";
			}else if(Main.gameState == "enter mainmenu"){
				mainMenu.initialize();
				menuAnimations.clearAllAnimation();
				changeMovieClip(mainMenu.movieClip, "mainmenu", true);
				Main.gameState = "transition";
			}else if(Main.gameState == "mainmenu"){
				menuAnimations.enterFrameHandler(event);
				mainMenu.enterFrameHandler(event);
			}else if(Main.gameState == "enter credits"){
				credits.initialize();
				menuAnimations.clearAllAnimation();
				changeMovieClip(credits.movieClip, "credits");
				Main.gameState = "transition";
			}else if(Main.gameState == "credits"){
				menuAnimations.enterFrameHandler(event);
				credits.enterFrameHandler(event);
			}else if(Main.gameState == "enter game"){
				game.initialize(game.lvl);
				menuAnimations.clearAllAnimation();
				changeMovieClip(game.movieClip, "game");
				Main.gameState = "transition";
			}else if(Main.gameState == "transition"){
				transition.enterFrameHandler(event);
				Main.gameState = transition.state;
			}else{
				game.enterFrameHandler(event);
			}
		}
		
		private function onColision(event:Event):void{
			if(Main.gameState == "game"){
				game.onColision(event);
			}
		}
		
		private function lostFocus(event:Event):void{
			if(Main.gameState == "game"){
				game.lostFocus(event);
			}
		}
		
		private function changeMovieClip(target:DisplayObject, finalState:String, inReverse:Boolean=false):void{
			transition.animateTransition(stage, target, stage.getChildAt(1), finalState, inReverse);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			if(Main.gameState == "mainmenu"){
				mainMenu.keyDownHandler(event);
			}else if(Main.gameState == "credits"){
				credits.keyDownHandler(event);
			}else{
				game.keyDownHandler(event);
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void{
			if(Main.gameState == "mainmenu"){
				mainMenu.keyUpHandler(event);
			}else if(Main.gameState == "credits"){
				credits.keyUpHandler(event);
			}else{
				game.keyUpHandler(event);
			}
		}
	}
}