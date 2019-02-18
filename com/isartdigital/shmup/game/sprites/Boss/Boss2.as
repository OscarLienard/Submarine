package com.isartdigital.shmup.game.sprites.Boss 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author oscar
	 */
	public class Boss2 extends Boss 
	{
		
		/**
		 * instance unique de la classe Boss2
		 */
		protected static var instance: Boss2;
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss2 {
			if (instance == null) instance = new Boss2();
			return instance;
		}		
	
		public function Boss2() 
		{
			super();
			hp = 40;
			maxHp = hp;
			speed = 5;
			maxTime = 60;
		}
		
		/**
		 * Fait tirer un missiles 2 toutes les 60 frames
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (state == "explosion"){
				preWin = true;
				GameLayer.getInstance().baseSpeed = 0;
			}
			
			move();
			
			if (hp < 20 && !(maxTime == 30)){
				maxTime = 30;
				callObstacleWall(400, false);
				callObstacleWall(550, false);
			}
			
			if (phaseActive2 = true && !(state == "explosion")){
				timerMissileShoot++;
				if (timerMissileShoot >= maxTime){
					var rdm:Number = 150 + (screenHeight - 300) * Math.random();
					callMissile(rdm, 2);
					timerMissileShoot = 0;
				}
			}
			
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 * 
		 * Appelle la fonction win du GameManager après la destruction de la 3e phase
		 */
		override public function destroy (): void {
			instance = null;
			super.destroy();
			GameManager.win();
		}
		
		override public function get hitBoxes():Vector.<DisplayObject>
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2, collider.hitBox3, collider.hitBox4, collider.hitBox5, collider.hitBox6];
		}
	}
}