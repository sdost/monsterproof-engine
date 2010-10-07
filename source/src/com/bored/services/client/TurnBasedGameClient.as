package com.bored.services.client 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class TurnBasedGameClient
	{
		
		/**
		 * A round is starting in the game.
		 * getData Object Format: {rnd} Current round number.
		 */
		static public const ROUND_START:String = "r_s";
		static public const ROUND_END:String = "r_e";
		static public const ROUND_RESULTS:String = "r_r";
		
		/**
		 * It is your turn to play.
		 * getData Object Format: {ct} Current Turn.
		 */
		static public const TURN_START:String = "t_s";
		
		/**
		 * You have to wait your turn.
		 * getData Object Format: {ct} Current Turn.
		 */
		static public const TURN_WAIT:String = "t_w";
		
		static public const TURN_UPDATE:String = "t_u";
		static public const TURN_END:String = "t_e";
		static public const TURN_RESULTS:String = "t_r";
		
	}

}