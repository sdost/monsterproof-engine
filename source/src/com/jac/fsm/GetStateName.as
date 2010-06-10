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
	import flash.utils.*;
	
	 /**
	  * Convenience function to return a human readble state name;
	
	  * @param	myObj Object to get the class name of (non-fully qualified)
	  * @return String that is the state name
	  */
	public function GetStateName(myObj:Object):String
	{//getClassName
		var tokens:Array;
		var fullClassName:String = getQualifiedClassName(myObj);
		tokens = fullClassName.split("::");
		return tokens[tokens.length - 1];
	}//getClassName
	
}