package com.bored.services.data 
{
	
	/**
	 * This is a score-definition as it is entered into the CMS for this game.
	 * 
	 * @author Bo Landsman
	 */
	public class ScoreDefinition 
	{
		/**
		 * Name of this score-definition.
		 */
		public var name:String;
		
		/**
		 * "high", "low", or "flag"
		 */
		public var type:String;
		
		/**
		 * The score code for this game, defined on the CMS.
		 */
		public var code:String;
		
		/**
		 * The currently-logged-in user's best score for this score-definition, should it exist.
		 */
		public var bestScore:String;
		
		/**
		 * "time", "currency", "number" or null.
		 */
		public var format:String;
		
		/**
		 * This is a json-encoded string, with possible structures listed, below.
		 * 
		 * <pre>
		 * 					format				formatParam
		 * 					------				-----------
		 * 					number (or null):	{
		 * 											"scoretitle":[String],				// (Optional)	Title of the score-column in the leaderboard for this score-definition.
		 * 											"commas":[Boolean]					// (Optional)	Whether to add commas after every 3rd positive-digit of the score or not.
		 * 										}
		 * 
		 * 					currency:			{
		 * 											"scoretitle":[String],				// (Optional)	Title of the score-column in the leaderboard for this score-definition.
		 * 											"currencysymbol":"$",				// (Optional)	Character(s) to use for the currency symbol, to be placed before each currency-score value of a leaderboard.
		 * 											"numdecimalplaces":[Number]			// <default 2>	Number of digits after the decimal place to show the currency score.  
		 * 																						Note that all currency-scores are treated as pennies. 
		 * 																						So, if you only want to work in whole dollars (no change), and display it as such, You'd submit all scores multiplied by 100,
		 * 																						and set this parameter to 0 in the bored.com CMS.
		 * 										}
		 * 
		 * 					time:				{
		 * 											"scoretitle":[String],				// (Optional) Title of the score-column in the leaderboard for this score-definition.
		 * 											"timeformat":[String],				// (Optional, default is 'hh::mm::ss.ms') Format of the time. If only ms are to be shown, it should be 'ms'.  If only seconds, 'ss'.  
		 * 																						Note that all time-scores are treated as ms, and, if ms is not listed, the other time-units are truncated.  
		 * 																						That is, a score of 999 with timeformat="ss" will display "00".
		 * 											"postfix":"sec"
		 * 										}
		 * </pre>
		 */
		public var formatParam:String;
		
		/**
		 * Whether there is a leaderboard available for display for this score-definition or not.
		 */
		public var leaderboardAvailable:String;
		
		public function ScoreDefinition(a_rawObj:Object) 
		{
			name = a_rawObj.name;
			type = a_rawObj.type;
			code = a_rawObj.code;
			bestScore = a_rawObj.bestScore;
			format = a_rawObj.format;
			formatParam = a_rawObj.formatParam;
			leaderboardAvailable = a_rawObj.leaderboardAvailable;
			
		}//end ScoreDefinition() constructor.
		
	}//end class ScoreDefinition
	
}//end package com.bored.services.data
