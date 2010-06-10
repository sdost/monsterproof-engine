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
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import com.jac.fsm.stateEvents.StateChangeEvent;
	import com.jac.fsm.stateEvents.StateEvent;
	
	/**
	* Dispatched when the enter procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.ENTER_COMPLETE
	*/
	[Event("ENTER_COMPLETE", type = "com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched when the exit procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.EXIT_COMPLETE
	*/
	[Event("EXIT_COMPLETE", type = "com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched just before a state change is about to take place, but just after the <code>_nextState</code> property is populated.
	* 
	* <p>
	* To determine when the state change is complete listen for the <code>StateEvent.ENTER_COMPLETE</code> notification.
	* </p>
	* 
	* @eventType com.jac.fsm.stateEvents.StateChangeEvent.CHANGE
	* 
	* @see com.jac.fsm.stateEvents.StateEvent StateEvent.ENTER_COMPLETE
	*/
	[Event("CHANGE", type="com.jac.fsm.stateEvents.StateChangeEvent")]
	
	/**
	 * A Class that handles the actual state switching.  It deals with two <code>StateControllers</code>, the previous state, and the next state.
	 * It calls disable and exit on the previous state, then disable, enter, and enable on the next state.  Each state is responsible for notifiying
	 * the state machine that it has completed, entering, exiting, enabling and disabling.
	 * <p>
	 * A StateMachine execution of changeState looks like this:
	 * <ul>
	 * 	<li>Disable Previous StateController if such state exists</li>
	 *	<li>Disable Next State StateController (before state is switched)</li>
	 *	<li>Wait for the previous StateController to report all of its sub objects have been disabled.</li>
	 *	<li>Wait for the next state StateController to report all of its sub objects have been disabled.</li>
	 *	<li>Exit Previous State</li>
	 *	<li>Wait for previous state to report all of its sub objects have finished exiting.</li>
	 *	<li>Enter Next State</li>
	 *	<li>Wait for next state to report all of its sub objects have finished entering.</li>
	 *	<li>Enable next state.</li>
	 *	<li>Wait for next state to report all of its sub objects have finished enabling.</li>
	 *	</ul>
	 * </p>
	 */
	public class StateMachine extends EventDispatcher
	{//SateMachine Class
		
		//private vars
		protected var _currentState:StateController;
		protected var _previousState:StateController;
		protected var _nextState:StateController;
		
		protected var _inTransition:Boolean;
		protected var _blockDuringTransitions:Boolean;
		protected var _disableDuringTransitions:Boolean;
		
		protected var _waitForDisableCount:int = 0;
		protected var _numDisables:int = 0;
		protected var _waitForEnableCount:int = 0;
		protected var _numEnables:int = 0;
		
		protected var _blendTransitions:Boolean = false;
		
		/**
		 * Constructor to initialize a new StateMachine.
		 * 
		 * @param	blockDuringTransitions if true, disallows state switching while in transition (true is recommended)
		 * @param	disableDuringTransitions if true, calls disable on the current state and the next state until the transition ends, which then calls enable
		 */
		public function StateMachine(blockDuringTransitions:Boolean = true, disableDuringTransitions:Boolean = true ) 
		{//StateMachine
		
			_blockDuringTransitions = blockDuringTransitions;
			_disableDuringTransitions = disableDuringTransitions;
		
			 _currentState = null;
			 _previousState = null;
			 _nextState = null;
		}//StateMachine
		
		/**
		 * Calls the update function on the currentState.  This can be used to run a "tick" system such as for a game loop.  Each state
		 * could be notified of the "tick" and update as necessary for that particular frame.
		 */
		public function update():void
		{//Update
			if( _currentState )
			{
				_currentState.update();
			}

		}//Update
		
		 /**
		  * Switches the currentState to the newState.
		  * The operational flow is as follows:
		  * <ul>
		  * <li>Disable Previous StateController if such state exists </li>
		  * <li>Disable Next State StateController (before state is switched)</li>
		  * <li>Wait for the previous StateController to report all of its sub objects have been disabled.</li>
		  * <li>Wait for the next state StateController to report all of its sub objects have been disabled.</li>
		  * <li>Exit Previous State</li>
		  * <li>Wait for previous state to report all of its sub objects have finished exiting.</li>
		  * <li>Enter Next State</li>
		  * <li>Wait for next state to report all of its sub objects have finished entering.</li>
		  * <li>Wait for next state to report all of its sub objects have finished enter.</li>
		  * <li>Enable next state.</li>
		  * </ul>
		  * 
		  * <p>Dispatches a <code>StateChangeEvent.CHANGE</code> event just before the change starts</p>
		  * 
		  * @param	newState A StateController object to enter into after the current state has exited.
		  * @param	blendTransitions if set to <code>true</code> the current state will be told to exit(), and the next state will be told to enter() at the same time.
		  * 
		  * @return True is returned if the change was started <code>(!newState || (_inTransition &#38;&#38; _blockDuringTransitions))</code> resulted in true.
		  * 		Returns False if the change wasn't started because of <code>(!newState || (_inTransition &#38;&#38; _blockDuringTransitions))</code> resulted in false.
		  */
		public function changeState(newState:StateController, blendTransitions:Boolean = false ):Boolean
		{//ChangeState
			//trace("Change State: " + newState + " / " + _inTransition + " / " + _blockDuringTransitions);
			
			//Set flag
			_blendTransitions = blendTransitions;
			
			//Sanity check state
			if (!newState || (_inTransition && _blockDuringTransitions)) 
			{//don't switch
				trace("------------ State change failed Sanity/Transition Test ----------");
				trace("NewState: ", newState, "\n_inTransition: ", _inTransition, "\n_blockDuringTransitions: ", _blockDuringTransitions);
				return false;
			}//don't switch
			else
			{//switch
				//Save state
				_nextState = newState;
				//_nextState.stateMachine = this;
				notifyStateChange();
				
				//Successful change started
				return true;
			}//switch

		}//ChangeState
		
		/**
		 * Dispatches a <code>StateChangeEvent.CHANGE</code> event, and then calls <code>disableStates()</code>
		 * 
		 * @see #disableStates()
		 */
		private function notifyStateChange():void
		{//notifyStateChange
			//Notify that a change is taking place
			dispatchEvent(new StateChangeEvent(StateChangeEvent.CHANGE, _nextState, _currentState, false, false));
			disableStates();
		}//notifyStageChange
		
		 /**
		  *  Calls disable on the current StateController during a state switch.  Execution continues after a <code>StateEvent.DISABLE_COMPLETE</code> event is caught.
		  *  This is an intermediate step in a state switch and can be overriden if needed when being subclassed.
		  */
		protected function disableStates():void
		{//disableStates
			//reset count
			_waitForDisableCount = 0;
			_numDisables = 0;
			if (_currentState) { _numDisables++;}
			if (_nextState) { _numDisables++;}
			
			if (_currentState)
			{//disable
				if (_disableDuringTransitions)
				{//disable
					//trace("Disable currentState: " + _currentState);
					_currentState.addEventListener(StateEvent.DISABLE_COMPLETE, switchStates, false, 0, true);
					_currentState.disable();
				}//disable
			}//disable
			
			if (_nextState)
			{//disable
				if (_disableDuringTransitions)
				{//disable
					//trace("Disable newState: " + _nextState);
					_nextState.addEventListener(StateEvent.DISABLE_COMPLETE, switchStates, false, 0, true);
					_nextState.disable();
				}//disable
			}//disable

		}//disableStates
		
		/**
		 * Calls enable on the current StateController during a state switch.  Execution continues after a <code>StateEvent.ENABLE_COMPLETE</code> event is caught at <code>changeCompleted()</code>.
		 * This is an intermediate step in a state switch and can be overriden if needed when being subclassed.
		 * 
		 * @see #changeCompleted()
		 * 
		 */
		protected function enableStates():void
		{//enableStates
			
			//reset count
			_waitForEnableCount = 0;
			_numEnables = 0;
			
			if (_nextState) { _numEnables++;}
			
			if (_nextState)
			{//enable
				if (_disableDuringTransitions)
				{//enable
					//trace("Enable newState: " + _nextState);
					_nextState.addEventListener(StateEvent.ENABLE_COMPLETE, changeCompleted, false, 0, true);
					_nextState.enable();
				}//enable
			}//enable

		}//enableStates
		
		 /**
		  * This function is called during a state change, generally after Disable has finished.
		  * This exits the current StateController (if there is one) and waits for <code>StateEvent.EXIT_COMPLETE</code> to continue execution.
		  * 
		  * @param	e StateEvent, usually after disable has completed.
		  */
		protected function switchStates(e:StateEvent):void
		{//switchStates
			//Clean up events
			e.target.removeEventListener(StateEvent.DISABLE_COMPLETE, switchStates, false);
			
			//Update count
			_waitForDisableCount++;
			
			if (_waitForDisableCount < _numDisables)
			{//bail
				//trace("Not All Disabled Yet Disable Count: " + _waitForDisableCount + " / " + _numDisables);
				return;
			}//bail
			
			if (_currentState)
				{//Manage current state
					//trace("Exit Prev State: " + _currentState);
					_inTransition = true;
					
					if (!_blendTransitions)
					{//exit, then enter
						_currentState.addEventListener(StateEvent.EXIT_COMPLETE, enterNextState);
						_currentState.exit();
					}//exit, then enter
					else
					{//exit & enter at the same time
						_currentState.addEventListener(StateEvent.EXIT_COMPLETE, notifyOfStateExit);
						_currentState.exit();
						enterNextState();
					}//exit & enter at the same time
					
				}//Manage current state
			else
				{//no prev, just enter next
					//trace("No Prev, just enter");
			
					_inTransition = true;
					_nextState.reset();
					_nextState.addEventListener(StateEvent.ENTER_COMPLETE, stateEntered);
					_nextState.enter();
				}//no prev, just enter next
						
		}//switchStates

		/**
		 * Second to last step for state change.
		 * 
		 * Generally called after switchStates has completed.
		 * 
		 * @param	e StateEvent (probably from ENTER_COMPLETE)
		 */
		protected function stateEntered(e:StateEvent):void
		{//stateEntered
			//trace("Stated Entered: " + e.target);
			_nextState.removeEventListener(StateEvent.ENTER_COMPLETE, stateEntered);
			
			//Enable states, when this finished, changeCompleted is called
			enableStates();
			
		}//stateEntered
		
		 /**
		  * Final step for state change.
		  *
		  * Updates internal properties (_previousState, _currentState, _inTransition)
		  * 
		  * Dispatches <code>StateEvent.ENTER_COMPLETE</code> when finished.
		  * 
		  * Called repeatedly until all sub objects have entered. 
		  * 
		  * @param	e StateEvent (probably ENABLE_COMPLETE)
		  */
		protected function changeCompleted(e:StateEvent):void
		{//changeCompleted
		
			//Clean up events
			e.target.removeEventListener(StateEvent.ENABLE_COMPLETE, changeCompleted, false);
			
			//update count
			_waitForEnableCount++;
			
			if (_waitForEnableCount < _numEnables)
			{//bail
				//trace("Not All Disabled Yet Disable Count: " + _waitForEnableCount + " / " + _numEnables);
				return;
			}//bail
		
			//Save States
			_previousState = _currentState;
			_currentState = _nextState;
			
			/*trace("ENTER COMPLETED!!");
			trace("CurrentState:  " + GetStateName(_currentState));
			trace("PrevState: " + GetStateName(_previousState));*/
			
			//Manage flags
			_inTransition = false;
			
			//Notify
			dispatchEvent(new StateEvent(StateEvent.ENTER_COMPLETE, null, false, false));
		}//changeCompleted
		
		/**
		 * Dispatches a <code>StateEvent.EXIT_COMPLETE</code> event.
		 * @param	e
		 */
		protected function notifyOfStateExit(e:StateEvent=null):void
		{//notifyOfStateExit
			//Notify of Previous state exit completion
			dispatchEvent(new StateEvent(StateEvent.EXIT_COMPLETE, null, false, false));
		}//notifyOfStateExit
		
		 /**
		  * Intermediate step during a state change.
		  * Calls <code>enter()</code> on the next StateController.
		  * 
		  * <p>Generally called after Disable and Exit has completed on the previous state.</p>
		  * 
		  * @param	e
		  */
		protected function enterNextState(e:StateEvent=null):void
		{//enterNextState
		
			//trace("\nState machine: " + this + " caught exit finished for: " + e.target + "\n");
		
			if (!_blendTransitions)
			{//notify of exit
				_currentState.removeEventListener(StateEvent.EXIT_COMPLETE, enterNextState);
				notifyOfStateExit();
			}//notify of exit
			
			//Manage flags
			_inTransition = true;
			
			//Add listener and enter next state
			_nextState.addEventListener(StateEvent.ENTER_COMPLETE, stateEntered);
			_nextState.enter();
		}//enterNextState
		
		
		/**
		 * CURRENTLY NOT IMPLEMENTED!
		 */
		private function goToPreviousState():void
		{//GoToPreviousState
			//changeState(_previousState);
		}//GoToPreviousState
		
		
		/**
		 * CURRENTLY NOT IMPLEMENTED!
		 */
		private function goToNextState(e:Event=null):void
		{//GoToNextState
			//changeState(_nextState);
		}//GoToNextState
		
		/**
		 * Sets _previousState, _nextState, _currentState to null.
		 * 
		 * This should not really be needed, but is left in for convenience.
		 */
		public function clearStates():void
		{//clearStates
			_previousState = null;
			_nextState = null;
			_currentState = null;
		}//clearStates

		///////////////////////////////// GETTERS / SETTERS /////////////////////////////////
		
		/**
		 * Returns reference to the next StateController
		 * <p>Force the next state property.  Very rare that this will ever need to be set outside of this class.</p>
		 */
		public function set nextState(state:StateController):void
		{//SetNextState
			_nextState = state;
		}//SetNextState
		
		/**
		 * @private
		 */
		public function get nextState():StateController
		{//get nextState
			return _nextState;
		}//get nextState
		
		/**
		 * Returns reference to the current StateController
		 */
		public function get currentState():StateController
		{//currentState
			return _currentState;
		}//currentState
		
		/**
		 * Returns the previous StateController (please note the object this references may no longer exist)
		 */
		public function get previousState():StateController
		{//get previousState
			return _previousState;
		}//get previousSate
		
		/////////////////////////// OVERRIDES //////////////////////////////
		/**
		 * Returns class name of the StateMachine.
		 * 
		 * @return the Class name of the stateMachine.
		 */
		public override function toString():String
		{//toString
			return ("StateMachine: " + (GetStateName(this)));
		}//toString
	}//StateMachine Class	
	
	
}
