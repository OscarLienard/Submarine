package com.isartdigital.shmup.game.sprites.Missiles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile0;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Missile0 extends Missiles 
	{
		protected var IndicSpeed:int = 10;
		
		public function Missile0() 
		{
			super();
			timerRush = 120;
		}
		/**
		 * Comme pour les ennemis 1, un indicateur apparaît pendant 120 secondes, puis disparait pour laisser place à un missile qui se déplace de droite à gauche
		 * L'indicateur suit le Player avec un délai (en lui donnant une vitesse de déplacement fixe)
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (lIndic.y > Player.getInstance().y) lIndic.y -= IndicSpeed;
			if (lIndic.y < Player.getInstance().y) lIndic.y += IndicSpeed;
			
			if (timerRush == 0) y = lIndic.y;
			
		}
		
	}

}