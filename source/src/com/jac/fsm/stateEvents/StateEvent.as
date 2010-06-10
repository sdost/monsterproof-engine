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

package com.jac.fsm.stateEvents 
{
	import com.jac.fsm.StateMachine;
	import flash.events.Event;
	import com.jac.fsm.StateController;
	import com.jac.fsm.StateView;
	
	/**
	 * ...
	 * @author 
	 */
	public class StateEvent extends Event 
	{
		static public const ENTER_COMPLETE:String = "enter_complete";
		static public const EXIT_COMPLETE:String = "exit_complete";
		static public const CHANGE:String = "change";
		static public const ENABLE_COMPLETE:String = "enable_complete";
		static public const DISABLE_COMPLETE:String = "disable_complete";
		
		private var _stateController:StateController = null;
		
		public function StateEvent(type:String, stateController:StateController = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			if (stateController)
			{//save props
				_stateController = stateController;
			}//save props
			
		} 
		
		public override function clone():Event 
		{ 
			return new StateEvent(type, _stateController, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}