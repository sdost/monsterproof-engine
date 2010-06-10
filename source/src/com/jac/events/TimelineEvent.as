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

package com.jac.events
{
	import flash.events.Event;
	
	public class TimelineEvent extends Event 
	{
		
		static public const ANIMATION_EXIT_COMPLETE:String = "animationExitComplete";
		static public const ANIMATION_ENTER_COMPLETE:String = "animationEnterComplete";
		static public const ANIMATION_ENABLE_COMPLETE:String = "animationEnableComplete";
		static public const ANIMATION_DISABLE_COMPLETE:String = "animationDisableComplete";
		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TimelineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TimelineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}