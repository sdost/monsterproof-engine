package com.monsterproof.tge
{
	import com.monsterproof.tge.content.ILoadable;
	import com.monsterproof.tge.content.loaders.BulkLoader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sam
	 */
	public class EntryPoint extends MovieClip 
	{
		public function EntryPoint() {}
		
		protected function main():void { }
		
		protected function registerTypes():void { }
		
		protected function vfsFile_onProgress(l:ILoadable, percentLoaded:Number):void { }
		
		protected function vfsFile_onError(l:ILoadable, e:Error):void { }
		
		protected function depLoader_onError(l:ILoadable, e:Error):void { }
		
		protected function addDependencies(loader:BulkLoader):void { }
		
		protected function depLoader_onProgress(l:ILoadable, percentLoaded:Number):void { }
		
		protected function initGame():void { }	
	}//end EntryPoint
	
}