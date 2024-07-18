package code.menu {
	import flash.display.MovieClip;
	import flash.events.Event;
	import code.misc.MenuAnimation03_mc;
	import code.misc.MenuAnimation02_mc;
	import flash.utils.getTimer;
	import code.misc.SoundControl;
	
	public class MenuAnimations {
		private var menuAnimations:Vector.<MovieClip>;
		public var currentAnimation:MovieClip;
		private var lastPlayedAnimationIndex:int;
		public var numAnimations:int;
		
		public var movieClip:MovieClip;
		private var animationState:String;
		private var timePassed:int;
		private var lastTime:int;
		
		var soundControl:SoundControl;
		var sfxMenuAnimation01:SFXMenuAnimation01;
		var sfxMenuAnimation05:SFXMenuAnimation05;
		
		public function MenuAnimations(soundControl:SoundControl) {			
			menuAnimations = new Vector.<MovieClip>();
			addAnimation(new MenuAnimation01_mc(), menuAnimations);
			addAnimation(new MenuAnimation02_mc(), menuAnimations);
			addAnimation(new MenuAnimation03_mc(), menuAnimations);
			addAnimation(new MenuAnimation04_mc(), menuAnimations);
			addAnimation(new MenuAnimation05_mc(), menuAnimations);
			
			lastPlayedAnimationIndex = -1;
			
			movieClip = new MovieClip();
			animationState = "start";
			timePassed = 0;
			lastTime = 0;
			
			this.soundControl = soundControl;
			sfxMenuAnimation01 = new SFXMenuAnimation01();
			sfxMenuAnimation05 = new SFXMenuAnimation05();
		}
		
		private function addAnimation(movieClip:MovieClip, movieClipsVector:Vector.<MovieClip>):void{
			movieClipsVector.push(movieClip);
			numAnimations++;
		}
		
		public function startAnimation(choice:int):void{
			menuAnimations[choice].gotoAndPlay(1);
			lastPlayedAnimationIndex = choice;
			currentAnimation = menuAnimations[choice];
			movieClip.addChild(currentAnimation);
		}
		
		public function startRandomAnimation():void{
			do{
				var random:int = int(Math.random() * numAnimations);
			}while(random == lastPlayedAnimationIndex);
			if(random == 0 || random == 2 || random == 3){
				soundControl.playSE(sfxMenuAnimation01);
			}else if(random == 4){
				soundControl.playSE(sfxMenuAnimation05);
			}
			menuAnimations[random].gotoAndPlay(1);
			lastPlayedAnimationIndex = random;
			currentAnimation = menuAnimations[random];
			movieClip.addChild(currentAnimation);
		}
		
		public function hasAnimationEnded(movieClip:MovieClip):Boolean{			
			if(movieClip.currentFrame >= movieClip.totalFrames){
				return true;
			}else{
				return false;
			}
		}
		
		public function clearAllAnimation():void{
			for(var i:int=0; i<movieClip.numChildren; i++){
				movieClip.removeChild(movieClip.getChildAt(i));
			}
			currentAnimation = null;
			timePassed = lastTime = 0;
		}
		
		private function clearAnimationOnEnd():void{
			if(currentAnimation != null && hasAnimationEnded(currentAnimation) && movieClip.contains(currentAnimation)){
				movieClip.removeChild(currentAnimation);
				currentAnimation = null;				
				timePassed = lastTime = 0;
			}
		}
		
		public function enterFrameHandler(event:Event):void{
			if(lastTime == 0){
				lastTime = getTimer();
			}
			if(currentAnimation != null && !hasAnimationEnded(currentAnimation)){
				lastTime = getTimer();
			}
			timePassed = getTimer() - lastTime;
			//trace("timePassed: "+timePassed);
			if(timePassed >= 9000){
				startRandomAnimation();
			}else if(timePassed >= 7000){
				if(Math.random() < 2/3 && animationState != "SECOND_TRY"){
					startRandomAnimation();
				}else{
					animationState = "SECOND_TRY";
				}
			}else if(timePassed >= 5000){
				if(Math.random() < 1/3 && animationState != "FIRST_TRY"){
					startRandomAnimation();
				}else{
					animationState = "FIRST_TRY";
				}
			}
			
			clearAnimationOnEnd();
		}
	}
}