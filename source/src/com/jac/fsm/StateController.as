/*
Hook Finite State Machine Copyright 2009 Hook L.L.C.
For licensing questions contact hook: http://www.byhook.com

 This file is part of Hook Finite State Machine.

Hook Finite State Machine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
at your option) any later version.

Hook Finite State Machine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Hook Finite State Machine.  If not, see <http://www.gnu.org/licenses/>.

*/

package com.jac.fsm 
{
	import com.jac.fsm.interfaces.IState;
	import flash.events.EventDispatcher;
	import com.jac.fsm.stateEvents.StateEvent;
	
	/**
	* Dispatched when the enable procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.ENABLE_COMPLETE
	* 
	* @see #enableComplete()
	*/
	[Event("ENABLE_COMPLETE", type="com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched when the disable procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.DISABLE_COMPLETE
	* 
	* @see #disableComplete()
	*/
	[Event("DISABLE_COMPLETE", type = "com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched when the enter procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.ENTER_COMPLETE
	* 
	* @see #enterComplete()
	*/
	[Event("ENTER_COMPLETE", type = "com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched when the exit procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.EXIT_COMPLETE
	* 
	* @see #exitComplete()
	*/
	[Event("EXIT_COMPLETE", type="com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	 * A <code>StateController</code> is a management interface for a list of state sub objects.  When a StateController is told to exit or enter,
	 * the controller then in return tells all of its sub objects to exit or enter.  It then waits until all of the sub objects have finished their exits/enters
	 * and dispatches and event notifying of its completion.  All commands directed at a <code>State</code> should go through a <code>StateController</code>
	 * 
	 * @see State
	 * @see StateView
	 * @see StateViewController
	 */
	public class StateController extends EventDispatcher
	{//StateControler Class
	
		//List of controllers that enter and exit need to be called on before this controler is
		//finished being entered or exited
		protected var _subObjList:Array;
		protected var _exitCount:int = 0;
		protected var _enterCount:int = 0;
		protected var _disableCount:int = 0;
		protected var _enableCount:int = 0;
		
		/**
		 * Creates a new <code>StateController</code> and sets up a new arraw for sub-objects
		 */
		public function StateController() 
		{//StateController
			_subObjList = new Array();
		}//StateController
		
		////////////////////////////////// CONTROLLING FUNCTIONS /////////////////////////////
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{//reset
		}//reset
		
		/**
		 * Calls <code>enterSubObjects()</code> when the controller is told to enter.
		 * <p>
		 * It was set up this way so that the <code>enterSubObjects</code> method could be overridden as needed.
		 * </p>
		 * 
		 * @see #enterSubObjects()
		 */
		public function enter():void
		{//enter
			enterSubObjects();
		}//enter
		
		/**
		 * Calls <code>enter()</code> on all of the items in the <code>_subObjectList</code>.  It also sets
		 * up the proper listeners to keep track of each sub object's completion.
		 * 
		 * @see #_subObjectList
		 */
		protected function enterSubObjects():void
		{//enterSubObjects
			//trace("State Controller Enter: " + _subObjList.length);
			//reset count
			_enterCount = 0;
			
			if (_subObjList.length)
			{//enter
				for (var i:int = 0; i < _subObjList.length; i++)
				{//enter all
					_subObjList[i].addEventListener(StateEvent.ENTER_COMPLETE, handleEnterComplete, false, 0, true);
					_subObjList[i].enter();
				}//enter all
			}//enter
			else
			{//finished
				handleEnterComplete(null);
			}//finished
		}//enterSubObjects
		
		
		/**
		 * Calls <code>exitSubObjects()</code> when the controller is told to exit.
		 * <p>
		 * It was set up this way so that the <code>exitSubObjects</code> method could be overridden as needed.
		 * </p>
		 */
		public function exit():void
		{//exit
			exitSubObjects();
		}//exit
		
		/**
		 * Calls <code>exit()</code> on all of the items in the <code>_subObjectList</code>.  It also sets
		 * up the proper listeners to keep track of each sub object's completion.
		 * 
		 * @see #_subObjectList
		 */
		protected function exitSubObjects():void
		{//exitSubObjects
			//reset count
			_exitCount = 0;
			
			if (_subObjList.length)
			{//exit
				for (var i:int = 0; i < _subObjList.length; i++)
				{//exit all
					//trace("StateController calling exit on: " + _subObjList[i] + " " + GetStateName(_subObjList[i]));
					_subObjList[i].addEventListener(StateEvent.EXIT_COMPLETE, handleExitComplete, false, 0, true);
					_subObjList[i].exit();
				}//exit all
			}//exit
			else
			{//no sub objects
				handleExitComplete(null);
			}//no sub objects
		}//exitSubObjects
		
		/**
		 * Calls <code>disableSubObjects()</code> when the controller is told to disable.
		 * <p>
		 * It was set up this way so that the <code>disableSubObjects</code> method could be overridden as needed.
		 * </p>
		 */
		public function disable():void
		{//disable
			disableSubObjects();
		}//disable
		
		/**
		 * Calls <code>disable()</code> on each sub object in the <code>_subObjectList</code>, and sets up
		 * the proper listeners to keep track of the each sub-object's completion.
		 */
		protected function disableSubObjects():void
		{//disableSubObjects
			//Disable count
			_disableCount = 0;
			if (_subObjList.length)
			{//disable
				for (var i:int = 0; i < _subObjList.length; i++)
				{//disable all
					//trace("Disabling: " + _subObjList[i]);
					_subObjList[i].addEventListener(StateEvent.DISABLE_COMPLETE, handleDisableComplete, false, 0, true);
					_subObjList[i].disable();
				}//disable all
			}//disable
			else
			{//finished
				handleDisableComplete(null);
			}//finished
		}//disableSubObjects
		
		
		/**
		 * Calls <code>enableSubObjects()</code> when the controller is told to disable.
		 * <p>
		 * It was set up this way so that the <code>enableSubObjects</code> method could be overridden as needed.
		 * </p>
		 */
		public function enable():void
		{//enable
			enableSubObjects();
		}//enable
	
		/**
		 * Calls <code>enable()</code> on each sub object in the <code>_subObjectList</code>, and sets up
		 * the proper listeners to keep track of the each sub-object's completion.
		 */
		protected function enableSubObjects():void
		{//enableSubObjects
			//reset count
			_enableCount = 0;
			
			if (_subObjList.length)
			{//enable
				for (var i:int = 0; i < _subObjList.length; i++)
				{//enable all
					_subObjList[i].addEventListener(StateEvent.ENABLE_COMPLETE, handleEnableComplete, false, 0, true);
					_subObjList[i].enable();
				}//enable all
			}//enable
			else
			{//finished
				handleEnableComplete(null);
			}//finished
		}//enableSubObjects
		
		//Adds newController:StateController to list of objects that exit/enter get called on
		/**
		 * Adds objects to the <code>_subObjectList</code> for control by this controller.
		 * <B>There is currently no checking for duplicates in the list</B>
		 * 
		 * @param	newController a compliant sub object
		 */
		public function registerSubObject(newController:IState):void
		{//registerSubController
			if (!(newController))
			{//error
				throw Error("StateController:registerSubObject: Bad sub object type!");
			}//error
			else
			{//good
				_subObjList.push(newController);
			}//good
		}//registerSubController
		
		/**
		 * Removes oldController from list of objects that are controlled by this controller.
		 * If that object is not found in the list, a warning will be traced out.
		 *
		 * @param	oldController an IState object that will be removed from the list.
		 */
		public function unregisterSubObject(oldController:IState):void
		{//unregisterSubObject
		
			if (!(oldController))
				{//error
					throw Error("StateController:registerSubObject: Bad sub Object type!");
				}//error
				else
				{//good
					var removedAny:Boolean = false;
					for (var i:int = 0; i < _subObjList.length; i++)
					{//find
						if (_subObjList[i] == oldController)
						{//remove
							removedAny = true;
							_subObjList.splice(i, 1);
							break;
						}//remove
					}//find
				
					if (!removedAny)
					{//warning
						trace("--FSM--StateController--: Did not find " + oldController + " in registered subController list");
					}//warning
				}//good
		}//unregisterSubObject
		
		/**
		 * Calls <code>update</code> on all of the sub-objects.
		 */
		public function update():void
		{//update
			for (var i:int = 0; i < _subObjList.length; i++)
			{//update all
				_subObjList[i].update();
			}//update all
		}//update
		
		////////////////////////////// EVENT HANDLERS ////////////////////////////
		/**
		 * Calls <code>disableComplete()</code> which handles a <code>StateEvent.DISABLE_COMPLETE</code> event when a
		 * sub-object has finished disabling.
		 * @param	e
		 * 
		 * @see #disableComplete()
		 */
		protected function handleDisableComplete(e:StateEvent):void
		{//handleDisableComplete
			disableComplete(e);
		}//handleDisableComplete
		
		/**
		 *  Handles a <code>StateEvent.DISABLE_COMPLETE</code> event when a
		 * sub-object has finished disabling.  This keeps track of the number of sub-objects that have complete
		 * being disabled.  When all sub-objects are finished, a <code>StateEvent.DISABLE_COMPLETE</code> event is dispatched.
		 * @param	e
		 */
		protected function disableComplete(e:StateEvent):void
		{//disableComplete
			if (e)
			{//clean up event
				e.target.removeEventListener(StateEvent.DISABLE_COMPLETE, handleDisableComplete);
				//trace("Disabling: " + e.target + " / " + (_disableCount +1)+ " / " + _subObjList.length);
			}//clean up event
			
			//inc count
			_disableCount++;
			
			if (_disableCount == _subObjList.length || !_subObjList.length)
			{//done !
				//trace(this + " Disable Completed, notifying...");
				notifyDisableComplete(new StateEvent(StateEvent.DISABLE_COMPLETE, this, false, false));
			}//done!

		}//disableComplete
		
		/**
		 * Calls <code>enableComplete</code> which handles the <code>StateEvent.ENABLE_COMPLETE</code> event for each sub object.
		 * @param	e
		 * 
		 * @see #enableComplete()
		 */
		protected function handleEnableComplete(e:StateEvent):void
		{//handleEnableComplete
			enableComplete(e);
		}//handleEnableComplete
	
		/**
		 * Handles the <code>StateEvent.ENABLE_COMPLETE</code> event for each sub object, keeping track of
		 * how many objects have finished.  When each sub-object has finished, a <code>StateEvent.ENTER_COMPLETE</code> event is dispatched.
		 * @param	e
		 */
		protected function enableComplete(e:StateEvent):void 
		{//enableComplete
			if (e)
			{//clean up event
				e.target.removeEventListener(StateEvent.ENABLE_COMPLETE, handleEnableComplete);
				//trace("Enabling: " + e.target + " / " + (_enableCount+1) + " / " + _subObjList.length);
			}//clean up event
			
			//inc count
			_enableCount++;
			
			
			if (_enableCount == _subObjList.length || !_subObjList.length)
			{//done !
				//trace(this + " Enable Completed, notifying...");
				notifyEnableComplete(new StateEvent(StateEvent.ENABLE_COMPLETE, this, false, false));
			}//done!
		}//enableComplete
		
		/**
		 * Calls <code>exitComplete()</code> which handles the <code>StateEvent.EXIT_COMPLETE</code> notification from each sub-object.
		 * @param	e
		 */
		protected function handleExitComplete(e:StateEvent):void
		{//handleExitComplete
			exitComplete(e);
		}//handleExitComplete
		
		/**
		 * Handles the <code>StateEvent.EXIT_COMPLETE</code> event from each sub object, keeping track of
		 * how many objects have finished.  When each sub-object has finished, a <code>StateEvent.EXIT_COMPLETE</code> event is dispatched.
		 * @param	e
		 */
		protected function exitComplete(e:StateEvent):void 
		{//exitComplete
			if (e)
			{//clean up events
				e.target.removeEventListener(StateEvent.EXIT_COMPLETE, handleExitComplete);
				//trace("Exiting: " + e.target + " / " + (_exitCount+1) + " / " + _subObjList.length);
			}//clean up events
			
			//inc count
			_exitCount++;
			
			if (_exitCount == _subObjList.length || !_subObjList.length)
			{//done !
				//trace(this + " Exit Completed, notifying...");
				notifyExitComplete(new StateEvent(StateEvent.EXIT_COMPLETE, this, false, false));
			}//done!
		}//exitComplete
		
		/**
		 * Calls <code>enterComplete()</code> which handles the <code>StateEvent.ENTER_COMPLETE</code> notification for each sub-object.
		 * @param	e
		 * 
		 * @see #enterComplete()
		 */
		protected function handleEnterComplete(e:StateEvent):void
		{//handleEnteComplete
			enterComplete(e);
		}//handleEnteComplete
		
		/**
		 * Handles the <code>StateEvent.ENTER_COMPLETE</code> notification from each sub-object, keeping track of
		 * how many objects have finished.  When each sub-object has finished, a <code>StateEvent.ENTER_COMPLETE</code> event is dispatched.
		 * @param	e
		 */
		protected function enterComplete(e:StateEvent):void 
		{//enterComplete
			if (e)
			{//clean up event
				e.target.removeEventListener(StateEvent.ENTER_COMPLETE, handleEnterComplete);
				//trace("Disabling: " + e.target + " / " + (_enterCount+1) + " / " + _subObjList.length);
			}//clea up event
			
			//inc count
			_enterCount++;
			
			if (_enterCount == _subObjList.length || !_subObjList.length)
			{//done !
				//trace(this + " Enter Completed, notifying...");
				notifyEnterComplete(new StateEvent(StateEvent.ENTER_COMPLETE, this, false, false));
			}//done!
		}//enterComplete
		
		/**
		 * A convenience method for notifying of a DISABLE_COMPLETE.
		 * This can be overridden to suit the needs of the project.
		 * 
		 * <p>Dispatches a <code>StateEvent.DISABLE_COMPLETE</code> event.  If overridden, please make sure this event is still dispatched.</p>
		 * @param	e
		 */
		protected function notifyDisableComplete(e:StateEvent):void
		{//notifyDisableComplete
			//trace("State Controller Notify Disable Complete");
			dispatchEvent(new StateEvent(StateEvent.DISABLE_COMPLETE, this, false, false));
		}//notifyDisableComplete
		
		/**
		 * A convenience method for notifying of a ENABLE_COMPLETE.
		 * This can be overridden to suit the needs of the project.
		 * 
		 * <p>Dispatches a <code>StateEvent.ENABLE_COMPLETE</code> event.  If overridden, please make sure this event is still dispatched.</p>
		 * 
		 * @param	e
		 */
		protected function notifyEnableComplete(e:StateEvent):void
		{//notifyEnableComplete
			//trace("State Controller Notify Enable Complete");
			dispatchEvent(new StateEvent(StateEvent.ENABLE_COMPLETE, this, false, false));
		}//notifyEnableComplete
	
		/**
		 * A convenience method for notifying of a EXIT_COMPLETE.
		 * This can be overridden to suit the needs of the project.
		 * 
		 * <p>Dispatches a <code>StateEvent.EXIT_COMPLETE</code> event.  If overridden, please make sure this event is still dispatched.</p>
		 * 
		 * @param	e
		 */
		protected function notifyExitComplete(e:StateEvent):void
		{//notifyExitComplete
			//trace("State Controller Notify Exit Complete");
			dispatchEvent(new StateEvent(StateEvent.EXIT_COMPLETE, this, false, false));
		}//notifyExitComplete
		
		/**
		 * A convenience method for notifying of a ENTER_COMPLETE.
		 * This can be overridden to suit the needs of the project.
		 * 
		 * <p>Dispatches a <code>StateEvent.ENTER_COMPLETE</code> event.  If overridden, please make sure this event is still dispatched.</p>
		 * 
		 * @param	e
		 */
		protected function notifyEnterComplete(e:StateEvent):void
		{//enterComplete
			//trace("State Controller Notify Enter Complete");
			dispatchEvent(new StateEvent(StateEvent.ENTER_COMPLETE, this, false, false));
		}//enterComplete
		
		///////////////////////////// GETTERS / SETTERS ///////////////////////
		
		/**
		 * Returns the list of sub-objects
		 */
		public function get subObjList():Array
		{//get subObjList
			return _subObjList;
		}//get subObjList
		
		/////////////////////////// OVERRIDES //////////////////////////////
		/**
		 * Traces the name of this controller class
		 * @return returns the name of this controller's class as a string.
		 */
		public override function toString():String
		{//toString
			return ("StateController: " + (GetStateName(this)));
		}//toString
	}//StateController Class
	
}