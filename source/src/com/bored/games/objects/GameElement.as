package com.bored.games.objects 
{
	import com.bored.games.actions.Action;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameElement extends MovieClip
	{	
		protected var _actions:Vector.<Action>;
		protected var _actionsQueued:Vector.<Action>;
		protected var _actionsActive:Vector.<Action>;
		protected var _actionsFinished:Vector.<Action>;
		
		private var _lastUpdateTime:Number;
			
		public function GameElement() 
		{			
			_actions = new Vector.<Action>();
			_actionsQueued = new Vector.<Action>();
			_actionsActive = new Vector.<Action>();
			_actionsFinished = new Vector.<Action>();
		}//end constructor()
		
		public function addAction(a_action:Action):void
		{
			if ( !checkForActionNamed(a_action.actionName) ) 
			{
				_actions.push(a_action);
			}
		}//end addAction()
		
		public function checkForActionNamed(a_name:String):Boolean
		{
			for each ( var action:Action in _actions )
			{
				if (action.actionName == a_name) return true;
			}
			
			return false;
		}//end checkForActionNamed()
		
		public function activateAction(a_name:String):void
		{
			for each ( var action:Action in _actions ) 
			{
				if (action.actionName == a_name)
				{
					_actionsQueued.push(action);
					action.startAction();
				}
			}
		}//end activateAction()
		
		public function deactivateAction(a_name:String):void
		{
			for each ( var action:Action in _actionsActive ) 
			{
				if (action.actionName == a_name)
				{
					action.finished = true;
				}
			}
		}//end deactivateAction()
		
		public function removeAction(a_name:String):void
		{
			for each ( var action:Action in _actions )
			{
				if ( action.actionName == a_name)
				{
					var ind:uint = _actions.indexOf(action);
					_actions.splice(ind, 1);
				}
			}
		}//end removeAction()
		
		public function update(t:Number = 0):void
		{
			_lastUpdateTime = t;
			
			while ( _actionsQueued.length > 0 )
			{
				_actionsActive.push( _actionsQueued.pop() );
			}
			
			for each( var action:Action in _actionsActive ) 
			{
				if ( action.finished )
				{
					_actionsFinished.push(action);
				}
				else
				{
					action.update(t);
				}
			}
			
			while ( _actionsFinished.length > 0 )
			{
				var finishedAction:Action = _actionsFinished.pop();
				var ind:int = _actionsActive.indexOf(finishedAction);
				_actionsActive.splice(ind, 1);
			}
		}//end update()
		
		public function get active():Boolean
		{
			return _actionsActive.length > 0;
		}//end get active()
			
		public function reset():void
		{
		}//end reset()
		
	}//end GameElement

}//end com.bored.games