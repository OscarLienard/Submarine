package com.isartdigital.shmup.game.sprites.Enemies 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Enemy0 extends Enemies 
	{
		
		public function Enemy0() 
		{
			super();
			numWeapons = 1;
			enemyLevel = 0;
			speed = 3;
			shootFrequence = 0;
			hp = 1;
			collecDropChance = 4;
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (Player.getInstance().y - y < 100 && y > 150){
				y += 3;
				y -= 3;
			}
		}
		/**
		 * L'ennemy 0 a un comportement propre à sa classe sur 400 frames, qui se termine par un rush vers l'avant.
		 * Il est très fragile et facile à éliminer pour se faire la main au début du niveau
		 * Il devient dangereux lorsqu'il est accompagné et que le joueur ne le prend pas au sérieux en l'ignorant au profit des autres ennemis
		 */
		override public function move():void 
		{
			timerMove ++;
			if (timerMove < 100){
				y -= speed;
				x -= speed;
			}
			if (timerMove > 100 && timerMove < 200){
				y += speed;
				x -= speed;
			}
			if (timerMove > 200 && timerMove < 300){
				y -= 0;
				x += speed*2;
			}
			if (timerMove > 300){
				y += 0;
				x -= speed*6;
			}
			if (timerMove > 400) timerMove = 0;
			
		}
		
		override public function get hitBoxes():Vector.<DisplayObject> 
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2];
		}
	}

}