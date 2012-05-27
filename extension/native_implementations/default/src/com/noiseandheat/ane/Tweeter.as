package com.noiseandheat.ane
{
	import flash.display.Sprite;

	// The extension class is extending EventDispatcher
	// so we can dispatch events for operations which
	// are asynchronous (in this case, the user
	// writing the tweet and sending it)
	public class Tweeter extends Sprite
	{
		// Make sure the compiler include the TweeterEvent class
		protected static const forceTweeterEventInclusion:TweeterEvent = null;

		// For the default platform it is generally good practice
		// to indicate that the native features aren't available.
		public static function get isSupported():Boolean
		{
			return false;
		}

		// This should never be called as we have indicated
		// it's not available on the default platform. However
		// we'll dispatch an error just to re-inforce that.
		public function tweet(coolMessage:String):void
		{
			dispatchEvent(new TweeterErrorEvent(TweeterErrorEvent.ERROR, "Tweeter unavailable"));
		}
	}
}
