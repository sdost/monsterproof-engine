package com.bored.games.objects
{
	import de.polygonal.ds.SLLNode;
    import flash.display.MovieClip;
	import de.polygonal.ds.SLLIterator;
	import com.bored.games.actions.Action;
	import flash.utils.getQualifiedClassName;

    public class GameElement extends MovieClip
    {
        private var _actions:ActionList;
        private var _actionsQueued:ActionList;
        private var _actionsActive:ActionList;
        private var _iterator:SLLIterator;
		
		private var _id:String;
		
		private static var constructionCounts:Array = new Array();

        public function GameElement()
        {
			var className:String = getQualifiedClassName(this);
			
			className = className.slice(className.lastIndexOf("::") + 2);
			
			if ( constructionCounts[className] )
			{
				constructionCounts[className]++;
			}
			else
			{
				constructionCounts[className] = 1;
			}
			
			_id = className + "_" + constructionCounts[className];
			
            _actions = new ActionList();
            _actionsQueued = new ActionList();
            _actionsActive = new ActionList();
        }// end function

        public function addAction(a_action:Action) : Action
        {
			var node:* = _actions.nodeOf(a_action.actionName);
			
            if (!node)
            {
				// no action currently with this name, so, we add the new one.
                node = _actions.append(a_action);
            }
			
			return node.val;
			
        }// end function

        public function activateAction(a_name:String) : void
        {
            var node:* = _actions.nodeOf(a_name);
            if (node)
            {
                _actionsQueued.append(node.val);
                node.val.startAction();
            }
        }// end function

        public function deactivateAction(a_name:String) : void
        {
            var node:* = _actions.nodeOf(a_name);
            if (node)
            {
                node.val.finished = true;
            }
        }// end function
		
		public function get actions():Array
		{
			return _actions.toArray();
		}//end get actions()
		
		public function get activeActions():Array
		{
			return _actionsActive.toArray();
		}//end get activeActions()

        public function removeAction(a_name:String) : void
        {
            _actions.remove(a_name);
        }// end function

        public function update(t:Number = 0) : void
        {
            var action:Object = null;
            _actionsActive.merge(_actionsQueued);
            _actionsQueued.clear();
            _iterator = new SLLIterator(_actionsActive);
            while(_iterator.hasNext())
            {
                action = _iterator.next();
                if (action.finished)
                {
                    _actionsActive.remove(action);
                    continue;
                }
                action.update(t);
            }
        }// end function

        public function get active() : Boolean
        {
            return !_actionsActive.isEmpty();
        }// end function

        public function reset() : void
        {
            _actions.clear(true);
            _actionsQueued.clear(true);
            _actionsActive.clear(true);
        }// end function
		
		public function get objectId():String
		{
			return _id;
		}//end get objectId()
		
		override public function toString():String
		{
			return "[GameElement: " + this.objectId + "]";			
		}//end toString()

    }//end GameElement
	
}//end package

import de.polygonal.ds.SLL;
import de.polygonal.ds.SLLNode;

class ActionList extends SLL
{
	override public function remove(x:Object):Boolean
	{	
		var s:int = size();
		if (s == 0) return false;
		
		var node0:SLLNode = head;
		var node1:SLLNode = head.next;
		
		var NULL:Dynamic = null;
		
		while (node1 != null)
		{
			if (node1.val.actionName == x.actionName)
			{
				if (node1 == tail) tail = node0;
				var node2:SLLNode = node1.next;
				node0.next = node2;
				
				node1.next = null;
				node1.val = NULL;
				__nullify(node1);
				_size--;
				
				node1 = node2;
			}
			else
			{
				node0 = node1;
				node1 = node1.next;
			}
		}
		
		if (head.val.actionName == x.actionName)
		{
			var head1:SLLNode = head.next;
			
			head.val = NULL;
			__nullify(head);
			head.next = null;
			
			head = head1;
			
			if (head == null) tail = null;
			
			_size--;
		}
		
		return size() < s;
	}//end remove()
	
	override public function nodeOf(x:Object, from:SLLNode = null):SLLNode 
	{		
		var node:SLLNode = from == null ? head : from;
		
		while (_valid(node))
		{
			if (node.val.actionName == x) break;
			node = node.next;
		}
		return node;
	}//end nodeOf()
	
	override public function contains(x:Object):Boolean 
	{
		return super.contains(x);
	}//end contains()
	
}//end ActionList