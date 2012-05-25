package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Bat extends Sprite
	{
		protected var _color:uint;
		
		public function Bat()
		{
			_color = 0x000000;
			draw();
		}
		
		public function setPosition(x:Number, y:Number):Bat
		{
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function setColor(color:uint):Bat
		{
			_color = color;
			draw();
			
			return this;
		}
		
		protected function draw():void
		{
			const width:int = Paddles.gameWidth / 48;
			const height:int = Paddles.gameHeight / 6.4;
			
			graphics.beginFill(_color);
			graphics.drawRect(-width/2,-height/2, width, height);
			graphics.endFill();
		}
	}
}