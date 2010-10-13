package com.bored.services 
{
	import com.bored.services.client.GameClient;
	import com.bored.services.data.Achievement;
	import com.bored.services.data.GameInfo;
	import com.bored.services.events.DataReceivedEvent;
	import com.bored.services.events.ObjectEvent;
	import com.bored.services.events.UserProfile;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Dispatched when data at a requested key is received.
	 * @eventType com.bored.services.events.DataReceivedEvent.SAVED_DATA_RECEIVED_EVT
	 */
	[Event(name = "SavedDataReceivedEvent", type = "com.bored.services.events.DataReceivedEvent")]
	
	/**
	 * Dispatched when GameInfo is available.
	 * @eventType com.bored.services.events.ObjectEvent.GAME_INFO_READY_EVT
	 */
	[Event(name = "GameInfoReadyEvent", type = "com.bored.services.events.ObjectEvent")]
	
	/**
	 * Dispatched when a score-submission is complete. It's 'obj' parameter contains an Array of newly-awarded Achievements (if any were awarded).
	 * @eventType com.bored.services.events.ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT
	 * @see com.bored.services.data.Achievement
	 */
	[Event(name = "ScoreSubmissionCompleteEvent", type = "com.bored.services.events.ObjectEvent")]
	
	/**
	 * Dispatched when the user is logged-in.
	 * @eventType com.bored.services.events.ObjectEvent.LOGGED_IN_EVENT
	 */
	[Event(name = 'LoggedInEvent', type = 'com.bored.services.events.ObjectEvent')]
	
	/**
	 * Dispatched when an attempt to do something that requires login was attempted. 
	 * The 'obj' property of this event is filled with the name of the failed request ('submitScore', 'getGameInfo', 'showAchievements', or 'showLeaderboard')
	 * @eventType com.bored.services.events.ObjectEvent.NOT_LOGGED_IN_ERROR_EVT
	 */
	[Event(name="NotLoggedInErrorEvent", type="com.bored.services.events.ObjectEvent")]
	
	/**
	 * Static BoredServices Object.
	 * @author bored.com
	 */
	public class BoredServices
	{
		/**
		 * @private
		 */
		private static var _servicesObj:Object;
		
		/**
		 * @private
		 */
		private static var _proxyDispatcher:EventDispatcher;
		
		/**
		 * @private
		 */
		private static var _loggedIn:Boolean = false;
		
		/**
		 * @private
		 */
		private static var _userProfile:UserProfile;
		
		/**
		 * @private
		 */
		private static var _lastScoreCodeSubmitted:String;
		
		/**
		 * This should be set directly from your document class after receiving the servicesObj from BoredServices.
		 */
		public static function get servicesObj():Object
		{
			return _servicesObj;
			
		}//end get servicesObj()
		
		/**
		 * @private
		 */
		public static function set servicesObj(a_obj:Object):void
		{
			if (!_servicesObj)
			{
				_servicesObj = a_obj;
				
				_loggedIn = _servicesObj.isLoggedIn;
				if(_loggedIn)
				{
					onLoggedIn();
				}
				else
				{
					_servicesObj.addEventListener(ObjectEvent.LOGGED_IN_EVENT, onLoggedIn, false, 0, true);
				}
				
				_servicesObj.addEventListener(ObjectEvent.GAME_INFO_READY_EVT, redispatchObjEvt, false, 0, true);
				_servicesObj.addEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, redispatchScoreSubmissionObjEvt);
				_servicesObj.addEventListener(ObjectEvent.NOT_LOGGED_IN_ERROR_EVT, redispatchObjEvt, false, 0, true);
			}
			
		}//end set servicesObj()
		
		private static function sendMultiplayerStart(a_evt:Event):void
		{
			trace("BoredServices::sendMultiplayerStart() --> " + _servicesObj.gameClient);
			
			dispatchEvent(new ObjectEvent(ObjectEvent.MULTPLAYER_GAME_START_EVT, _servicesObj.gameClient));
		}//end sendMultiplayerStart()
		
		private static function sendMultiplayerFail(a_evt:Event):void
		{
			trace("BoredServices::sendMultiplayerFail() --> " + _servicesObj.gameClient);
			
			dispatchEvent(new ObjectEvent(ObjectEvent.MULTPLAYER_GAME_FAIL_EVT, _servicesObj.gameClient));
		}//end sendMultiplayerStart()
		
		/**
		 * Set the root DisplayObjectContainer that contains the BoredServices UI.
		 * 
		 * @param	a_displayObjCont:	Container for the services UI.
		 */
		public static function setRootContainer(a_displayObjCont:DisplayObjectContainer):void
		{
			if (_servicesObj)
			{
				_servicesObj.rootContainer = a_displayObjCont;
			}
			
		}//end setRootContainer()
		
		/**
		 * 
		 * @return	The container of the services UI.
		 */
		public static function getRootContainer():DisplayObjectContainer
		{
			var rootContainer:DisplayObjectContainer;
			
			if (_servicesObj)
			{
				rootContainer = _servicesObj.rootContainer;
			}
			
			return rootContainer;
			
		}//end getRootContainer()
		
		/**
		 * @private
		 * 
		 * Listener for when the services is logged in.
		 * 
		 * @param	a_evt:	The logged-in event notification.
		 */
		private static function onLoggedIn(a_evt:Event = null):void
		{
			_loggedIn = true;
			BoredServices.dispatchEvent(new ObjectEvent(ObjectEvent.LOGGED_IN_EVENT));
			
		}//end onLoggedIn()
		
		/**
		 * Show the LoginUI (the login/register and mini-profile UI widget)
		 * 
		 * @param	a_params:	Object with the format {x:[Number], y:[Number]}
		 * 						Any and all of the parameters in the object are optional.  They are each described, below:
		 * 							x:	[Number] x-position of the mini-UI (login widget)
		 * 							y:	[Number] y-position of the mini-UI (login widget)
		 * 						@default null
		 */
		public static function showLoginUI(a_options:Object = null):void
		{
			if (_servicesObj)
			{
				_servicesObj.showLoginUI(a_options);
			}
			
		}//end showLoginUI()
		
		
		/**
		 * Show the Main Login UI.  This is the larger UI widget that shows the login/register buttons.
		 * 
		 */
		public static function showMainLoginUI():void
		{
			if (_servicesObj)
			{
				_servicesObj.showMainLoginUI();
			}
			
		}//end showMainLoginUI()
		
		/**
		 * Hide the LoginUI (the login/register and mini-profile UI widget)
		 * 
		 */
		public static function hideLoginUI():void
		{
			if (_servicesObj)_servicesObj.hideLoginUI();
			
		}//end hideLoginUI()
		
		/**
		 * Saves user data specific to this current game.
		 * 
		 * @param	a_key:	String name associated with the a_data.
		 * @param	a_data:	Data-object to save associated with a_key.
		 */
		public static function setData(a_key:String, a_data:*):void
		{
			if (_servicesObj)
			{
				_servicesObj.setData(a_key, a_data);
			}
			
		}//end setData()
		
		/**
		 * Gets user data specific to this current game.
		 * 
		 * @param	a_key:	String name associated with the data to pull.
		 */
		public static function getData(a_key:String):void
		{
			if (_servicesObj)
			{
				_servicesObj.addEventListener(DataReceivedEvent.SAVED_DATA_RECEIVED_EVT, onGetDataComplete, false, 0, true);
				_servicesObj.getData(a_key);
			}
			
		}//end getData()
		
		/**
		 * @private
		 * @param	objEvt:	[ObjectEvent] This event contains an attribute 'obj' of the received user game-data.
		 */
		private static function onGetDataComplete(objEvt:*):void
		{
			var recdObj:Object = objEvt.obj;
			var keyRequest:String = recdObj ? recdObj.key : null;
			var dataAcquired:* = recdObj ? recdObj.data : null;
			
			BoredServices.dispatchEvent(new DataReceivedEvent(DataReceivedEvent.SAVED_DATA_RECEIVED_EVT, keyRequest, dataAcquired));
			
		}//end onGetDataComplete()
		
		/**
		 * @private
		 * @param	objEvt:	[ObjectEvent] This event contains an attribute 'obj' of the received user game-data.
		 */
		private static function onGetUserInfoComplete(objEvt:*):void
		{
			var recdObj:Object = objEvt.obj;
			var keyRequest:String = recdObj ? recdObj.key : null;
			var dataAcquired:* = recdObj ? recdObj.data : null;
			
			BoredServices.dispatchEvent(new DataReceivedEvent(DataReceivedEvent.SAVED_DATA_RECEIVED_EVT, keyRequest, dataAcquired));
			
		}//end onGetDataComplete()
		
		/**
		 * Show the all Achievements for this game.  If the user is logged-in, the user's current achievements are shown as acquired. If not logged-in,
		 * all achievements are shown as not-acquired.
		 * 
		 */
		public static function showAchievements():void
		{
			if (_servicesObj)
			{
				_servicesObj.showAchievements();
			}
			
		}//end showAchievements()
		
		/**
		 * Shows the leaderboard for a specific score-code for this game.
		 * 
		 * @param	a_scoreCode:	If given, this is used to pull the leaderboard.  If not logged in, this is necessary in order to 
		 * 							acquire a leaderboard.  This value is acquired from the bored.com CMS. @default null
		 */
		public static function showLeaderboard(a_scoreCode:String = null):void
		{
			if (_servicesObj)
			{
				if (null == a_scoreCode && !BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				_servicesObj.showLeaderboard(a_scoreCode);
			}
			
		}//end showLeaderboard()
		
		public static function loginChat(a_un:String = null, a_pass:String = null, a_tok:String = null):void
		{
			if ( _servicesObj )
			{
				if ( a_un == null ) a_un = "";
				if ( a_pass == null ) a_pass = "";
				if ( a_tok == null ) a_tok = "";
				
				_servicesObj.loginGS(a_un, a_pass, a_tok);
			}
		}//end loginChat()
		
		public static function logoutChat():void
		{
			if ( _servicesObj )
			{
				_servicesObj.logoutGS();
			}
		}//end loginChat()
		
		public static function showGameLobby(a_gameID:int):void
		{
			if ( _servicesObj )
			{
				_servicesObj.addEventListener("m_p", sendMultiplayerStart, false, 0, true);
				_servicesObj.addEventListener("d", sendMultiplayerFail, false, 0, true);
				_servicesObj.addEventListener("err", sendMultiplayerFail, false, 0, true);
				
				_servicesObj.multiplayerGameID = a_gameID;
				
				_servicesObj.showLobby();
			}
		}//end loginChat()
		
		/**
		 * Submit that an achievement was acquired.  This call is only valid for ScoreDefinitions of type 'high' (high to low) or 'flag' (Boolean) with a target of '1'.
		 * 
		 * @param	a_achievementScoreCode:		The ScoreDefinition code for this achievement.  Received from the bored.com CMS. @default null
		 * @param	a_showNewAchievementsPopup:	If any new achievements were granted due to this submission, automatically show 
		 * 										the new-achievements-acquired BoredServicesUI popup. @default false
		 */
		public static function submitAchievementAcquired(a_achievementScoreCode:String = null, a_showNewAchievementsPopup:Boolean = false):void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				if (a_showNewAchievementsPopup)
				{
					_servicesObj.addEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, showNewAchievementsOnScoreSubmission, false, 0, true);
				}
				
				_servicesObj.submitScore(1, a_achievementScoreCode);
			}
			
		}//end submitAchievementScore()
		
		/**
		 * Submit a score for a specific score-code. This can be used to submit achievement scores, as well as leaderboard-scores.
		 * Upon score-submission completion, the ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT ObjectEvent is fired from here, whose 'obj' 
		 * attribute contains an Array of the awarded achievements associated with this submitted score.
		 * <br></br><br></br><b>NOTE:</b> The user must be logged-in in order to submit scores.
		 * 
		 * @param	a_score:						The score to submit.
		 * @param	a_showLeaderboardOnComplete:	Upon score completion, display the BoredServicesUI leaderboard. @default true
		 * @param	a_scoreCode:					The score-code (for this game) to submit the score to. @default null
		 * 											If no score-code is given, the score is submitted to the 
		 * 											first-available score-code that has a leaderboard available.
		 * @param	a_showNewAchievementsPopup		If there are any achievements acquired due to this score submission,
		 * 											display the BoredServicesUI achievement-acquired popup. @default false
		 * @see showNewAchievementsOnScoreSubmission()
		 */
		public static function submitScore(a_score:*, a_showLeaderboardOnComplete:Boolean = true, a_scoreCode:String = null, a_showNewAchievementsPopup:Boolean = false):void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				_lastScoreCodeSubmitted = null;
				
				if (a_showLeaderboardOnComplete)
				{
					_lastScoreCodeSubmitted = a_scoreCode;
					_servicesObj.addEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission, false, 0, true);
				}
				
				if (a_showNewAchievementsPopup)
				{
					_servicesObj.addEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, showNewAchievementsOnScoreSubmission, false, 0, true);
				}
				
				_servicesObj.submitScore(a_score, a_scoreCode);
			}
			
		}//end submitScore()
		
		/**
		 * 
		 * This is the automated score-submission-complete handler to determine if an achievement is to be displayed or not.
		 * 
		 * @param	a_evt:	<ObjectEvent> Event with property 'obj', which, if valid, is an Array of newly-awarded achievements based on the submission that this is a response to.
		 * 					Achievement objects have the following structure:
		 * 					{
		 * 						name:				[String]	Name of this achievement.
		 * 						description:		[String]	Description of this achievement.
		 * 						earned:				[Boolean]	Whether the logged-in user has earned this achievement yet or not.
		 * 						earnedImageUrl:		[String]	Full-path url of the image representing this achievement un-earned.
		 * 						unearnedImageUrl:	[String]	Full-path url of the image representing this achievement earned.
		 * 					}
		 */
		private static function showNewAchievementsOnScoreSubmission(a_evt:Event):void
		{
			if (_servicesObj)
			{
				_servicesObj.removeEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission);
				
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				var achievementsArr:Array = (a_evt as Object).obj;
				
				if (achievementsArr && achievementsArr.length)
				{
					_servicesObj.showAchievements(achievementsArr);
				}
			}
			
		}//end showNewAchievementsOnScoreSubmission()
		
		/**
		 * @private
		 */
		private static function showLeaderboardOnScoreSubmission(a_evt:Event):void
		{
			if (_servicesObj)
			{
				_servicesObj.removeEventListener(ObjectEvent.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission);
			}
			
			showLeaderboard(_lastScoreCodeSubmitted);
			_lastScoreCodeSubmitted = null;
			
		}//end showLeaderboardOnScoreSubmission()
		
		/**
		 * Requests the GameInfo Object associated with this game.
		 * The GameInfo object is included in this dispatch of ObjectEvent.GAME_INFO_READY_EVT.
		 * The 'obj' parameter of this dispatched ObjectEvent is an instance of a GameInfo object.
		 * 
		 * @see com.bored.services.data.GameInfo
		 */
		public static function getGameInfo():void
		{
			if (!_servicesObj)
			{
				return;
			}
			
			_servicesObj.addEventListener(ObjectEvent.GAME_INFO_READY_EVT, BoredServices.redispatchGameInfoObj, false, 0, true);
			_servicesObj.getGameInfo();
			
		}//end getGameInfo()
		
		/**
		 * Determine whether the user is logged-in to the BoredServices or not.
		 */
		public static function get isLoggedIn():Boolean
		{
			return _loggedIn;
			
		}//end isLoggedIn()
		
		/**
		 * Show the Chat UI.
		 * 
		 */
		public static function showChatUI():void
		{
			if (_servicesObj)
			{
				_servicesObj.chatEnabled = true;
			}
			
		}//end showMainLoginUI()
		
		/**
		 * Hide the Chat UI
		 * 
		 */
		public static function hideChatUI():void
		{
			if (_servicesObj)
			{
				_servicesObj.chatEnabled = false;
			}
			
		}//end hideLoginUI()
		
		/**
		 * Returns the UserProfile Object of the logged-in user. If the user is not logged in, this value will be null.  Upon receiving the ObjectEvent.LOGGED_IN_EVENT, this value is valid.
		 */
		public static function get userProfile():*
		{
			if (!_userProfile && _servicesObj && _servicesObj.userProfile)
			{
				return _servicesObj.userProfile;
			}
			
			return null;
			
		}//end get userProfile()
		
		
		public static function getUserProfileByName(a_id:String):void
		{
			if ( _servicesObj.userProfile && a_id == _servicesObj.userProfile.valueOf("screen_name") )
			{
				redispatchUserInfoObj(new ObjectEvent(ObjectEvent.GET_USER_INFO_EVT, userProfile));
			}
			else
			{
				_servicesObj.getUserProfileByName(a_id);
				_servicesObj.addEventListener(ObjectEvent.GET_USER_INFO_EVT, redispatchUserInfoObj, false, 0, true);
			}
		}//end getUserProfile()
		
		
	
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 * <br></br><br></br><b>NOTE:</b> This has the exact same functionality as the flash.events.EventDispatcher function by the same name.
		 * 
		 * @see flash.events.EventDispatcher#addEventListener()
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			proxyDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}//end addEventListener()
		
		/**
		 * Removes a listener from the EventDispatcher object.
		 * <br></br><br></br><b>NOTE:</b> This has the exact same functionality as the flash.events.EventDispatcher function by the same name.
		 * 
		 * @see flash.events#removeEventListener() 
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			proxyDispatcher.removeEventListener(type, listener, useCapture);
			
		}//end removeEventListener()
		
		/**
		 * Dispatches an event into the event flow.
		 * <br></br><br></br><b>NOTE:</b> This has the exact same functionality as the flash.events.EventDispatcher function by the same name.
		 * 
		 * @see flash.events#dispatchEvent()
		 */
		public static function dispatchEvent(event:Event):Boolean
		{
			return proxyDispatcher.dispatchEvent(event);
			
		}//end dispatchEvent()

		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
		 * <br></br><br></br><b>NOTE:</b> This has the exact same functionality as the flash.events.EventDispatcher function by the same name.
		 * 
		 * @see flash.events#hasEventListener() 
		 */
		public function hasEventListener(type:String):Boolean
		{
			return proxyDispatcher.hasEventListener(type);
			
		}//end hasEventListener()
		
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the specified event type.
		 * <br></br><br></br><b>NOTE:</b> This has the exact same functionality as the flash.events.EventDispatcher function by the same name.
		 * 
		 * @see flash.events#willTrigger() 
		 */
		public function willTrigger(type:String) : Boolean
		{
			return proxyDispatcher.willTrigger(type);
			
		}//end willTrigger()
		
		/**
		 * @private
		 */
		private static function get proxyDispatcher():EventDispatcher
		{
			if (!_proxyDispatcher)
			{
				_proxyDispatcher = new EventDispatcher();
			}
			
			return _proxyDispatcher;
			
		}//end get proxyDispatcher()
		
		/**
		 * @private
		 */
		private static function redispatch(a_evt:Event):void
		{
			trace("BoredServices::redispatch(" + a_evt + ")");
			
			BoredServices.dispatchEvent(a_evt);
			
		}//end redispatch()
		
		/**
		 * @private
		 */
		private static function redispatchGameInfoObj(a_evt:Event):void
		{
			var objEvt:ObjectEvent = new ObjectEvent(a_evt.type);
			
			var rawObj:Object = (a_evt as Object).obj;
			
			var gameInfo:GameInfo = new GameInfo(rawObj);
			
			objEvt.obj = gameInfo;
			
			BoredServices.dispatchEvent(objEvt);
			
		}//end redispatchGameInfoObj()
		
		/**
		 * @private
		 */
		private static function redispatchUserInfoObj(a_evt:Event):void
		{
			var objEvt:ObjectEvent = new ObjectEvent(ObjectEvent.GET_USER_INFO_EVT);
			
			objEvt.obj = (a_evt as Object).obj;
			
			BoredServices.dispatchEvent(objEvt);	
		}//end redispatchUserInfoObj()
		
		/**
		 * @private
		 */
		private static function redispatchScoreSubmissionObjEvt(a_evt:Event):void
		{
			var objEvt:ObjectEvent = new ObjectEvent(a_evt.type);
			
			var rawAchievementArr:Array = (a_evt as Object).obj;
			
			var achievementsArr:Array;
			
			if (rawAchievementArr && rawAchievementArr.length)
			{
				achievementsArr = new Array();
				
				for (var i:int = 0; i < rawAchievementArr.length; i++)
				{
					achievementsArr.push(new Achievement(rawAchievementArr[i]));
				}
			}
			
			objEvt.obj = achievementsArr;
			
			BoredServices.dispatchEvent(objEvt);
			
		}//end redispatchScoreSubmissionObjEvt()
		
		/**
		 * @private
		 */
		private static function redispatchObjEvt(a_evt:Event):void
		{
			var objEvt:ObjectEvent;
			
			var obj:Object;
			
			var evtToDispatch:Event = a_evt;
			
			try
			{
				obj = (a_evt as Object).obj;
				objEvt = new ObjectEvent(a_evt.type, obj, a_evt.bubbles, a_evt.cancelable);
				evtToDispatch = objEvt;
			}
			catch (e:Error)
			{
				
			}
			
			BoredServices.dispatchEvent(evtToDispatch);
			
		}//end redispatchObjEvt()
		
	}//end class BoredServices
	
}//end package com.bored.services
