package{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	
	public class Main extends Sprite{			
		private var displayTitleMenu:Title_Menu_Class = new Title_Menu_Class();
		private var levelMain:Level_Class = new Level_Class();
		
		public function Main():void{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, update);
			addChild(displayTitleMenu);
		}
		
		private function update(event:Event):void{
			displayTitleMenu.update();
		}
	}
}