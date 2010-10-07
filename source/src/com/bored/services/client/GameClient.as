package com.bored.services.client 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class GameClient
	{
		
		/**
		 * Game is starting on the server.
		 */
		static public const GAME_START:String = "g_s";
		
		/**
		 * Server is waiting for other clients to get ready.
		 */
		static public const GAME_WAIT:String = "g_w";
		
		/**
		 * The game ended on the server.
		 */
		static public const GAME_END:String = "g_e";
		
		/**
		 * The results of a game that ended.
		 */
		static public const GAME_RESULTS:String = "g_r";
		
		/**
		 * The current game is voided.
		 */
		static public const GAME_VOID:String = "g_v";
		
		/**
		 * Event generic game state message.  Can be used for what ever purpose
		 * the developer wishes.
		 * getData Object Format: {pid} Player id whose game state should update.
		 */
		static public const GAME_STATE:String = "gs";
		
		/**
		 * Event timer message whose object contains the most current
		 * time count.
		 * getData Object Format: {cnt} Current count of the timer.
		 */
		static public const GAME_TIMER:String = "gt";
		
		/**
		 * Event timer message signifying the timer has reached the end.
		 */
		static public const GAME_TIMER_END:String = "gte";
		
		/**
		 * Event a game room has been joined.
		 */
		static public const GAME_ROOM:String = "gr";
		
	}

}