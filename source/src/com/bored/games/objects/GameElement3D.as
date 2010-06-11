package com.bored.games.objects 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class GameElement3D extends GameElement
	{
		private var _position:Vector3D;
		
		private var _pitch:Number;
		private var _roll:Number;
		private var _yaw:Number;
		
		public function GameElement3D() 
		{
			super();
			
			_position = new Vector3D();
			
			_pitch = 0;
			_roll = 0;
			_yaw = 0;			
		}//end constructor()
		
		public function get position():Vector3D
		{
			return _position;
		}//end get position()
		
		public function set pitch(a_ang:Number):void
		{
			_pitch = a_ang;
		}//end set pitch()
		
		public function set roll(a_ang:Number):void
		{
			_roll = a_ang;
		}//end set roll()
		
		public function set yaw(a_ang:Number):void
		{
			_yaw = a_ang;
		}//end set yaw()
		
		public function get pitch():Number
		{
			return _pitch;
		}//end set pitch()
		
		public function get roll():Number
		{
			return _roll;
		}//end set roll()
		
		public function get yaw():Number
		{
			return _yaw;
		}//end set yaw()
		
		override public function reset():void
		{
			this.pitch = 0;
			this.roll = 0;
			this.yaw = 0;
			this.position.x = 0;
			this.position.y = 0;
			this.position.z = 0;
		}//end reset()
		
	}//end GameElement3D

}//end package