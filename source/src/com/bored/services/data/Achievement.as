package com.bored.services.data 
{
	
	/**
	 * Describes the data associated with this Achievement for the current game.
	 * 
	 * @author bored.com
	 */
	public class Achievement 
	{
		/**
		 * Name of this achievement.
		 */
		public var name:String;
		
		/**
		 * Description of this achievement.
		 */
		public var description:String;
		
		/**
		 * Whether the logged-in user has earned this achievement yet or not.
		 */
		public var earned:Boolean;
		
		/**
		 * Full-path url of the image representing this achievement un-earned.
		 */
		public var earnedImageUrl:String;
		
		/**
		 * Full-path url of the image representing this achievement earned.
		 */
		public var unearnedImageUrl:String;
		
		public function Achievement(a_rawObj:Object) 
		{
			name = a_rawObj.name;
			description = a_rawObj.description;
			earned = a_rawObj.earned;
			earnedImageUrl = a_rawObj.earnedImageUrl;
			unearnedImageUrl = a_rawObj.unearnedImageUrl;
			
		}//end Achievement() constructor.
		
	}//end class Achievement
	
}//end package com.bored.services.data
