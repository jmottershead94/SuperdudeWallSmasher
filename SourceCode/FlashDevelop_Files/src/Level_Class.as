package{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Jason Mottershead
	 */
	
	public class Level_Class extends MovieClip{		
		[Embed(source="Resources/Collapsing_Wall.mp3")]
		private var MySound:Class;
		private var sound:Sound;
		private var gameLevel:Game_Level = new Game_Level();						// To display the GAME LEVEL elements.
		private var player:Player_Class = new Player_Class();						
		private var playerMomentum:Momentum_Bar_Class = new Momentum_Bar_Class();	
		private var wall:Wall_Class = new Wall_Class();								
		private var finishLevel:Complete_Level_Screen = new Complete_Level_Screen();
		private var restartLevel:Restart_Game_Button = new Restart_Game_Button();
		private var returnToMenu:Restart_Main_Menu_Button = new Restart_Main_Menu_Button();
		private var levelBG:Level_Background = new Level_Background();
		private var levelHills:Hilltops = new Hilltops();
		private var checkRestart:Boolean = false;
		private var highScore:Number = 0;											
		private var distanceOutput:TextField = new TextField();						
		private var finalDistanceOutput:TextField = new TextField();				
		private var highScoreOutput:TextField = new TextField();					
		private var levelVarVisibilty:Boolean = false;								
		private var finishFeaturesVisibilty:Boolean = false;						
		private var framesNumberLvl:Number = 0;										
		private var startTimeLvl:Number = getTimer();								
		private var normalWall:MovieClip = new Wall();								
		private var breakingWall:MovieClip = new Breaking_Wall();					
		private var groundFloor:MovieClip = new Ground2();							
		private var wallArray:Array = new Array(); 									
		private const NUM_WALLS_TO_CREATE:int = 2;
		
		public function Level_Class(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}	
		
		private function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, hitWall);
			restartLevel.addEventListener(MouseEvent.CLICK, clickrestartButton);
			
			player.Distance = 0;
			player.Horizontal_Velocity = 10;	// Resets any momentum bar changes from the controls screen tutorial.
			framesNumberLvl = 0;
			checkRestart = false;
			
			addChild(levelBG);
			levelHills.y = 200;
			addChild(levelHills);
			groundFloor.x = 8.55;
			groundFloor.y = 400;
			addChild(groundFloor);				
			
			initialiseWalls();					
			
			// Added after the wall so that the bar can be seen on top of the wall when it is scrolling by.
			playerMomentum.x = 31;
			playerMomentum.y = 19;
			addChild(playerMomentum);			
			player.x = 55;
			player.y = -50;
			addChild(player);					

			levelVisibilty(true);
		}
		
		private function GameOver():void{			
			levelVisibilty(false);
			
			addChild(finishLevel);
			restartLevel.x = 150;
			restartLevel.y = 520;
			addChild(restartLevel);
			finalDistanceOutput.x = 235;
			finalDistanceOutput.y = 162;
			finalDistanceOutput.text = player.Distance + "m"; 
			addChild(finalDistanceOutput);
			highScoreOutput.x = 235;
			highScoreOutput.y = 208;
			highScoreOutput.text = highScore + "m"; 
			addChild(highScoreOutput);
			
			finishLevelVisibilty(true);
		}
		// Adjust the visibility of the level features.
		private function levelVisibilty(levelVarVisibilty):void{	
			playerMomentum.visible = levelVarVisibilty;
			player.visible = levelVarVisibilty;
			groundFloor.visible = levelVarVisibilty;
			wall.visible = levelVarVisibilty;
			distanceOutput.visible = levelVarVisibilty;
			levelBG.visible = levelVarVisibilty;
			levelHills.visible = levelVarVisibilty;
		}
		
		private function finishLevelVisibilty(finishFeaturesVisibilty):void{
			finishLevel.visible = finishFeaturesVisibilty;
			restartLevel.visible = finishFeaturesVisibilty;
			returnToMenu.visible = finishFeaturesVisibilty;
			finalDistanceOutput.visible = finishFeaturesVisibilty;
			highScoreOutput.visible = finishFeaturesVisibilty;
		}
		
		private function clickrestartButton(event:MouseEvent):void{
			checkRestart = true;
			// Reset the level attributes.
			player.Distance = 0;					
			playerMomentum.clickCounter = 0;
			wall.playerV.Horizontal_Velocity = 10;
			framesNumberLvl = 0;
			// Restarts the game.
			playerMomentum.playAnim(playerMomentum.emptyMomenBar);
			finishLevelVisibilty(false);
			levelVisibilty(true);
			initialiseWalls();
		}
	
		private function hitWall(e:Event):void{
			var currentTimeLvl:Number = (getTimer() - startTimeLvl) / 1000;								// Works out current time in milliseconds.
			var frameCounterLvl:uint = (Math.floor((framesNumberLvl/currentTimeLvl)*10.0)/10.0);		// Works out the frames per second.
			var desiredFrameLim:int;
			
			if (checkRestart == true)
				desiredFrameLim = 130;
			else 
				desiredFrameLim = 85;
			
			if ((framesNumberLvl % desiredFrameLim) == 0){
				framesNumberLvl = 0;
				
				if (playerMomentum.clickCounter > 6){
					sound = new MySound;
					sound.play();							// Play sound effect for a collapsing wall.
					playerMomentum.clickCounter -= 6;		// Takes 3 bars off momentum.
				}
				else if (playerMomentum.clickCounter > 1)
					playerMomentum.clickCounter--;
				else
					wall.playerV.Horizontal_Velocity = 0;
				
				if ((playerMomentum.fullMomentumAnim).currentFrame < 43){
					for (var k:int = (playerMomentum.clickCounter); k < ((playerMomentum.fullMomentumAnim).currentFrame + 1); k += (playerMomentum.clickCounter + 1)){
						(playerMomentum.fullMomentumAnim).gotoAndPlay(k);			
						playerMomentum.playAnim(playerMomentum.fullMomentumAnim);
					}
				}
				else{
					playerMomentum.gotoFrame(43);									// Otherwise, play the empty momentum bar frame.
					playerMomentum.playAnim(playerMomentum.fullMomentumAnim);
				}
			}
		}
		
		private function initialiseWalls():void{					// Adds the walls into the array when they are spawned.
			for (var i:int = 0; i < NUM_WALLS_TO_CREATE; i++){
				if (i == 0)
				{}
				else
					wallArray.push(spawnWall());					// Creates wall and pushes them into the array.
			}
		}
		
		private function spawnWall():MovieClip{
			addChild(wall);
			return (wall);
		}
		
		public function update():void{					
			var timeSeconds:Number = (getTimer() - startTimeLvl);
			framesNumberLvl++;
			
			distanceOutput.x = 500;
			distanceOutput.y = 10;
			distanceOutput.text = "Distance: " + player.Distance + "m";
			addChild(distanceOutput);
			
			playerMomentum.update();					
			player.update();
			wall.update();
			
			for (var i:int = 0; i < 1; i++){							
				if (player.hitTestObject(wall)){
					breakingWall.x = (wall.wallObj).x;	// Lines the animations up correctly.
					breakingWall.y = (wall.wallObj).y;
					wall.playAnim(breakingWall);
				}
				
				breakingWall.gotoAndStop(3);
			}
			
			if (wall.playerV.Horizontal_Velocity != 0)
				player.Distance++;
			else if (wall.playerV.Horizontal_Velocity == 0){
				if (player.Distance >= highScore)
					highScore = player.Distance;
				
				GameOver();
			}
		}
	}
}