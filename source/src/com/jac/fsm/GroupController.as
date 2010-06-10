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
	/**
	 * This class is used to manage a list of Controllers
	 * 
	 * @see StateController
	 */
	public class GroupController extends StateController
	{//GroupController Class
	
		 /**
		  * Creates a new GroupController.
		  * @param	controllerList An Array of StateControllers
		  */
		public function GroupController(controllerList:Array) 
		{//GroupController
			super();
			
			_subObjList = new Array();
			registerSubControllers(controllerList);
		}//GroupController
				
		/////////////// MANAGEMENT FUNCTIONS //////////////////
		
		 /**
		  * Registers each of the StateControllers' sub controllers with this GroupController
		  * 
		  * @param	controllerList Array of StateControllers to register.
		  */
		protected function registerSubControllers(controllerList:Array):void
		{//registerSubViews
			for (var i:int = 0; i < controllerList.length; i++)
			{//find views
				if (controllerList[i] is StateController)
				{//add
					if (controllerList[i].subObjList.length > 0)
					{//find more
						registerSubControllers(controllerList[i].subObjList);
					}//find more
					
					//Register Controller
					//trace("Registering Controller: " + controllerList[i]);
					registerSubObject(controllerList[i]);
				}//add
			}//find views
		}//registerSubViews
	}//GroupController Class
	
}