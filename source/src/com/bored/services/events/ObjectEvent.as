package com.bored.services.events 
{
	import flash.events.Event;
	
	/**
	 * Event that simply stores an Object.
	 * 
	 * @author bored.com
	 */
	public class ObjectEvent extends Event
	{
		/**
		 * @eventType GameInfoReadyEvent
		 */
		public static const GAME_INFO_READY_EVT:String = "GameInfoReadyEvent";
		
		/**
		 * @eventType ScoreSubmissionCompleteEvent
		 */
		public static const SCORE_SUBMISSION_COMPLETE_EVT:String = "ScoreSubmissionCompleteEvent";
		
		/**
		 * @eventType flash.events.Event
		 */
		public static const LOGGED_IN_EVENT:String = "LoggedInEvent";
		
		/**
		 * @eventType NotLoggedInErrorEvent
		 */
		public static const NOT_LOGGED_IN_ERROR_EVT:String = "NotLoggedInErrorEvent";
		
		/**
		 * @private
		 */
		private var _obj:Object;
		
		/**
		 * @inheritDoc flash.events.Event#Event()
		 * @param	a_obj:	The Object to store in this event. @default null
		 */
		public function ObjectEvent(type:String, a_obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_obj = a_obj;
			
		}//end ObjectEvent() constructor.
		
		/**
		 * The object that this event stores.
		 */
		public function get obj():Object
		{
			return _obj;
			
		}//end get obj()
		
		/**
		 * @private
		 */
		public function set obj(a_obj:Object):void
		{
			_obj = a_obj;
			
		}//end set obj()
		
		/**
		 * @inheritDoc flash.events.Event#clone()
		 */
		override public function clone():Event
		{
			return new ObjectEvent(this.type, _obj, this.bubbles, this.cancelable);
			
		}//end clone()
		
		/**
		 * @inheritDoc flash.events.Event#toString()
		 */
		override public function toString():String
		{
			return formatToString("ObjectEvent", "type", "obj", "bubbles", "cancelable"); 
			
		}//end toString()
		
	}//end class ObjectEvent
	
}//end package com.bored.services.events
