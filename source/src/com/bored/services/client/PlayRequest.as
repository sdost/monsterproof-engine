package com.bored.services.client 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class PlayRequest
	{
		
		/**
		 * New play request list received.
		 * getData Object Format: {arr} An array of play request objects {uid, gid}. User id and game id.
		 */
		static public const PLAY_REQUEST_LIST:String = "prl";
		
		/**
		 * New challenge play request list.
		 * getData Object Format: {arr} An array of challenge play request objects {cid, oid, gid}.  Challenger id, opponent id, and game id.
		 */
		static public const CHALLENGE_PLAY_REQUEST_LIST:String = "cprl";
		
		/**
		 * A game is about to start, so get ready.
		 * getData Object Format: {uids, gid} uids are an array of user ids.  The second element is a game id.
		 */
		static public const PLAY_REQUEST_START:String = "prs";
		
		/**
		 * A request you made has timed out.
		 */
		static public const PLAY_REQUEST_TIMEOUT:String = "prt";
		
		/**
		 * A challenge request has been added.
		 * getData Object Format: {cid, oid, gid} Challenger id, opponent id, and game id.
		 */
		private const CHALLENGE_PLAY_REQUEST_ADD:String = "cpra";
		
		/**
		 * A challenge request has been deleted.
		 * getData Object Format: {cid, oid, gid} Challenger id, opponent id, and game id.
		 */
		private const CHALLENGE_PLAY_REQUEST_DELETE:String = "cprd";
		
		/**
		 * A play request has been added.
		 * getData Object Format: {uid, gid} User id who made the request and the game id of the game to play.
		 */
		private const PLAY_REQUEST_ADD:String = "pra";
		
		/**
		 * A play request has been deleted.
		 * getData Object Format: {uid, gid} User id who made the request and the game id of the game to play.
		 */
		private const PLAY_REQUEST_DELETE:String = "prd";
		
		/**
		 * Make a request play a game.
		 */
		private const PLAY_REQUEST:String = "pr";
		
		/**
		 * Accept a request to play a game.
		 */
		private const PLAY_REQUEST_YES:String = "pry";
		
	}

}