package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Ball extends Sprite
	{
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _color:uint;
		
		public function Ball()
		{
			_vx = 0;
			_vy = 0;
			_color = 0x0000ff;
			draw();
		}
		
		public function setPosition(x:Number, y:Number):Ball
		{
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function setVelocity(vx:Number, vy:Number):Ball
		{
			_vx = vx;
			_vy = vy;
			
			return this;
		}
		
		public function setColor(color:uint):Ball
		{
			_color = color;
			draw();
			
			return this;
		}
		
		protected function draw():void
		{
			const size:int = Paddles.gameWidth / 20;
			
			graphics.beginFill(_color);
			graphics.drawRect(-size / 2, -size / 2, size, size);
			graphics.endFill();
		}

		public function get vx():Number
		{
			return _vx;
		}
		
		public function set vx(vx:Number):void
		{
			_vx = vx;
		}

		public function get vy():Number
		{
			return _vy;
		}
		
		public function set vy(vy:Number):void
		{
			_vy = vy;
		}
	}
}