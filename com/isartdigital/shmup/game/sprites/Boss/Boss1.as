package com.isartdigital.shmup.game.sprites.Boss 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author oscar
	 */
	public class Boss1 extends Boss 
	{
		
		/**
		 * instance unique de la classe Boss1
		 */
		protected static var instance: Boss1;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss1 {
			if (instance == null) instance = new Boss1();
			return instance;
		}		
	
		public function Boss1() 
		{
			super();
			hp = 30;
			maxHp = hp;
			speed = 4;
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (enemiesList.length > 1) hp = 20;
			
			if (phaseActive1 = true && !(state == "explosion")){
				timerMissileShoot++;
				if (timerMissileShoot >= maxTime){
					var rdm:Number = 150 + (screenHeight - 300) * Math.random();
					callMissile(rdm, 1);
					timerMissileShoot = 0;
				}
			}
		}
		
		
		public function phase2():void{
			
			for (var e:int = 0; e < 4; e++){
				callMissile(150 + (screenHeight-300)/4*e, 2);
			}
			phaseActive1 = false
			phaseActive2 = true;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 * 
		 * cf destroy() de Boss0
		 */
		override public function destroy (): void {
			Boss.bossLevel++;
			parent.addChild(Boss2.getInstance());
			Boss2.getInstance().x = x;
			Boss2.getInstance().y = y;
			
			GameManager.clearWalls();
			//GameManager.killAll();
			phase2();
			SoundManager.getSound("bossLoop1").fadeOut(0.1);
			SoundManager.getSound("bossLoop2").fadeIn(0.1);
			
			instance = null;
			super.destroy();
		}
		
		override public function get hitBoxes():Vector.<DisplayObject>
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2, collider.hitBox3, collider.hitBox4];
		}
	}
}