package com.isartdigital.shmup.game.sprites.Missiles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	/**
	 * ...
	 * @author oscar
	 */
	public class Missile1 extends Missiles 
	{
		protected var amplitude:Number = 10;
		protected var timerSin:Number = 0;
		protected var period:Number = 0.2;
		
		public function Missile1() 
		{
			super();
			timerRush = 60;
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			//timerSin += period;
			//y += Math.cos(timerSin) * amplitude;
		}
	}

}