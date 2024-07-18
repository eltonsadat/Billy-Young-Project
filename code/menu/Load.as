package code.menu {
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import code.Main;
	
	public class Load {
		public var movieClip:Load_mc
		private var mainStage:Stage;
		
		private var bytesLoaded:Number;
		private var bytesTotal:Number;
		private var initialBytes:Number;
		
		private var lastTime:int;

		public function Load(load_mc:Load_mc, mainStage:Stage) {
			movieClip = load_mc;
			this.mainStage = mainStage;
			
			movieClip.gotoAndStop(1);
			movieClip.loadTitle.gotoAndStop(1);
			bytesTotal=mainStage.loaderInfo.bytesTotal/1024;
			initialBytes=0;
			
			lastTime = getTimer();
		}
		
		public function enterFrameHandler(event:Event):void{
			bytesLoaded=mainStage.loaderInfo.bytesLoaded/1024;
			if(initialBytes==0){
				initialBytes=bytesLoaded;
			}
			
			if(getTimer() - lastTime >= 1000){
				dotAnimation();
				lastTime = getTimer();
			}
			
			if(bytesLoaded >= bytesTotal){
				movieClip.loadTitle.gotoAndStop(movieClip.loadTitle.totalFrames);
				movieClip.gotoAndStop(100);
				
				Main.gameState = "load finished";
			}else{				
				movieClip.gotoAndStop(int((bytesLoaded-initialBytes)/(bytesTotal-initialBytes)*100));
			}
		}
		
		private function dotAnimation():void{
			var index:int = movieClip.loadTitle.currentFrame;
			if(index + 1 <= movieClip.loadTitle.totalFrames){
				index++;
			}else{
				index = 1;
			}
			movieClip.loadTitle.gotoAndStop(index);
		}
	}
}