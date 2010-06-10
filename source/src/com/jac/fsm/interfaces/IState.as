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

package com.jac.fsm.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * An interface for <code>State</code> compliant objects.  
	 * 
	 * Please be sure that the following stateEvents are dispatched at the appropriate times:
	 * <Listing Version="3.0">
		ENTER_COMPLETE
		EXIT_COMPLETE
		ENABLE_COMPLETE
		DISABLE_COMPLETE
	 * </Listing>
	 * 
	 */
	public interface IState extends IEventDispatcher
	{//IState
		
		/**
		 * A function that is called externally when the state's contents should update itself.
		 */
		function update():void;	//Called every tick
		
		/**
		 * Called when the state needs to start its entrance.
		 * <p>
		 * <B>THIS MUST DISPATCH A <code>StateEvent.ENTER_COMPLETE</code> EVENT WHEN THE ENTER IS FINISHED.</B>
		 * </p>
		 */
		function enter():void;	//Called once when state is first entered
		
		/**
		 * Called when the state needs to start its exit.
		 * <p>
		 * <B>THIS MUST DISPATCH A <code>StateEvent.EXIT_COMPLETE</code> EVENT WHEN THE EXIT IS FINISHED.</B>
		 * </p>
		 */
		function exit():void;		//Called once and lastly before the state is left.
		
		/**
		 * Called when the state needs to be reset.
		 */
		function reset():void;		//Called to init and/or reset the state
		
		/**
		 * MUST be called when the enter is completed for this state. This is required!
		 */
		//function enterComplete():void;	//Called by the enter function when the "Enter" is complete
		
		/**
		 * MUST be called when the exit is completed for this state. This is required!
		 */
		//function exitComplete():void;	//Called by the exit function when the "Exit" is complete
		
		/**
		 * Called after the state has been entered.
		 * The state could possibly disable mouse events here.
		 * 
		 * <p>
		 * <B>THIS MUST DISPATCH A <code>StateEvent.ENABLE_COMPLETE</code> EVENT WHEN THE ENABLE IS FINISHED.</B>
		 * </p>
		 */
		function enable():void;			//Called to enable (maybe mouse events?) the state
		
		/**
		 * Called before the state transistion.
		 * The state could possibly enable mouse events here.
		 * 
		 * <p>
		 * <B>THIS MUST DISPATCH A <code>StateEvent.DISABLE_COMPLETE</code> EVENT WHEN THE DISABLE IS FINISHED.</B>
		 * </p> 
		 */
		function disable():void;		//Called to disable (maybe mouse events?) the state
	}//IState
	
}