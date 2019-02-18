package com.isartdigital.shmup.game.sprites.Boss 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Boss0 extends Boss 
	{
		
		/**
		 * instance unique de la classe Boss0
		 */
		protected static var instance: Boss0;
		protected var boolPhase0:Boolean;
		protected var posBool:Boolean;
		private var startX:int = 599;
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss0 {
			if (instance == null) instance = new Boss0();
			return instance;
		}		
	
		public function Boss0() 
		{
			super();
			hp = 20;
			maxHp = hp;
			speed = 3;
			SoundManager.getSound("levelLoop").fadeOut(0.01);
			SoundManager.getSound("ambienceLoop").fadeOut(0.01);
			SoundManager.getSound("bossLoop0").fadeIn(0.1);
			SoundManager.getSound("bossLoop1").fadeOut(1);
			SoundManager.getSound("bossLoop2").fadeOut(1);
		}
		 
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (!boolPhase0){
				GameManager.clearWalls();
				phase0();
				boolPhase0 = true;
			}
			if (x > (GameLayer.getInstance().getScreenLimits().right - startX)) x -= speed;
			if (!posBool && x <= (GameLayer.getInstance().getScreenLimits().right - startX)){
				GameManager.clearWalls();
				spawnEnemies(1, 2, 0, 0, 500)
				posBool = true;
				x -= 2;
			}
			
			if (phaseActive0 = true && !(state == "explosion")){
				timerMissileShoot++;
				if (timerMissileShoot >= maxTime){
					var rdm:Number = 150 + (screenHeight - 300) * Math.random();
					callMissile(rdm, 0);
					timerMissileShoot = 0;
				}
			}
			
		}
		
		/**
		 * Cette fonction appelle la deuxième phase du boss
		 * Tout d'abord appelle deux ennemis 1 grâce à la méthode spawnEnemies(), puis génère (et anime!) autant d'obstacles que possible verticalement
		 * Une fois les obstacles placés, génère un missile en face de chaque obstacle, qui ira détruire ce dernier pour libérer le passage au Player.
		 */
		public function phase1():void{
			
			spawnEnemies(1, 1, 0, 400, 0);
			spawnEnemies(3, 0, -200, 200, 0);
			
			callObstacleWall(startX, true);
			phaseActive0 = false
			phaseActive1 = true;
		}
		
		/**
		 * Cette fonction appelle la première phase du boss
		 * Elle génère un mur d'obstacles devant le boss pour empêcher le player de le toucher avant qu'il soit totalement sur l'écran
		 * Puis génère 3 missiles devant le boss
		 */
		public function phase0():void{
			
			callObstacleWall(1100, false);
			
			//for (var e:int = 0; e < 3; e++){
				//callMissile(300 + e * 300);
			//}
			
			phaseActive0 = true;
		}
		
		
		/**
		 * Détruit l'instance unique et met sa référence interne à null
		 * Supprime les obstacles restants (s'il en reste) et appelle la deuxième phase du boss
		 */
		override public function destroy (): void {
			Boss.bossLevel++;
			parent.addChild(Boss1.getInstance());
			Boss1.getInstance().x = x;
			Boss1.getInstance().y = y;
			
			GameManager.clearWalls();
			//GameManager.killAll();
			phase1();
			SoundManager.getSound("bossLoop0").fadeOut(0.1);
			SoundManager.getSound("bossLoop1").fadeIn(0.1);
			instance = null;
			super.destroy();
		}
		
		override public function get hitBoxes():Vector.<DisplayObject>
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2, collider.hitBox3];
		}
	}
}