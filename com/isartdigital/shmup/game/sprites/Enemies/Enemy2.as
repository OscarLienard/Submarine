package com.isartdigital.shmup.game.sprites.Enemies 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Enemy2 extends Enemies 
	{
		protected var popEnemy0Timer:int = 100;
		
		public function Enemy2() 
		{
			super();
			numWeapons = 6;
			enemyLevel = 2;
			stopX = 400;
			shootFrequence = 80;
			speed = 3;
			collecDropChance = 1;
			hp = 20;
		}
		/**
		 * L'ennemi 2, en plus d'avoir beaucoup de points de vie, fait apparaitre des ennemis 0 autour de lui toutes les 100 frames
		 * Aussi, il tire un missile dirigé vers la position du Player à son lancement. 
		 * Difficile à éliminer en raison de son nombre de pv, il est également très dangereux à cause de ses missiles et des ennemis 0 qui s'accumulent vite.
		 * 
		 * Update : Spawn ennemis 0 supprimé au profit des performances
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
		}
		
		override public function move():void 
		{
			super.move();
			moveUpDown();
		}
		
		override public function get hitBoxes():Vector.<DisplayObject> 
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2, collider.hitBox3, collider.hitBox4];
		}
	}

}