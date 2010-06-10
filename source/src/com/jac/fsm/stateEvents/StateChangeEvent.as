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
	import com.jac.fsm.interfaces.IState;
	import flash.events.Event;
	import com.jac.fsm.StateController;
	
	public class StateChangeEvent extends Event 
	{
		
		public static const CHANGE:String = "change";
		
		private var _nextState:StateController = null;
		private var _prevState:StateController = null;
		
		public function StateChangeEvent(type:String, nextState:StateController = null, prevState:StateController = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_nextState = nextState;
			_prevState = prevState;
		} 
		
		public override function clone():Event 
		{ 
			return new StateChangeEvent(type, _nextState, _prevState, bubbles, cancelable);
		} 
		
		/*
		public override function toString():String 
		{ 
			return formatToString("StateChangeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		*/
		
		public function get nextState():StateController
		{//get nextState
			if (_nextState != null)
			{//safe
				return _nextState;
			}//safe
			else
			{//error
				//throw Error("StateChangeEvent Error: nextState is null!!");
				trace("StateChangeEvent Error: nextState is null!!");
				return null;
			}//error
		}//get nextState
		
		public function get prevState():StateController
		{//get nextState
			if (_prevState != null)
			{//safe
				return _prevState;
			}//safe
			else
			{//error
				//throw Error("StateChangeEvent Error: prevState is null!!");
				trace("StateChangeEvent Error: prevState is null!!");
				return null;
			}//error
		}//get nextState
		
	}
	
}