package code.menu {
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import code.Main;
	import code.misc.SoundControl;
	
	public class Credits {
		public var movieClip:Credits_mc;		
		private var enter:Boolean;
		
		var soundControl:SoundControl;
		var sfxMenuConfirm:SFXMenuConfirm;
		
		public function Credits(soundControl:SoundControl) {
			this.soundControl = soundControl;
			movieClip = new Credits_mc();
			
			sfxMenuConfirm = new SFXMenuConfirm();
			//initialize();
		}
		
		public function initialize():void{
			enter = false;
		}
		
		public function enterFrameHandler(event:Event):void{
			if(enter){
				soundControl.playSE(sfxMenuConfirm);
				Main.gameState = "enter mainmenu";
			}
		}
		
		public function keyDownHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.ENTER:
					enter = true;
					break;
				case Keyboard.ESCAPE:
					enter = true;
					break;
			}
		}
		
		public function keyUpHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.ENTER:
					enter = false;
					break;
				case Keyboard.ESCAPE:
					enter = false;
					break;
			}
		}
	}
}