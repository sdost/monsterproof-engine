package  {
	import com.filament.fge.content.*;
	import com.filament.fge.content.loaders.*;
	import com.filament.fge.Program;
	import com.filament.fge.diagnostics.*;
	import com.filament.fge.object.ObjectUtils;
	import com.filament.fge.vfs.*;
	
	/**
	 * @see com.filament.fge.EntryPoint
	 */
	public class Main extends Program {
		
		protected var mLogger:TraceLogger;
		
		/** Return the fully-qualified name of the game class */
		override protected function get gameClassName():String { return ".Flare"; }
		
		/**
		* @inheritDoc
		*/
		override protected function main():void {
			//Do some initialization
			CONFIG::DEBUG {
				mLogger = new TraceLogger(LogLevel.DEBUG);
			}
			super.main();
		}
		
		/**
		* @inheritDoc
		*/
		override protected function registerTypes():void {
			super.registerTypes();
			//Register any required types for serialization
			ObjectUtils.registerAlias(XMLLoader);
			ObjectUtils.registerAlias(SoundBankLoader);
			ObjectUtils.registerAlias(SoundLoader);
		}

		/**
		* @inheritDoc
		*/
		override protected function vfsFile_onProgress(l:ILoadable, percentLoaded:Number):void {
			super.vfsFile_onProgress(l, percentLoaded);
			//Handle VFS load progress
		}
		
		/**
		* @inheritDoc
		*/
		override protected function vfsFile_onError(l:ILoadable, e:Error):void{
			super.vfsFile_onError(l, e);
			//Handle VFS load error
		}
		
		/**
		* @inheritDoc
		*/
		override protected function depLoader_onError(l:ILoadable, e:Error):void{
			super.depLoader_onError(l, e);
			//Handle dependency load error
		}
		
		/**
		* @inheritDoc
		*/
		override protected function addDependencies(loader:BulkLoader):void {
			super.addDependencies(loader);
			//Add any file dependencies, including libraries
			loader.add(new RslLoader(VFS.root.resolvePath("rsl/Game.swc")));
		}
		
		/**
		* @inheritDoc
		*/
		override protected function depLoader_onProgress(l:ILoadable, percentLoaded:Number):void {
			super.depLoader_onProgress(l, percentLoaded);
			//Handle dependencies load progress
		}
		
		/**
		* @inheritDoc
		*/
		override protected function initGame():void {
			//Do any final initialization
			super.initGame();
		}
	}
}

