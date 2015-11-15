package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	
	public class Player_Class extends MovieClip{	
		public var Horizontal_Velocity:int = 10;								// Speed of the player, used for working out the momentum.
		public var Distance:int = (Horizontal_Velocity * Time_Unit_Seconds);	// The distance covered by the player.
		public var Time_Unit_Seconds:int = 0;													
		private var Run_Anim:MovieClip = new Super_Run_Animation();				
		private var Current_Anim:MovieClip = null;								
		
		public function Player_Class(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function playAnim(New_Anim:MovieClip):MovieClip{			
			if(Current_Anim != New_Anim){
				if (Current_Anim != null)
					removeChild(Current_Anim);
				
				Current_Anim = New_Anim;	
				addChild(Current_Anim);		
			}
			
			return Current_Anim;
		}
		
		public function update():void{		
			playAnim(Run_Anim);
		}
	}
}