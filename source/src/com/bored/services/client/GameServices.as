package com.bored.services.client 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class GameServices
	{
		/**
		 * User connected to the Smart Fox Server.
		 */
		static public const CONNECTED:String = "c";
		
		/**
		 * User disconnected from the Smart Fox Server.
		 */
		static public const DISCONNECTED:String = "d";
		
		/**
		 * An error occured that is dispacthed as an ErrorEvent.
		 */
		static public const ERROR:String = "err";
		
		/**
		 * User account details received.
		 */
		static public const USER_ACCT:String = "ua";
		
		/**
		 * User logged out of Smart Fox Server.
		 */
		static public const LOGOUT:String = "lo";
		
		/**
		 * An extension response.
		 */
		static public const XT:String = "xt";	
	}

}