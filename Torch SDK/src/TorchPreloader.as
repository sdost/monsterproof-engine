package  {
	//{Imports
	import com.filament.fge.Preloader;
	//}

	public class FlarePreloader extends Preloader {
		
		override protected function get movie():String { return "Main.swf"; }
		
		[Embed(source="../../content/embedded/preloader.swf",symbol="Preloader")]
		protected static const UI:Class;
		
		public function FlarePreloader() {
			addChild(new UI());
		}
	}
}
