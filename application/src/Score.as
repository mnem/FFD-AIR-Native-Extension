package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class Score extends Sprite
	{
		protected var _score:uint;
		protected var _display:TextField;
		
		public function Score()
		{
			mouseChildren = false;
			mouseEnabled = false;
			
			_display = new TextField();
			_display.text = "";
			_display.mouseEnabled = false;
			_display.multiline = false;
			_display.width = Paddles.gameWidth;
			
			var format:TextFormat = _display.defaultTextFormat;
			format.color = 0xE9E63D;
			format.font = "Arial";
			format.bold = true;
			format.align = TextAlign.CENTER;
			format.size = Paddles.gameHeight / 16;
			_display.defaultTextFormat = format;
			
			addChild(_display);
			
			reset();
		}
		
		public function setPosition(x:Number, y:Number):Score
		{
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function add():Score
		{
			_score += 131;
			_display.text = _score.toString();
			return this;
		}
		
		public function reset():Score
		{
			_score = 0;
			_display.text = _score.toString();
			return this;
		}

		public function get score():uint
		{
			return _score;
		}

	}
}