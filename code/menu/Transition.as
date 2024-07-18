package code.menu {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.sampler.getLexicalScopes;
	import code.misc.SoundControl;
	
	public class Transition {		
		private var dobra:Dobra_mc;
		private var newScreen:DisplayObject;
		private var oldScreen:DisplayObject;
		
		private var inReverse:Boolean;
		private var finalState:String;
		public var state:String;
		private var animLoop:Boolean;

		var soundControl:SoundControl;
		var sfxTransition:SFXTransition;

		public function Transition(soundControl:SoundControl) {
			this.soundControl = soundControl;
			
			dobra = new Dobra_mc();
			sfxTransition = new SFXTransition();
		}
		
		public function animateTransition(stage:Stage, newScreen:DisplayObject, oldScreen:DisplayObject, finalState:String, inReverse:Boolean=false):void{
			this.newScreen = newScreen;
			this.oldScreen = oldScreen;
			
			this.inReverse = inReverse;
			this.finalState = finalState;
			state = "transition";
			animLoop = false;
			
			soundControl.playSE(sfxTransition);
			if(inReverse){
				stage.addChildAt(oldScreen, 1);
				stage.addChildAt(newScreen, 2);
				stage.addChildAt(dobra, 3);
				
				dobra.gotoAndStop(dobra.totalFrames);
				newScreen.mask = dobra.getChildAt(1);
			}else{				
				stage.addChildAt(newScreen, 1);
				stage.addChildAt(oldScreen, 2);
				stage.addChildAt(dobra, 3);
				
				dobra.gotoAndPlay(1);
				oldScreen.mask = dobra.getChildAt(1);
			}
		}
		
		public function enterFrameHandler(event:Event):void{
			if(inReverse){
				if(dobra.currentFrame > 1){
					dobra.prevFrame();
					newScreen.mask = dobra.getChildAt(1);
				}else{
					dobra.gotoAndStop(1);
					//newScreen.parent.removeChild(newScreen);
					oldScreen.parent.removeChild(oldScreen);
					dobra.parent.removeChild(dobra);
					
					newScreen.parent.setChildIndex(newScreen, 1);
					newScreen.mask = null;
					state = finalState;
				}
			}else{
				if(dobra.currentFrame < dobra.totalFrames){					
					if(animLoop){
						dobra.gotoAndStop(1);
						//newScreen.parent.removeChild(newScreen);
						oldScreen.parent.removeChild(oldScreen);
						dobra.parent.removeChild(dobra);
						
						newScreen.parent.setChildIndex(newScreen, 1);
						oldScreen.mask = null;
						state = finalState;
					}else{
						oldScreen.mask = dobra.getChildAt(1);
					}
				}else{
					animLoop = true;
				}
			}
		}
	}
}