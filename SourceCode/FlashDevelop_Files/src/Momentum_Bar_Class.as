package{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	 
	public class Momentum_Bar_Class extends MovieClip{
		// Variables used in the level class.
		public var fullMomentumAnim:MovieClip = new MomentumBar_Anim();		
		public var emptyMomenBar:MovieClip = new Momentum_Bar();			
		public var clickCounter:int = 0;									
		// Variables used just in this class.
		private var playerVars:Player_Class = new Player_Class();
		private var wallAccess:Wall_Class = new Wall_Class();
		private var Current_Anim:MovieClip = null;							
		private var momentumClick:Boolean = false;							
		private var framesNumber:Number = 0;								
		private var startTime:Number = getTimer();
		private var frameNum:Number;										
		
		public function Momentum_Bar_Class(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);		
			addEventListener(MouseEvent.MOUSE_UP, onMouseUnclick);
			addEventListener(Event.ACTIVATE, gotoFrame);
		}	
		
		public function gotoFrame(frameNum:Number):void{
			fullMomentumAnim.gotoAndStop(frameNum);
		}
	
		private function onMouseClick(event:MouseEvent):void{			
			momentumClick = true;				
			clickCounter++;					
		}
		
		private function onMouseUnclick(e:MouseEvent):void{			
			momentumClick = false;
		}
		
		public function playAnim(New_Anim:MovieClip):void{			
			if(Current_Anim != New_Anim){
				if (Current_Anim != null)
					removeChild(Current_Anim);
				
				Current_Anim = New_Anim;		
				addChild(Current_Anim);
			}
		}
		
		public function update():void{											
			var currentTime:Number = (getTimer() - startTime) / 1000;						// Works out current time in milliseconds.
			var frameCounter:uint = (Math.floor((framesNumber/currentTime)*10.0)/10.0);		// Works out the frames per second.
			framesNumber++;																	
			
			playAnim(emptyMomenBar);														
			
			if (momentumClick == true){
				// Check to see if the current animation frame is less than the maximum frame for increasing the momentum bar.
				// Increments the frame number along as the user clicks.
				// (fullMomentumAnim.currentFrame + 2) because each animation frame is 2 frames long.
				// (clickCounter + 1) increments the frame number to the next animation frame.
				if (fullMomentumAnim.currentFrame < 22){																			
					for (var i:int = clickCounter; i < (fullMomentumAnim.currentFrame + 2); i += (clickCounter+1)){																								
						gotoFrame(i);					
						playAnim(fullMomentumAnim);											
					}
				}
				else{
					gotoFrame(22);				// Stop at the maximum bar frame.
					playAnim(fullMomentumAnim);
				}
			}
			// Takes off momentum over time.
			if ((framesNumber % 15) == 0){		
				framesNumber = 0;
				
				if (clickCounter > 2)
					clickCounter -= 2;														
				else if (clickCounter > 1){
					clickCounter--;
					wallAccess.playerV.Horizontal_Velocity = 0;
				}
				else
					wallAccess.playerV.Horizontal_Velocity = 0;
				
				if (fullMomentumAnim.currentFrame < 43){										
					for (var j:int = (clickCounter); j < (fullMomentumAnim.currentFrame + 1); j += (clickCounter + 1)){
						fullMomentumAnim.gotoAndPlay(j);
						playAnim(fullMomentumAnim);
					}
				}
				else{
					gotoFrame(43);				// Otherwise, play the empty momentum bar frame.
					playAnim(fullMomentumAnim);
				}
			}
		}
	}
}