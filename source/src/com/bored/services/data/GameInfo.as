package com.bored.services.data 
{
	
	/**
	 * The GameInfo metadata associated with this game.
	 * 
	 * @author bored.com
	 */
	public class GameInfo 
	{
		
		/**
		 * name of the logged-in user, should the user be logged in.
		 */
		public var username:String;
		
		/**
		 * Array of Achievement objects for this game.
		 * 
		 * @see com.bored.services.data.Achievement
		 * 
		 */
		public var achievements:Array;
		
		/**
		 * Array of ScoreDefinition objects for this game.
		 * 
		 * @see com.bored.services.data.ScoreDefinition
		 * 
		 */
		public var scores:Array;
		
		public function GameInfo(a_rawObj:Object) 
		{
			username = a_rawObj.username;
			
			var i:int; // loop iterator.
			
			var rawAchievementsArr:Array = (a_rawObj && a_rawObj.achievements) ? a_rawObj.achievements : new Array();
			
			for (i = 0; i < rawAchievementsArr.length; i++)
			{
				achievements.push(new Achievement(rawAchievementsArr[i]));
			}
			
			var rawScoresArr:Array = (a_rawObj && a_rawObj.scores) ? a_rawObj.scores : new Array();
			
			for (i = 0; i < rawScoresArr.length; i++)
			{
				scores.push(new ScoreDefinition(rawScoresArr[i]));
			}
			
		}//end GameInfo() constructor.
		
	}//end class GameInfo
	
}//end package com.bored.services.data
