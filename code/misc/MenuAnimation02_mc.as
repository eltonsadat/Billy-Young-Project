package code.misc {	
	import flash.display.MovieClip;	
	import flash.events.Event;
	
	public class MenuAnimation02_mc extends MovieClip {
		private const MAX_HEIGHT:int = 120;
		
		public function MenuAnimation02_mc() {			
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);			
		}
		
		private function addedHandler(event:Event):void{
			this.y = Math.random() * (stage.stageHeight - MAX_HEIGHT);
		}
	}
}