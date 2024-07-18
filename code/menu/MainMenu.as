package code.menu {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import code.Main;
	import code.misc.SoundControl;
	
	public class MainMenu {
		public var movieClip:MainMenu_mc;
		
		private var selection:int;
		private var options:int;
				
		private var enter:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		private var hold:Boolean;
		
		var soundControl:SoundControl;
		var sfxMenuConfirm:SFXMenuConfirm;
		var sfxMenuSelection:SFXMenuSelection;
		var bgmMainMenu:BGMMainMenu;
		
		public function MainMenu(soundControl:SoundControl) {
			this.soundControl = soundControl;
			movieClip = new MainMenu_mc();			
			movieClip.optionsContainer.startBtn.gotoAndStop("stand");			
			options = movieClip.optionsContainer.numChildren;
			
			sfxMenuConfirm = new SFXMenuConfirm();
			sfxMenuSelection = new SFXMenuSelection();
			bgmMainMenu = new BGMMainMenu();
		}
		
		public function initialize():void{
			if(soundControl.currentTrack != bgmMainMenu){
				soundControl.playBGM(bgmMainMenu, 0, -1);
			}			
			selection = 0;
			enter = up = down = false;
			relocateSelector();
		}
		
		public function enterFrameHandler(event:Event):void{
			if(!enter){
				hold = false;
			}
			
			if(enter && selection == 0 && !hold){
				soundControl.playSE(sfxMenuConfirm);
				soundControl.currentBGM.stop();
				hold = true;
				Main.gameState = "enter game"				
			}if(enter && selection == 1 && !hold){
				soundControl.playSE(sfxMenuConfirm);
				hold = true;
				Main.gameState = "enter credits"
			}
			
			if(up && !down){
				soundControl.playSE(sfxMenuSelection);
				if(selection - 1 >= 0){
					selection--;
				}else{
					selection = options - 1;				
				}
				relocateSelector();
				up = false;
			}if(down && !up){
				soundControl.playSE(sfxMenuSelection);
				if(selection + 1 <= options - 1){
					selection++;
				}else{
					selection = 0;
				}
				relocateSelector();
				down = false;
			}
		}
		
		private function relocateSelector(){			
			movieClip.selector.y = movieClip.optionsContainer.y + movieClip.optionsContainer.getChildAt(selection).y + 
								  (movieClip.optionsContainer.getChildAt(selection).height - movieClip.selector.height)/2;
		}
		
		public function keyDownHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.ENTER:
					enter = true;
					break;
				case Keyboard.UP:
					up = true;
					break;
				case Keyboard.DOWN:
					down = true;
					break;
			}
		}
		
		public function keyUpHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.ENTER:
					enter = false;
					break;
				case Keyboard.UP:
					up = false;
					break;
				case Keyboard.DOWN:
					down = false;
					break;
			}
		}
	}	
}