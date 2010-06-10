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
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.jac.fsm.interfaces.IState;
	import com.jac.fsm.stateEvents.StateEvent;
	
	/**
	* Dispatched when the enable procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.ENABLE_COMPLETE
	*/
	[Event("ENABLE_COMPLETE", type="com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	* Dispatched when the disable procedure of this controller and all sub views have completed.
	* 
	* @eventType com.jac.fsm.stateEvents.StateEvent.DISABLE_COMPLETE
	*/
	[Event("DISABLE_COMPLETE", type = "com.jac.fsm.stateEvents.StateEvent")]
	
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
	[Event("EXIT_COMPLETE", type="com.jac.fsm.stateEvents.StateEvent")]
	
	/**
	 * This is a class that can be assigned to an object in the library or created new in code.  It fullfills all of the requirements
	 * of a State object.  This can can be controlled by a StateController, or a StateViewController.
	 */
	 
	public class StateView extends MovieClip implements IState
	{//StateView class
	
		private var _isOnStage:Boolean = false;
		private var _subViewList:Array = new Array();
		private var _instanciatedFromIDE:Boolean = false;
		
		/**
		 * This is a class that can be assigned to an object in the library or created new in code.  It fullfills all of the requirements
		 * of a State object.  This can can be controlled by a StateController, or a StateViewController.
		 * <p>
		 * This object can also have sub objects of type <code>StateView</code>.  These will automatcially be found and returned through the
		 * <code>subViews</code> getter
		 * </p>
		 * 
		 * @see StateViewController
		 * @see StateController
		 * @see #subViews
		 */
		public function StateView() 
		{//StateView
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
			
			//check if added in IDE
			if (this.parent)
			{//set hasParent
				_instanciatedFromIDE = true;
				//trace("Instanciating: " + GetStateName(this) + " with a parent of: " + this.parent.name);
			}//set hasParent
		}//StateView
		
		/////////////////////////// EVENT HANDLERS ////////////////////////
		/**
		 * Maintains the <code>_isOnStage</code> property.
		 * @param	e
		 */
		protected function addedToStageHandler(e:Event):void
		{//addedToStageHandler
			//trace(GetStateName(this) + " was added to stage and is a child of: " + this.parent.name);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false);
			_isOnStage = true;
		}//addedToStageHandler
		
		/**
		 * Maintains the <code>_isOnStage</code> property.
		 * @param	e
		 */
		protected function removedFromStageHandler(e:Event):void 
		{//removedFromStageHandler
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_isOnStage = false;
		}//removedFromStageHandler
		
		/////////////////////////// IState Required functions /////////////////////////
		/**
		 * @inheritDoc
		 */
		public function update():void
		{//update
			//Do nothing
		}//update
		
		/**
		 * @inheritDoc
		 * 
		 * @see #enableComplete()
		 */
		public function enable():void
		{//enable
			mouseChildren = true;	
			mouseEnabled = true;
			enableComplete();
		}//enable
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{//disable
			mouseChildren = false;
			mouseEnabled = false;
			disableComplete();
		}//disable
		
		/**
		 * @inheritDoc
		 * 
		 * @see #enterComplete()
		 */
		public function enter():void
		{//enter
			//trace("State View Enter: " + this);
			//visible = true;
			enterComplete();
		}//enter
		
		/**
		 * @inheritDoc
		 * 
		 * @see #exitComplete()
		 */
		public function exit():void
		{//exit
			//trace("State View Exit: " + this + " / " + GetStateName(this));
			//visible = false;
			exitComplete();
		}//exit
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{//reset
			//trace("Reset: " + this);
			visible = false;
		}//reset
		
		/**
		 * Dispatches a <code>StateEvent.ENTER_COMPLETE</code> event when the enter has finished.
		 * 
		 * @see #enter()
		 */
		public function enterComplete():void
		{//enterComplete
			//trace("Enter Complete: " + this);
			dispatchEvent(new StateEvent(StateEvent.ENTER_COMPLETE, null, false, false));
		}//enterComplete
		
		/**
		 * Dispatches a <code>StateEvent.EXIT_COMPLETE</code> event when the exit has finished.
		 * 
		 * @see #exit()
		 */
		public function exitComplete():void
		{//exitComplete
			//trace("State View Exit Complete: " + this + " " + GetStateName(this));
			dispatchEvent(new StateEvent(StateEvent.EXIT_COMPLETE, null, false, false));
		}//exitComplete
		
		
		/**
		 * Dispatches a <code>StateEvent.ENABLE_COMPLETE</code> event when the enable has finished.
		 * 
		 * @see #enable()
		 */
		protected function enableComplete():void
		{//enableComplete
			dispatchEvent(new StateEvent(StateEvent.ENABLE_COMPLETE, null, false, false));
		}//enableComplete
		
		
		/**
		 * Dispatches a <code>StateEvent.DISABLE_COMPLETE</code> event when the disable has finished.
		 * 
		 * @see #disable()
		 */
		protected function disableComplete():void
		{//disableComplete
			dispatchEvent(new StateEvent(StateEvent.DISABLE_COMPLETE, null, false, false));
		}//disableComplete
		
		/////////////////////////// OVERRIDES //////////////////////////////
		public override function toString():String
		{//toString
			return ("StateView: " + (GetStateName(this)));
		}//toString
		
		//////////////////////// GETTERS / SETTERS //////////////////////////
		public function get isOnStage():Boolean
		{//get isOnStage
			return _isOnStage;
		}//get isOnStage
		
		//get subViews may not get used...
		public function get subViews():Array
		{//subViews
			_subViewList = new Array();
			
			for (var i:int = 0; i < numChildren; i++)
			{//find sub views
				var currentChild:* = getChildAt(i);
				if (currentChild is StateView)
				{//found one
					//trace("-- Pushing SubView: " + GetStateName(currentChild) + " into " + GetStateName(this));
					_subViewList.push(currentChild);
				}//found one
			}//find sub views
			
			return _subViewList;
		}//subViews
		
		/**
		 * A Boolean that is set to <code>true</code> if the view was found on stage, and put there in the IDE.  This will return <code>false</code>
		 * if the view was instanciated through code.
		 */
		public function get instanciatedFromIDE():Boolean 
		{//get hasParent
			return _instanciatedFromIDE; 
		}//get hasParent
		
	}//StateView class
	
}