package com.bored.games.objects
{
    import flash.display.MovieClip;
	import de.polygonal.ds.SLLIterator;
	import com.bored.games.actions.Action;

    public class GameElement extends MovieClip
    {
        protected var _actions:ActionList;
        protected var _actionsQueued:ActionList;
        protected var _actionsActive:ActionList;
        protected var _iterator:SLLIterator;

        public function GameElement()
        {
            _actions = new ActionList();
            _actionsQueued = new ActionList();
            _actionsActive = new ActionList();
        }// end function

        public function addAction(a_action:Action) : Action
        {
			var node:*;
            if (!this.checkForActionNamed(a_action.actionName))
            {
                node = _actions.append(a_action);
            }
			else
			{
				node = _actions.nodeOf(a_action.actionName);
			}
			
			return node.val;
        }// end function

        public function checkForActionNamed(a_name:String) : Boolean
        {
            return _actions.contains(a_name);
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

    }
}

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
	}
	
	override public function nodeOf(x:Object, from:SLLNode = null):SLLNode 
	{		
		var node:SLLNode = from == null ? head : from;
		
		while (_valid(node))
		{
			if (node.val.actionName == x) break;
			node = node.next;
		}
		return node;
	}
}