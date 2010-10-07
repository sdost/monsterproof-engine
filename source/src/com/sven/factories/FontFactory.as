package com.sven.factories
{
	import flash.display.BitmapData;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FontFactory
	{
		public static function getFontByQualifiedName(a_str:String):Font
		{
			var fnt:Font = null;
			
			try {
				var cls:Class = getDefinitionByName(a_str) as Class;
				fnt = new cls();
			} catch ( e:Error ) {
				trace("FontFactory::getBitmapDataByQualifiedName(): " + e.message);
			}
			
			return fnt;
		}//end getFontByQualifiedName()
		
	}//end FontFactory

}//end com.bored.games.graphics