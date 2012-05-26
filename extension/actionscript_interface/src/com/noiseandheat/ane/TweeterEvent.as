package com.noiseandheat.ane
{
	import flash.events.Event;
	
	// These events are used to indicate when the user has finished
	// sending a tweet, or if they cancel the dialog.
	public class TweeterEvent extends Event
	{
		public static const COMPLETE:String = "TweeterEvent::COMPLETE";
		public static const CANCEL:String = "TweeterEvent::CANCEL";
		
		public function TweeterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}