package com.noiseandheat.ane
{
	import flash.events.Event;
	
	// These events are used to pass error information through the extension
	// to the ActionScript application using it.
	public class TweeterErrorEvent extends Event
	{
		public static const ERROR:String = "TweeterErrorEvent::ERROR";
		
		protected var _message:String;
		
		public function TweeterErrorEvent(type:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_message = message;
		}

		public function get message():String
		{
			return _message;
		}

		override public function clone():Event
		{
			return new TweeterErrorEvent(type, _message, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("TweeterErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
		
	}
}