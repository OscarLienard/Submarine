package com.isartdigital.shmup.game.sprites.Missiles 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.MathTools;
	import flash.geom.Point;
	/**
	 * ...
	 * @author oscar
	 */
	public class Missile2 extends Missiles 
	{
		public var posPlayer:Point;
		public var anglePlayer:Number;
		
		public function Missile2() 
		{
			super();
			timerRush = 30;
		}
		
		/**
		 * Des maths pour une fois, le Missile 2 part en direction du Player
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (timerRush == 0){
				posPlayer = new Point(Player.getInstance().x, Player.getInstance().y);
				anglePlayer = Math.atan2(posPlayer.y -y, posPlayer.x - x);
				rotation = anglePlayer * MathTools.RAD2DEG + 180;
			}
			
			if (runBool) {
				x += Math.cos(anglePlayer) * speed;
				y += Math.sin(anglePlayer) * speed;
			}
			
		}
	}

}