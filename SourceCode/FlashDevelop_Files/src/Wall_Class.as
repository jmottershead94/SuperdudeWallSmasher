package{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	
	public class Wall_Class extends MovieClip{
		public var wallObj:MovieClip = new Wall();
		public var Current_Anim:MovieClip = null;
		public var playerV:Player_Class = new Player_Class();
		private var wallBreakingObj:MovieClip = new Breaking_Wall();
		
		public function Wall_Class(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			wallObj.x = 700;
			wallObj.y = 300;
		}
		
		public function playAnim(New_Anim:MovieClip):void{			
			if(Current_Anim != New_Anim){
				if (Current_Anim != null)
					removeChild(Current_Anim);
				
				Current_Anim = New_Anim;
				addChild(Current_Anim);	
			}
		}
		
		public function resetWall():void{
			wallObj.x = 700;
			wallObj.y = 240;
		}
		
		public function update():void{
			playAnim(wallObj);
			wallObj.x -= playerV.Horizontal_Velocity;	// The wall will move to the player, at the speed that the player is moving.
			
			if (wallObj.x < -600)						// If the wall is no longer visible on screen...
				resetWall();							// Reset the first wall to the spawn point.
		}
	}
}