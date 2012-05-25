package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;

	public class FlatButton extends Sprite
	{
		protected var buttonWidth:int = 160;
		protected var buttonHeight:int = 90;
		
		protected var _textfield:TextField;
		protected var _color:uint;
		protected var _clickHandler:Function;
		protected var _enabled:Boolean;
		
		protected var _visuals:Sprite;
		
		public function FlatButton()
		{
			mouseChildren = false;
			
			buttonWidth = Paddles.gameWidth / 6;
			buttonHeight = buttonWidth * 0.5625;
			
			_visuals = new Sprite();
			_visuals.x = -buttonWidth / 2;
			_visuals.y = -buttonHeight / 2;
			
			_textfield = new TextField();
			_textfield.text = "";
			_textfield.multiline = false;
			_textfield.width = buttonWidth;
			_textfield.height = buttonHeight / 3;
			
			var format:TextFormat = _textfield.defaultTextFormat;
			format.color = 0xffffff;
			format.font = "Arial";
			format.align = TextAlign.CENTER;
			format.size = buttonHeight / 3;
			_textfield.defaultTextFormat = format;
			
			_visuals.addChild(_textfield);
			
			_color = 0xffffff;
			
			setClickHandler(NOOP);
			
			setEnabled(true);
			draw();
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			addChild(_visuals);
		}
		
		public function setEnabled(enabled:Boolean):FlatButton
		{
			_enabled = enabled;
			buttonMode = _enabled;
			if (_enabled)
			{
				alpha = 1.0;
			}
			else
			{
				alpha = 0.2;
			}
			
			return this;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if (_enabled)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_clickHandler(this);
				draw();
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if (_enabled)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				draw(true);
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			draw();
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			draw(true);
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			draw();
		}
		
		protected function NOOP(...ignored):void
		{
			// No operation;
		}
		
		protected function draw(down:Boolean = false):void
		{
			const shadowOffset:int = 3;
			const buttonOffset:int = down ? shadowOffset : 0;
			var g:Graphics = _visuals.graphics;
			
			g.clear();
			
			if (!down)
			{
				g.beginFill(0xffffff, 0.8);
				g.drawRect(shadowOffset, shadowOffset, buttonWidth, buttonHeight);
				g.endFill();
			}
			
			g.beginFill(_color, 1);
			g.drawRect(buttonOffset, buttonOffset, buttonWidth, buttonHeight);
			g.endFill();
			
			_textfield.x = buttonOffset;
			_textfield.y = (buttonHeight - _textfield.textHeight) / 2 + buttonOffset;
			_textfield.height = buttonHeight - _textfield.y;
		}
		
		public function setColor(color:uint):FlatButton
		{
			_color = color;
			draw();
			
			return this;
		}
		
		public function setText(text:String):FlatButton
		{
			_textfield.text = text || "";
			draw();
			
			return this;
		}
		
		public function setClickHandler(handler:Function):FlatButton
		{
			_clickHandler = handler || NOOP;
			
			return this;
		}
		
		public function setPosition(x:Number, y:Number):FlatButton
		{
			this.x = x;
			this.y = y;
			
			return this;
		}

	}
}