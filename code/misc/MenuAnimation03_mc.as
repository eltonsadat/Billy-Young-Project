package code.misc {	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
		
	public class MenuAnimation03_mc extends MovieClip {
		private const FIRST_CYCLE:int = 2000;
		private const SECOND_CYCLE:int = 3500;
		private const THIRD_CYCLE:int = 5000;
		
		private var timer:Timer;
		private var timeElapsed:int;
		private var animationState:String;
				
		public function MenuAnimation03_mc() {
			timer = new Timer(500);
			
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function timerHandler(event:TimerEvent):void{
			timeElapsed += Timer(event.target).delay;
			
			if(timeElapsed >= THIRD_CYCLE){
				this.gotoAndPlay("stand");
				animationState = "playing_end";
				timer.stop();
			}else if(timeElapsed >= SECOND_CYCLE){
				if(Math.random() < 2/3 && animationState != "second_try"){
					this.gotoAndPlay("stand");
					animationState = "playing_end";
					timer.stop();
				}else{
					animationState = "second_try";
				}
			}else if(timeElapsed >= FIRST_CYCLE){
				if(Math.random() < 1/3 && animationState != "first_try"){
					this.gotoAndPlay("stand");
					animationState = "playing_end";
					timer.stop();
				}else{
					animationState = "first_try";
				}
			}
		}
		
		private function enterFrameHandler(event:Event):void{
			if(this.currentLabel == "stand" && animationState == "playing_begin"){
				this.gotoAndStop("stand");
				animationState = "stopped";
				timer.start();
			}
		}
		
		private function addedHandler(event:Event):void{
			timeElapsed = 0;
			animationState = "playing_begin";
		}
	}
}