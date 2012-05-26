package com.noiseandheat.ane
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	// The extension class is extending EventDispatcher
	// so we can dispatch events for operations which
	// are asynchronous (in this case, the user
	// writing the tweet and sending it)
	public class Tweeter extends EventDispatcher
	{
		// Constant for the extension ID. This is import to list in
		// the documentation for the extension as the applicaton using
		// it *must* register it in their app.xml file for packaging.
		public static const EXTENSION_ID:String = "com.noiseandheat.ane.Tweeter";
		
		// Constants for the native method names
		protected static const NM_IS_SUPPORTED:String = "NAH_Tweeter_isSupported";
		protected static const NM_TWEET:String = "NAH_Tweeter_tweet";
		
		// Constants for the internal events we expect
		protected static const IE_FINISHED:String = "Tweeter::Finished";
		protected static const IE_CANCELLED:String = "Tweeter::Cancelled";
		protected static const IE_ERROR:String = "Tweeter::Error";
		
		// The extension context object is what we use internally
		// to talk to the native code.
		protected static var context:ExtensionContext;
		
		// Constructor.
		public function Tweeter(target:IEventDispatcher=null)
		{
			super(target);
			
			ensureExtensionContextExists();
			
			// The native code uses the status event mechanism
			// as a general means of communication to this
			// ActionScript object. The event data passed
			// is processed and Tweeter events are dispatched
			// the the ActionScript code using this extension.
			context.addEventListener(StatusEvent.STATUS, onStatusEvent);
		}
		
		// Static public property indicating if the native extension
		// is available on the current platform. It's good
		// practice to always include something like this
		// to allow users of your extension to update the
		// interface as appropriate
		public static function get isAvailable():Boolean
		{
			ensureExtensionContextExists();

			return context.call(NM_IS_SUPPORTED) as Boolean;
		}
		
		// The main public function for the native extension
		// which will present the user with a native tweet
		// entry dialog pre-populated with coolMessage.
		public function tweet(coolMessage:String):void
		{
			ensureExtensionContextExists();
			
			// Parameter validation can be easier to do in ActionScript,
			// so it's often a good idea to clean up params for the native
			// code before calling it
			coolMessage = coolMessage || "";
			
			context.call(NM_TWEET, coolMessage);
		}
		
		// In general, an extension won't be dispose'd explicitly
		// by the application using it, but it's nice to allow
		// it the option. They may wish to use it in low
		// memory situations.
		public static function dispose():void
		{
			if (context)
			{
				context.dispose();
				context = null;
			}
		}
		
		
		// Internal helper which makes sure the context exists so
		// that we can safely use it.
		protected static function ensureExtensionContextExists():void
		{
			if (!context)
			{
				// Creates a new context object with the specified ID. The second
				// parameter can be used to tell the native code to intialize
				// in a specific manner. Most native extensions won't use this.
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			}
		}
		
		// Status event processor.
		//
		// Status events are one of the simplest mechanisms you can
		// use to communicate information from the native code to
		// this extension. The native code will call
		// the function FREDispatchStatusEventAsync and specify
		// a code and a level. You can then use this to perform
		// further operation in ActionScript.
		//
		// Here I am using it to dispatch message into the
		// ActionScript application. I use the code as the
		// internal event name (see the IE_* constants at the 
		// top of this class) and the level as optional data
		// to pass to the event.
		protected function onStatusEvent(event:StatusEvent):void
		{
			const internalEvent:String = event.code;
			const eventData:String = event.level || "<null or empty>";
			
			switch(internalEvent)
			{
				case IE_FINISHED:
					dispatchEvent(new TweeterEvent(TweeterEvent.COMPLETE));
					break;
				
				case IE_CANCELLED:
					dispatchEvent(new TweeterEvent(TweeterEvent.CANCEL));
					break;
				
				case IE_ERROR:
					dispatchEvent(new TweeterErrorEvent(TweeterErrorEvent.ERROR, eventData));
					break;
					
				default:
					trace("Unrecognised status event: " + internalEvent + ", data: " + eventData);
					break;
			}
		}
	}
}