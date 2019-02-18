package com.isartdigital.shmup.game.sprites.ShootEnemies 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.BouclierSpecial;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class ShootEnemy extends StateObject 
	{
		public static var shootEnemiesList:Vector.<ShootEnemy> = new <ShootEnemy>[];
		
		protected var speed:int = 20;
		private var renvoiBool:Boolean;
		public var limits = GameLayer.getInstance().getScreenLimits();
		protected var period:Number = 0.2;
		protected var amplitude:Number = 10;
		protected var timerSin:Number = 0;
		public var velocity:Point = new Point();
		
		
		public function ShootEnemy() 
		{
			super();
			shootEnemiesList.push(this);
			cacheAsBitmap = true;
		}
			
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (renvoiBool && y < GameLayer.getInstance().getScreenLimits().top + 200) destroy();
			
			move();
			
			if ((state == "explosion") && renderer.currentFrame == renderer.totalFrames){
				destroy();
			}
			
			/**
			 * En cas de collision avec le Player, le fait respawn
			 */
			if (!(state == "explosion") && CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, null, Player.getInstance().hitBoxes) && renvoiBool == false){
				explosion();
				if (Player.getInstance().god == false) Player.getInstance().respawn();
			}
			
			/**
			 * En cas de collision avec le bouclier de la Special, augmente la scale du shoot et le fait changer de direction
			 */
			if (CollisionManager.hasCollision(hitBox, BouclierSpecial.getInstance().hitBox) && renvoiBool == false){
				if (!(state == "explosion") && scaleX == 1) scaleX *= 3;
				if (!(state == "explosion") && scaleY == 1) scaleY *= 3;
				
				speed = -speed * 1.5;
				renvoiBool = true;
			}
			
			/**
			 * En cas de collision avec un Ennemi, et le fait passer en mode "hurt"
			 */
			for (var e:int = 0; e < Enemies.enemiesList.length; e++){
				if (!(state == "explosion") && renvoiBool && CollisionManager.hasCollision(hitBox, Enemies.enemiesList[e].hitBox)){
					Enemies.enemiesList[e].hp -= 1;
					if (Enemies.enemiesList[e].hp > 1) Enemies.enemiesList[e].hurt();
					explosion();
				}
			}
			
			/**
			 * En cas de collision avec un Obstacle
			 */
			for (var o:int = 0; o < Obstacles.obstacleList.length; o++){
				if (!(state == "explosion") && CollisionManager.hasCollision(hitBox, Obstacles.obstacleList[o].hitBox)){
					explosion();
				}
			}
			
			if (x >= limits.right || x <= limits.left || y >= limits.bottom || y <= limits.top) destroy();
		}
		
		/**
		 * Gère le déplacement des shoots ennemis
		 * En cas de contact avec le bouclier de la special, il repart dans X opposé, tout en gardant son Y du moment où il s'est fait renvoyer
		 */
		protected function move():void{
			x += speed * velocity.x;
			if (!renvoiBool) y += speed * velocity.y;
			//timerSin += period;
			//if (!lBool) y += Math.cos(timerSin) * amplitude;
		}
		
		public function explosion():void{
			setState("explosion");
			speed = 0;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			shootEnemiesList.splice(shootEnemiesList.indexOf(this), 1);
		}
		
	}
}

