package com.sven.text 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sam
	 */
	public class BitmapFont
	{
		private var _glyphs:Vector.<BitmapData>;
		
		public function BitmapFont() 
		{
			_glyphs = new Vector.<BitmapData>(128);
		}//end constructor()
		
		public function registerGlyph(a_code:uint, a_bmd:BitmapData):void
		{
			_glyphs[a_code] = a_bmd;
		}//end registerGlyph()
		
		public function retrieveGlyph(a_code:uint):BitmapData
		{
			return _glyphs[a_code];
		}//end retrieveGlyph()
		
	}//end BitmapFont

}//end package