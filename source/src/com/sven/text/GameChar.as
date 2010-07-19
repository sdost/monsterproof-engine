package com.sven.text 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameChar extends GameElement
	{
		private var _charCode:uint;
		
		public function GameChar(a_code:uint)
		{
			super();			
			
			_charCode = a_code;
		}//end constructor()
		
		public function get charCode():uint
		{
			return _charCode;
		}//end get charCode()
		
	}//end GameChar

}//end package