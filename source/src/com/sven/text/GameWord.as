package com.sven.text 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameWord extends GameElement
	{
		protected var _chars:Vector.<GameChar>;
		protected var _font:BitmapFont;
		
		protected var _wordWidth:Number;
		protected var _wordHeight:Number;
		
		private var _centered:Boolean;
		
		public function GameWord(a_str:String, a_font:BitmapFont) 
		{
			super();
			
			_centered = false;
			
			this.width = 0;
			this.height = 0;
			
			_font = a_font;
			
			_chars = new Vector.<GameChar>(a_str.length);
			
			var xOffset:Number = 0;
			
			for ( var i:uint = 0; i < _chars.length; i++ )
			{			
				_chars[i] = new GameChar(a_str.charCodeAt(i));
				_chars[i].x = xOffset;
				
				this.width += _font.retrieveGlyph(_chars[i].charCode).width;
				
				if ( _font.retrieveGlyph(_chars[i].charCode).height > height )
					this.height = _font.retrieveGlyph(_chars[i].charCode).height;
					
				xOffset += _font.retrieveGlyph(_chars[i].charCode).width;
			}
		}//end constructor()
		
		public function set text(a_str:String):void
		{
			this.width = 0;
			this.height = 0;
			
			_chars = new Vector.<GameChar>(a_str.length);
			
			var xOffset:Number = 0;
			
			for ( var i:uint = 0; i < _chars.length; i++ )
			{			
				_chars[i] = new GameChar(a_str.charCodeAt(i));
				_chars[i].x = xOffset;
				
				this.width += _font.retrieveGlyph(_chars[i].charCode).width;
				
				if ( _font.retrieveGlyph(_chars[i].charCode).height > height )
					this.height = _font.retrieveGlyph(_chars[i].charCode).height;
					
				xOffset += _font.retrieveGlyph(_chars[i].charCode).width;
			}
		}//end set text()
		
		public function set centered(a_centered:Boolean):void
		{
			_centered = a_centered;
		}//end set centered()
		
		public function get centered():Boolean
		{
			return _centered;
		}//end get centered()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			for ( var i:uint = 0; i < _chars.length; i++ )
			{
				_chars[i].update(t);
			}
		}//end update()
		
		public function draw(a_bmd:BitmapData, a_color:uint = 0xFFFFFF, a_scale:Number = 1.0, a_alpha:Number = 1.0):void
		{
			var glyph:BitmapData;
			
			var bmd:BitmapData = new BitmapData(this.width, this.height, true, 0x00000000);
			
			for ( var i:uint = 0; i < _chars.length; i++ )
			{				
				glyph = _font.retrieveGlyph(_chars[i].charCode);				
				bmd.copyPixels(glyph, glyph.rect, new Point(_chars[i].x, _chars[i].y), null, null, true);
			}
			
			var colTrans:ColorTransform = new ColorTransform();
			colTrans.color = a_color;
			colTrans.alphaMultiplier = a_alpha;
			
			bmd.colorTransform(bmd.rect, colTrans);
			
			var newWidth:Number = bmd.width * a_scale;
			var newHeight:Number = bmd.height * a_scale;
			var scaledBitmapData:BitmapData = new BitmapData(newWidth, newHeight, true, 0x00000000);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(a_scale, a_scale);
			scaledBitmapData.draw(bmd, scaleMatrix);
			
			var p:Point = new Point(x, y);
			if (_centered)
			{
				p.x -= newWidth / 2;
				p.y -= newHeight / 2;
			}
			
			a_bmd.copyPixels(scaledBitmapData, scaledBitmapData.rect, p, null, null, true);
			
			bmd.dispose();
			bmd = null;
			
			scaledBitmapData.dispose();
			scaledBitmapData = null;
		}//end draw()
		
		override public function get width():Number 
		{ 
			return _wordWidth; 
		}//end get width()
		
		override public function set width(value:Number):void 
		{
			_wordWidth = value;
		}//end set width()
		
		override public function get height():Number 
		{ 
			return _wordHeight; 
		}//end get height()
		
		override public function set height(value:Number):void 
		{
			_wordHeight = value;
		}//end set height()
		
	}//end GameWord

}//end package