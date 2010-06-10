package com.bored.services.events 
{
	import flash.events.Event;
	
	/**
	 * This event contains the requested user-game-data for a supplied key string.
	 * 
	 * @author bored.com
	 */
	public class DataReceivedEvent extends Event
	{
		/**
		 * @eventType SavedDataReceivedEvent
		 */
		public static const SAVED_DATA_RECEIVED_EVT:String = "SavedDataReceivedEvent";
		
		/**
		 * The key with which data is associated.
		 */
		public var key:String;
		
		/**
		 * The data with which key is associated.
		 */
		public var data:*;
		
		public function DataReceivedEvent(type:String, a_key:String, a_data:*, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			key = a_key;
			data = a_data;
			
		}//end DataReceivedEvent()
		
		override public function clone():Event 
		{
			return new DataReceivedEvent(this.type, this.key, this.data, this.bubbles, this.cancelable);
			
		}//end clone()
		
		public override function toString():String
		{
			return formatToString("DataReceivedEvent", "type", "key", "data", "bubbles", "cancelable");
			
		}//end toString()

		
	}//end class DataReceivedEvent
	
}//end package com.bored.services.events
