package com.isartdigital.shmup.game.sprites.ShootsPlayer 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class ShootPlayer extends StateObject 
	{
		public static var shootList:Vector.<ShootPlayer> = new <ShootPlayer>[];
		
		protected var speed:int = 80;
		public var velocity:Point = new Point();
		public var boolExplo:Boolean;
		
		public function ShootPlayer() 
		{
			super();
			shootList.push(this);
			stopAllMovieClips();
			cacheAsBitmap = true;
		}
		
		override protected function doActionNormal():void 
		{
			
			super.doActionNormal();
			x += speed * velocity.x;
			y += speed * velocity.y;

			if ((state == "explosion") && renderer.currentFrame == renderer.totalFrames){
				destroy();
			}
			
			/**
			 * En cas de collision avec un Ennemi
			 * (Augmente le score de 100)
			 */
			for (var i:int = 0; i < Enemies.enemiesList.length; i++){
				if (CollisionManager.hasCollision(hitBox, Enemies.enemiesList[i].hitBox, null, Enemies.enemiesList[i].hitBoxes) && Enemies.enemiesList[i].lBool == false && !(state == "explosion")){
					Enemies.enemiesList[i].hp -= 1;
					explosion();
					Hud.getInstance().scoreNumber += 100;				
				}
			}
			
			/**
			 * En cas de collision avec un Obstacle
			 * Appelle la fonction takeDamage déterminée uniquement pour l'obstacle destructible
			 */
			for (var o:int = 0; o < Obstacles.obstacleList.length; o++){
				if (CollisionManager.hasCollision(hitBox, Obstacles.obstacleList[o].hitBox) && !(state == "explosion")){
					explosion();
					Obstacles.obstacleList[o].hp -= 1;
				}
			}
			
			var limits = GameLayer.getInstance().getScreenLimits();
			
			/**
			 * Détruit les shoots lorsqu'ils sortent de l'écran
			 */
			if (x >= limits.right || x <= limits.left || y <= limits.top){
				destroy();
			}
			
			/**
			 * Fait exploser les shoots lorsqu'ils touchent le sol (Consomme beaucoup vu le nombre d'explosions, mais rend le tout beaucoup plus visuel)
			 * (à désactiver si problèmes de perf)
			 */
			if (y >= limits.bottom - 50){
				//explosion();
				destroy();
			}
			
		}
		
		protected function explosion():void{
			boolExplo = true;
			cacheAsBitmap = false;
			setState("explosion");
			speed = 0;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			shootList.splice(shootList.indexOf(this), 1);
		}
		
	}

}