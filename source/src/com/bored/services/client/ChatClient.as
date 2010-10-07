package com.bored.services.client 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class ChatClient
	{
		/**
		 * User joined the lobby room.
		 */
		static public const LOBBY_ROOM:String = "lr";
		
		/**
		 * A user entered the room that you are in.
		 */
		static public const USER_IN:String = "ui";
		
		/**
		 * A user left the room that you are in.
		 */
		static public const USER_OUT:String = "uo";
		
		/**
		 * A list of rooms have been received.
		 */
		static public const ROOM_LIST:String = "rl";
		
		/**
		 * User joined a room.
		 */
		static public const ROOM_JOIN:String = "rj";
		
		/**
		 * A message was received from another user.
		 */
		static public const MESSAGE:String = "m";
			
	}

}