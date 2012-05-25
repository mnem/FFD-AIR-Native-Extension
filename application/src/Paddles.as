package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	[SWF(frameRate="60", backgroundColor="#000000")]
	public class Paddles extends Sprite
	{
		// Gameplay pieces
		protected var player:Bat;
		protected var cpu:Bat;
		protected var bigball:Ball;
		
		// UI pieces
		protected var startButton:FlatButton;
		protected var replayButton:FlatButton;
		protected var boastButton:FlatButton;
		protected var score:Score;
		protected var blocker:Blocker;
		
		// Game data
		protected var ballVelocity:Number;
		protected var lastUpdate:int;

		// Storing a static reference to the stage
		// as a convience for other classes to
		// query the screen dimensions
		protected static var staticStage:Stage;
		
		public function Paddles()
		{
			// Although this is a lanscape game, we
			// want to support autoOrients so that the user can choose
			// which way around to have the landscape screen
			staticStage = stage;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onStageRotation);
			
			// Setup the inital screen
			addGamePieces();
			addUI();
		}
		
		// Capturing this event will allow us to prevent the rotation
		// if it isn't moving to a landscape mode. On iOS devices, 
		// ROTATED_LEFT and ROTATED_RIGHT will be landscape.
		protected function onStageRotation(event:StageOrientationEvent):void
		{
			if(event.afterOrientation != StageOrientation.ROTATED_LEFT &&
				event.afterOrientation != StageOrientation.ROTATED_RIGHT)
			{
				event.preventDefault();
			}
		}
		
		// Convienience function to allow other classes to get the
		// game area extents
		public static function get gameWidth():Number
		{
			// HACK to make the game work in the FlashBuilder simulator. 
			// Although we request that we startup in landscape, the simulator
			// in FlashBuilder doesn't currently respect that.
			if (staticStage.fullScreenWidth > staticStage.fullScreenHeight)
			{
				return staticStage.fullScreenWidth;
			}
			else
			{
				return staticStage.fullScreenHeight;
			}
		}
		
		public static function get gameHeight():Number
		{
			// HACK to make the game work in the FlashBuilder simulator. 
			// Although we request that we startup in landscape, the simulator
			// in FlashBuilder doesn't currently respect that.
			if (staticStage.fullScreenHeight < staticStage.fullScreenWidth)
			{
				return staticStage.fullScreenHeight;
			}
			else
			{
				return staticStage.fullScreenWidth;
			}
		}
		
		// Create and add the gameplay components
		protected function addGamePieces():void
		{
			player = new Bat()
				.setColor(0x00ff00)
				.setPosition(20, gameHeight / 2);
			
			cpu = new Bat()
				.setColor(0xff0000)
				.setPosition(gameWidth - 20, gameHeight / 2);
			
			ballVelocity = gameWidth / 2.4;
			
			bigball = new Ball()
				.setColor(0x42DDE9)
				.setPosition(gameWidth / 2, gameHeight / 2)
				.setVelocity(ballVelocity, ballVelocity);
			
			addChild(player);
			addChild(cpu);
			addChild(bigball);
		}
		
		// Create and add the game UI components
		protected function addUI():void
		{
			score = new Score()
				.setPosition(0, 10);

			startButton = new FlatButton()
				.setColor(0x5FB563)
				.setText("Play!")
				.setClickHandler(startClicked)
				.setPosition(gameWidth / 2, gameHeight / 2);
			
			replayButton = new FlatButton()
				.setColor(0x5FB563)
				.setText("Play again!")
				.setClickHandler(startClicked)
				.setPosition(gameWidth / 2, gameHeight / 3);
			
			boastButton = new FlatButton()
				.setColor(0x587BB5)
				.setText("Tweet!")
				.setClickHandler(boastClicked)
				.setPosition(gameWidth / 2, gameHeight / 3 * 2);
			
			setUIPreGame();
									
			blocker = new Blocker()
				.setMessage("This is where we will show the native tweet dialog")
				.setActive(false);
			blocker.addEventListener(MouseEvent.CLICK, blockerClick);

			addChild(score);
			addChild(startButton);
			addChild(replayButton);
			addChild(boastButton);
			addChild(blocker);
		}
		
		protected function blockerClick(event:MouseEvent):void
		{
			blocker.setActive(false);
			boastButton.setEnabled(false);
		}
		
		// Set the UI state for before the game
		protected function setUIPreGame():void
		{
			startButton.visible = true;
			replayButton.visible = false;
			boastButton.visible = false;
		}
		
		// Set the UI state for during the game
		protected function setUIGame():void
		{
			startButton.visible = false;
			replayButton.visible = false;
			boastButton.visible = false;
		}
		
		// Set the UI state for after the game
		protected function setUIPostGame():void
		{
			startButton.visible = false;
			replayButton.visible = true;
			boastButton
				.setEnabled(true)
				.visible = true;
		}
		
		// Start button click handler
		protected function startClicked(button:FlatButton):void
		{
			startGame();
		}
		
		// Boast button click handler
		protected function boastClicked(button:FlatButton):void
		{
			blocker.visible = true;
			// TODO: show native tweet extension
		}

		// Start the game
		protected function startGame():void
		{
			setUIGame();
			
			lastUpdate = getTimer();
			
			bigball
				.setPosition(gameWidth / 2, gameHeight / 2)
				.setVelocity(ballVelocity, ballVelocity)
				.visible = true;
			
			score.reset();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(Event.ENTER_FRAME, updateGame);
		}
		
		// Stop the game
		protected function stopGame():void
		{
			removeEventListener(Event.ENTER_FRAME, updateGame);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			bigball.visible = false;
			
			setUIPostGame();
		}
		
		// Move the player's paddle
		protected function onMouseMove(event:MouseEvent):void
		{
			// Only move if the mouse position is within bounds
			if (event.stageY > 0 && event.stageY < gameHeight)
			{
				player.y = event.stageY;
			}
		}
		
		// Main gameplay event loop
		protected function updateGame(event:Event):void
		{
			// Work out the elapsed time since the last update
			var now:int = getTimer();
			var secondsPassed:Number = now - lastUpdate;
			secondsPassed /= 1000;
			lastUpdate = now;
			
			// Update the ball
			bigball.setPosition(bigball.vx * secondsPassed + bigball.x, bigball.vy * secondsPassed + bigball.y);
			
			// Update the hardcore AI
			cpu.y = bigball.y;
			
			// Process collisions
			var cpuRect:Rectangle = cpu.getBounds(stage);
			var playerRect:Rectangle = player.getBounds(stage);
			var ballRect:Rectangle = bigball.getBounds(stage);
			
			// Paddle collisions
			if (ballRect.intersects(cpuRect))
			{
				bigball.vx *= -1;
				bigball.x = cpuRect.x - (bigball.width / 2);
			}
			
			if (ballRect.intersects(playerRect))
			{
				bigball.vx *= -1;
				bigball.x = playerRect.right + (bigball.width / 2);
				score.add();
			}
			
			// Boundary collisions
			if (bigball.y < 0 || bigball.y > gameHeight)
			{
				bigball.vy *= -1;
				
				if (bigball.y < 0) bigball.y = 0;
				if (bigball.y > gameHeight) bigball.y = gameHeight;
			}
			
			// Check game over
			if (bigball.x < 0 || bigball.x > gameWidth)
			{
				stopGame();
			}
		}
	}
}