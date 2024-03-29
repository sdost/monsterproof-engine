package com.sven.factories
{
	import com.sven.animation.AnimatedSprite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedSpriteFactory
	{
		
		public static function generateAnimatedSprite( clip:MovieClip ):AnimatedSprite
		{
			var sprite:AnimatedSprite = new AnimatedSprite(clip.totalFrames);
			
			var bmd:BitmapData;
			
			bmd = new BitmapData(clip.width, clip.height);
			bmd.fillRect(bmd.rect, 0x00000000);
			
			sprite.addFrame(bmd);
			
			for ( var i:uint = 1; i <= clip.totalFrames; i++ )
			{
				clip.gotoAndStop(i);
				
				bmd = new BitmapData(clip.width, clip.height);
				
				bmd.fillRect(bmd.rect, 0x00000000);
				bmd.draw(clip);
				
				sprite.addFrame(bmd);
			}
			
			return sprite;
		}//end generateAnimatedSprite()
		
	}//end AnimatedSpriteFactory

}//end package