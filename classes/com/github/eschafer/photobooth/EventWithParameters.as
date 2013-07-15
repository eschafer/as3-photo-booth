package com.github.eschafer.photobooth {
	// Import class
	import flash.events.Event;
	// EventType
	public class EventWithParameters extends Event {
		// Properties
  		public var parameters:Object;
  		// Constructor
  		public function EventWithParameters(type:String, params:Object) {
   			super(type, false, false);
   			parameters = params;
   		}
		// Override clone
		override public function clone():Event{
			return new EventWithParameters(type, parameters);
		};
	}
}
