package code.menu {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import code.Main;
	import code.misc.SoundControl;
	
	public class Pause {
		public var movieClip:Pause_mc;
		
		private var selection:int;
		private var options:int;
				
		private var enter:Boolean;
		private var back:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		private var hold:Boolean;
		
		private var state:String;
		private var choice:String;
		
		var soundControl:SoundControl;		
		var sfxMenuConfirm:SFXMenuConfirm;
		var sfxMenuSelection:SFXMenuSelection;
		var sfxDialogTransition:SFXDialogTransition;
		
		public function Pause(soundControl:SoundControl) {
			this.soundControl = soundControl;
			movieClip = new Pause_mc();
			
			sfxMenuConfirm = new SFXMenuConfirm();
			sfxMenuSelection = new SFXMenuSelection();
			sfxDialogTransition = new SFXDialogTransition();
		}
		
		public function initialize():void{
			soundControl.playSE(sfxDialogTransition);
			movieClip.gotoAndPlay(1);
			state = "entrace";
		}
		
		private function ready(stopLabel:String):void{
			soundControl.currentSE.stop();
			movieClip.gotoAndStop(stopLabel);
			selection = 0;
			enter = up = down = false;
			options = movieClip.optionsContainer.numChildren;
			relocateSelector();
			
			state = "ready";
		}
		
		private function exit(toWhere:String):void{
			soundControl.playSE(sfxDialogTransition);
			movieClip.play();
			choice = toWhere;
			
			state = "exit";
		}
		
		public function enterFrameHandler(event:Event):void{
			if(state == "entrace"){
				if(movieClip.currentLabel == "stand"){
					ready("stand");
				}
			}else if(state == "ready"){
				if(!enter){
					hold = false;
				}
				
				if((enter && selection == 0 && !hold) || back){					
					soundControl.playSE(sfxMenuConfirm);
					hold = true;
					exit("resume game");
				}if(enter && selection == 1 && !hold){
					soundControl.playSE(sfxMenuConfirm);
					hold = true;
					exit("exit game");
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
			}else if(state == "exit"){
				if(movieClip.currentFrame >= movieClip.totalFrames){
					soundControl.currentSE.stop();
					Main.gameState = choice;
				}
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
				case Keyboard.ESCAPE:
					back = true;
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
				case Keyboard.ESCAPE:
					back = false;
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