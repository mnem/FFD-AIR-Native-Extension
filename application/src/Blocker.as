package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class Blocker extends Sprite
	{
		protected var _message:TextField;
		
		public function Blocker()
		{
			mouseChildren = false;
			
			graphics.beginFill(0xffffff, 0.66);
			graphics.drawRect(0, 0, Paddles.gameWidth, Paddles.gameHeight);
			graphics.endFill();
			
			_message = new TextField();
			_message.text = "";
			_message.multiline = true;
			_message.wordWrap = true;
			_message.width = Paddles.gameWidth / 3 * 2;
			_message.height = Paddles.gameHeight;
			_message.x = Paddles.gameWidth / 3 / 2;
			
			var format:TextFormat = _message.defaultTextFormat;
			format.color = 0x000000;
			format.font = "Arial";
			format.bold = true;
			format.align = TextAlign.CENTER;
			format.size = Paddles.gameHeight / 10;
			_message.defaultTextFormat = format;
			
			addChild(_message);
		}
				
		public function setMessage(message:String):Blocker
		{
			_message.text = message || ""
			_message.y = (Paddles.gameHeight - _message.textHeight) / 2;
			
			return this;
		}
		
		public function setActive(active:Boolean):Blocker
		{
			visible = active;
			return this;
		}
	}
}