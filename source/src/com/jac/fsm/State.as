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
	import flash.events.EventDispatcher;
	import com.jac.fsm.interfaces.IState;
	
	/**
	 * This is the base (template) class from which all states should be modeled from.
	 */
	public class State extends EventDispatcher implements IState
	{//State Class
		/**
		 * State object constructor.
		 */
		public function State() 
		{//State
		}//State
		
		/**
		 * @inheritDoc
		 */
		public function update():void
		{//Update
		}//Update
		
		/**
		 * @inheritDoc
		 */
		public function enter():void
		{//Enter
		}//Enter
		
		/**
		 * @inheritDoc
		 */
		public function exit():void
		{//Exit
		}//Exit
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{//reset
		}//reset
		
		/**
		 * @inheritDoc
		 */
		public function exitComplete():void
		{//exitComplete
		}//exitComplete
		
		/**
		 * @inheritDoc
		 */
		public function enterComplete():void
		{//enterComplete
		}//enterComplete
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{//enable
		}//enable
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{//disable
		}//disable
		
	}//State Class
	
}