package{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	
	public class Title_Menu_Class extends MovieClip{
		// Title screen variables.
		private var titleScreen:Title_Menuv2 = new Title_Menuv2();							// Access the TITLE SCREEN variables.
		private var startButton:Start_Game_Button = new Start_Game_Button();				
		private var level:Level_Class = new Level_Class();									
		private var controlButton:Controls = new Controls();								
		// Control page variables
		public var controlPageDetection:Boolean = false;									// Check if the user is ON THE CONTROLS PAGE or not.
		private var controlPage:Controls_Page = new Controls_Page();						
		private var returnMenuButton:Return_MainMenu_Button = new Return_MainMenu_Button();	
		private var tutorialMomenBar:Momentum_Bar_Class = new Momentum_Bar_Class();
		
		public function Title_Menu_Class(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
	
			startButton.addEventListener(MouseEvent.CLICK, clickstartButton);
			controlButton.addEventListener(MouseEvent.CLICK, clickcontrolButton);
			returnMenuButton.addEventListener(MouseEvent.CLICK, clickreturnMenuButton);
			
			controlPageDetection = false;
			
			addChild(titleScreen);									
			startButton.x = 421.45;													
			startButton.y = 221.05;
			addChild(startButton);
			controlButton.x = 432.45;												
			controlButton.y = 224.10;
			addChild(controlButton);
		}
		
		private function titleScreenDisplay(titleVisibilty:Boolean):void{
			titleScreen.visible = titleVisibilty;
			startButton.visible = titleVisibilty;			
			controlButton.visible = titleVisibilty;			
		}
		
		private function controlScreenDisplay(controlVisibilty):void{
			controlPage.visible = controlVisibilty;
			returnMenuButton.visible = controlVisibilty;
			tutorialMomenBar.visible = controlVisibilty;
		}
		
		private function clickstartButton(event:MouseEvent):void{
			controlPageDetection = false;
			titleScreenDisplay(false);			// Hides all of the title screen features.
			addChild(level);
		}
		
		private function clickcontrolButton(event:MouseEvent):void{									
			titleScreenDisplay(false);
			controlScreenDisplay(true);			// Shows all of the control page features.
			
			returnMenuButton.x = 150;				
			returnMenuButton.y = 500;
			addChild(returnMenuButton);
			addChild(controlPage);
			addChild(tutorialMomenBar);

			controlPageDetection = true;		// The user is on the controls page.
		}
		
		private function clickreturnMenuButton(event:MouseEvent):void{
			controlPageDetection = false;		// User is no longer on the controls page.
			
			controlScreenDisplay(false);
			titleScreenDisplay(true);
			
			addChild(titleScreen);
			addChild(startButton);
			addChild(controlButton);
		}
		
		public function update():void{		
			if (controlPageDetection == true)
				tutorialMomenBar.update();
			
			level.update();
		}
	}
}