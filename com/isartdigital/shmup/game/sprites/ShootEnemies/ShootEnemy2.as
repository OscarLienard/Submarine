package com.isartdigital.shmup.game.sprites.ShootEnemies 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy;
	import com.isartdigital.utils.MathTools;
	import flash.geom.Point;
	/**
	 * ...
	 * @author oscar
	 */
	public class ShootEnemy2 extends ShootEnemy 
	{
		/**
		 * Transforme les shoots en shoots téléguidés, qui vont vers la position du player à leur instanciation
		 */
		public function ShootEnemy2() 
		{
			super();
			//rotation = Math.atan2(Player.getInstance().x, Player.getInstance().y) * MathTools.RAD2DEG;
			//velocity.setTo(Math.cos(rotation * MathTools.DEG2RAD), Math.sin(rotation * MathTools.DEG2RAD));
		}
	}

}