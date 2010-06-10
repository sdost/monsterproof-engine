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
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import com.jac.fsm.stateEvents.StateEvent;
	
	/**
	 * This is the controller for each display state of type <code>StateView</code>.  This must contain a <code>StateView</code> object that it controls.
	 */
	public class StateViewController extends StateController implements IState
	{//StateViewController class
	
		private var _container:MovieClip;
	
		private var _viewExitCount:int = 0;
		private var _viewEnterCount:int = 0;
		
		 /**
		  * This is the controller for each display state of type <code>StateView</code>.  This must contain a <code>StateView</code> object that it controls.
		  * 
		  * @param	stateViewList an array of views to be controlled by this controller.
		  * @param	container a MovieClip that will be used to contain and be the parent of the items in the <code>stateViewList</code> parameter.
		  */
		public function StateViewController(stateViewList:Array, container:MovieClip) 
		{//StateViewController
			super();
			//trace("Setting container to: " + container + " " + container.name);
			_container = container;
			_subObjList = new Array();
			registerSubViews(stateViewList);
		}//StateViewController
		
		/**
		 * This registers any views in the view list as well as recursively searching through those views for other views contained within.
		 * If it finds more views contained, it will register those as well.
		 * 
		 * @param	viewList
		 */
		private function registerSubViews(viewList:Array):void
		{//registerSubViews
			for (var i:int = 0; i < viewList.length; i++)
			{//find views
				if (viewList[i].subViews.length > 0)
				{//find more
					registerSubViews(viewList[i].subViews);
				}//find more
				
				//Register view
				registerSubObject(viewList[i]);
			}//find views
		}//registerSubViews
				
		///////////////////// MANAGEMENT FUNCTIONS /////////////////////
		/**
		 * @inheritDoc
		 */
		override public function registerSubObject(newStateView:IState):void
		{//registerStateView
			if (!(newStateView is StateView))
			{//error
				throw Error("StateViewController:unregisterSubObject: expected StateView, got " + newStateView + ".");
			}//error
			else
			{//good
				_subObjList.push(newStateView);
			}//good
			
		}//registerStateView
		
		/**
		 * @inheritDoc
		 */
		override public function unregisterSubObject(oldStateView:IState):void
		{//unregisterStateView
			if (!(oldStateView is StateView))
			{//error
				throw Error("StateViewController:unregisterSubObject: expected StateView, got " + oldStateView + ".");
			}//error
			else
			{//good
				var removedAny:Boolean = false;
				for (var i:int = 0; i < _subObjList.length; i++)
				{//find
					if (_subObjList[i] == oldStateView)
					{//remove
						removedAny = true;
						_subObjList.splice(i, 1);
						break;
					}//remove
				}//find
				
				if (!removedAny)
				{//warning
					trace("--FSM--StateViewController--: Did not find " + oldStateView + " in registered stateViewList list");
				}//warning
			}//good
			
		}//unregisterStateView
		
		///////////////////// CONTROLLING FUNCTIONS ////////////////////
		/**
		 * When called, this will add all of the views and subviews to the display list. Once that has completed, it 
		 * calls <code>enter()</code> on each of those added views.
		 */
		override public function enter():void 
		{//enter
			addToDisplayList();
			enterSubObjects();
		}//enter
		
		/**
		 * @inheritDoc
		 */
		override protected function handleExitComplete(e:StateEvent):void
		{//handleExitComplete
			//trace("StateViewController handleExitComplete: " + e.target);
			exitComplete(e);
		}//handleExitComplete
		
		/**
		 * Adds all of the views and subviews to the <code>_container</code> clip, essentially adding them to the display list.
		 * 
		 * @see _container
		 */
		public function addToDisplayList():void
		{//addToDisplayList
			for (var i:int = 0; i < _subObjList.length; i++)
			{//add them
				if (!_subObjList[i].instanciatedFromIDE)
				{//add
					//trace("-- Adding " + _subObjList[i] + " " + _subObjList[i].name + " to " + _container + " " + _container.name);
					_container.addChild(_subObjList[i]);
				}//add
				else
				{//already added
					trace("-- Already Added: " + _subObjList[i] + " " + _subObjList[i].name + " to " + _subObjList[i].parent + " / " + _subObjList[i].parent.name);
				}//already added
			}//add them
		}//addToDisplayList
		
		/**
		 * Removes all of the children of <code>_container</code> from the display list.
		 */
		public function removeFromDisplayList():void
		{//removeFromDisplayList
			for (var i:int = 0; i < _subObjList.length; i++)
			{//add them
				//trace("-- Removing " + _subObjList[i] + " " + _subObjList[i].name + " from " + _subObjList[i].parent + " " + _subObjList[i].parent.name);
				
				//Don't remove if put there in the ide
				if (!_subObjList[i].instanciatedFromIDE)
				{//remove
					_subObjList[i].parent.removeChild(_subObjList[i]);
				}//remove
				
			}//add them
		}//removeFromDisplayList
		
		/**
		 * @inheritDoc
		 */
		override protected function exitComplete(e:StateEvent):void 
		{//exitComplete
			e.target.removeEventListener(StateEvent.EXIT_COMPLETE, handleExitComplete);
			
			//inc count
			_exitCount++;
			
			//trace("SVC:Exiting: " + e.target + " / " + _exitCount + " / " + _subObjList.length);
			
			if (_exitCount == _subObjList.length)
			{//done !
				//trace(this + " Exit Completed, notifying...");
				_subObjList.reverse();
				removeFromDisplayList();
				notifyExitComplete(new StateEvent(StateEvent.EXIT_COMPLETE, this, false, false));
			}//done!
		}//exitComplete

		
		////////////////////////////// EVENT HANDLERS ////////////////////////////
				
		///////////////////////////// GETTERS/ SETTERS //////////////////////////////////
		
		/**
		 * returns a list of the sub views.
		 */
		public function get stateViews():Array
		{//get stateView
			return _subObjList;
		}//get stateView
		
		/**
		 * Returns or sets the container object of all of the sub views.
		 */
		public function get container():MovieClip 
		{ 
			return _container; 
		}
		/**
		 * @private
		 */
		public function set container(value:MovieClip):void 
		{
			_container = value;
		}
		
		////////////////////////// OVERRIDES /////////////////////
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{//toString
			return ("StateViewController: " + GetStateName(this));
		}//toString
	}//StateViewController class
	
}