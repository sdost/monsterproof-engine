package com.sven.text 
{
	import flash.display.BitmapData;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author sam
	 */
	public class BitmapFontFactory
	{
		private static var _glyphs:String = "abcdefghiklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=+_:; ";
		
		public static function generateBitmapFont(a_font:Font):BitmapFont
		{
			var bmd:BitmapData;			
			var tf:TextFormat = new TextFormat(a_font.fontName, 18, 0xFFFFFF);
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.embedFonts = true;
			
			var bmf:BitmapFont = new BitmapFont();
			
			for ( var i:uint = 0; i < _glyphs.length; i++ )
			{
				t.text = _glyphs.charAt(i);
				t.setTextFormat(tf);
				
				bmd = new BitmapData(t.width, t.height, true, 0x00000000);
				bmd.draw(t);
				
				bmf.registerGlyph(_glyphs.charCodeAt(i), bmd);
			}			
			
			return bmf;
			
		}//end generateBitmapFont()
		
	}//end BitmapFontFactory

}//end package