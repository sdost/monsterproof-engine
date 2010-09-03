package  {
	//{Imports
	import com.filament.fge.content.*;
	import com.filament.fge.content.loaders.*;
	import com.filament.fge.*;
	//}
	
	/** This is the Flare Game class. It knows what resources 
	 * need to be loaded for the game, and how to start it.
	 */
	public class Flare extends Game {
		
		//{References
		SoundBankLoader;
		SoundLoader;
		XMLLoader;
		AMFLoader;
		//}
		
		/** Constructs the Game.
		 * @param stage The flash stage the game is being played on.
		 */
		public function Flare(prog:Program):void {
			super(prog);
		}
		
		/**
		* @inheritDoc
		*/
		override protected function initialize():void {
			//Do some initialization
			super.initialize();
		}
	}
}
