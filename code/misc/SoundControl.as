package code.misc{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.events.Event;
	
	public class SoundControl{
		public var isSEMute:Boolean;
		public var isBGMMute:Boolean;
		
		public var currentSE:SoundChannel;
		public var currentBGM:SoundChannel;

		public var currentSfx:Sound;
		public var currentTrack:Sound;
		
		private var myStartTime:Number;
		private var myLoops:int; 
		private var mySndTransform:SoundTransform;
		
		public function SoundControl(isSEMute:Boolean = false, isBGMMute:Boolean = false){
			this.isSEMute=isSEMute;
			this.isBGMMute=isBGMMute;
		}

		public function playSE(sfx:Sound, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void{
			if(!isSEMute){
				currentSfx= sfx;
				currentSE = sfx.play(startTime, loops, sndTransform);
				if(loops < 0){
					myStartTime = startTime;
					myLoops = loops; 
					mySndTransform = sndTransform;
					currentSE.addEventListener(Event.SOUND_COMPLETE,
						function infiniteLoopSFX(event:Event):void{
							playSE(currentSfx, myStartTime, myLoops, mySndTransform);
							event.target.removeEventListener(Event.SOUND_COMPLETE, infiniteLoopSFX);
						}
					);
				}
			}
		}

		public function playBGM(track:Sound, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void{
			if(!isBGMMute){
				currentTrack = track;
				currentBGM = track.play(startTime, loops, sndTransform);
				if(loops < 0){
					myStartTime = startTime;
					myLoops = loops; 
					mySndTransform = sndTransform;
					currentBGM.addEventListener(Event.SOUND_COMPLETE,
						function infiniteLoopBGM(event:Event):void{
							playBGM(currentTrack, myStartTime, myLoops, mySndTransform);
							event.target.removeEventListener(Event.SOUND_COMPLETE, infiniteLoopBGM);
						}
					);
				}
			}
		}

		private function setSEPan(pan:Number):void {
			//trace("setPan: " + pan.toFixed(2));
			var transform:SoundTransform = currentSE.soundTransform;
		    	transform.pan = pan;
			currentSE.soundTransform = transform;
		}

        	private function setSEVolume(volume:Number):void {
	           	//trace("setVolume: " + volume.toFixed(2));
            		var transform:SoundTransform = currentSE.soundTransform;
            		transform.volume = volume;
			currentSE.soundTransform = transform;
        	}

		private function setBGMPan(pan:Number):void {
			//trace("setPan: " + pan.toFixed(2));
			var transform:SoundTransform = currentBGM.soundTransform;
		    	transform.pan = pan;
			currentBGM.soundTransform = transform;
		}

        	private function setBGMVolume(volume:Number):void {
	           	//trace("setVolume: " + volume.toFixed(2));
            		var transform:SoundTransform = currentBGM.soundTransform;
            		transform.volume = volume;
			currentBGM.soundTransform = transform;
        	}
		public function setSEMute(flag:Boolean):void{
			isSEMute=flag;
		}

		public function setBGMMute(flag:Boolean):void{
			isBGMMute=flag;
		}
	}
}
