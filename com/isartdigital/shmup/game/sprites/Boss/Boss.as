package com.isartdigital.shmup.game.sprites.Boss 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy2;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
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
	public class Boss extends Enemies 
	{
		public static var bossLevel:int = 0;
		public var screenHeight:int = GameLayer.getInstance().getScreenLimits().bottom - GameLayer.getInstance().getScreenLimits().top;
		
		public var phaseActive0:Boolean;
		public var phaseActive1:Boolean;
		public var phaseActive2:Boolean;
		
		protected var timerMissileShoot:int = 0;
		protected var maxTime:int = 60;
		protected var maxHp:int;
		protected var mcLife:MovieClip;
		protected var mcLifewidth:Number;
		protected var preWin:Boolean;
		
		public function Boss() 
		{
			super();
			start();
			scaleX = 1.7;
			scaleY = 1.7;
			assetName = "Boss" + bossLevel;
			MovieClip(renderer.getChildAt(0)).mcLife.gotoAndStop(0);
			mcLifewidth = MovieClip(renderer.getChildAt(0)).mcLife.width;
		}
		
		/**
		 * Stabilise le boss à l'écran pour le combat
		 * Empêche le boss de mourir tant que ses sbires ne sont pas détruits
		 * Gère son explosion lorsque le boss n'a plus de points de vie
		 */
		override protected function doActionNormal():void 
		{
			if (!preWin) MovieClip(renderer.getChildAt(0)).mcLife.scaleX = hp / maxHp;
			if (!preWin) MovieClip(renderer.getChildAt(0)).mcLife.scaleY = hp / maxHp;
			
			for (var i:int = 0; i < ShootPlayer.shootList.length; i++){
				if (CollisionManager.hasCollision(hitBox, ShootPlayer.shootList[i].hitBox, hitBoxes) && enemiesList.length < 2 && !(ShootPlayer.shootList[i].boolExplo)){
					MovieClip(renderer.getChildAt(0)).mcLife.gotoAndStop(MovieClip(renderer.getChildAt(0)).mcLife.currentFrame + 3);
				}
			}
			
			if (x < GameLayer.getInstance().getScreenLimits().right - 600) x += GameLayer.getInstance().getSpeed();

			if (hp <= 0) explosion();
			
			if ((state == "explosion") && renderer.currentFrame == renderer.totalFrames){
				hp = 20;
				destroy();
			}
			
			if (enemiesList.length > 1) hp = 20;
			move();
			
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, null, Player.getInstance().hitBoxes)){
				if (Player.getInstance().god == false) Player.getInstance().respawn();
			}
		}
		
		override public function move():void 
		{
			moveUpDown();
		}
		
		/**
		 * Permet au boss de générer des ennemis devant lui
		 * 
		 * @param	nbEnemies : Nombre d'ennemis voulu
		 * @param	typeEnemies : Le type d'ennemis (Ennemis 0/1/2)
		 * @param	startY : Y voulu pour chaque ennemi
		 * @param	startX : X voulu pour chaque ennemi
		 * @param	distanceBtwnEach : Distance entre chaque ennemi à génerer
		 */
		public function spawnEnemies(nbEnemies:int, typeEnemies:int, startY:int, startX:int, distanceBtwnEach:int):void{
			for (var i:int = 0; i < nbEnemies; i++){
				var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Enemies.Enemy" + typeEnemies) as Class;
				var lEnemy = new lClass();
				
				lEnemy.x = x + startX;
				lEnemy.y = y + startY + i*distanceBtwnEach;
				lEnemy.start();
				parent.addChild(lEnemy);
			}
		}
		
		/**
		 * Fait apparaître un missile1 (et son indicateur) au y donné en paramètre
		 * @param	missileY
		 * @param	typeMissile
		 */
		public function callMissile(missileY:Number, typeMissile:int = 1):void{
			var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Missiles.Missile" + typeMissile) as Class;
			var lMissile = new lClass();
			
			parent.addChild(lMissile);
			lMissile.y = missileY;
			lMissile.start();
		}
		
		/**
		 * Fait apparaître un mur d'obstacles destructibles 
		 * @param	pStartX : Détermine la position horizontale du mur
		 * @param   pMissiles : Appelle des missiles pour detruire le mur
		 */
		public function callObstacleWall(pStartX:int, pMissiles:Boolean):void{
			var lClass0:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2") as Class;
			var lObs0 = new lClass0();
			
			var startX:int = -pStartX;
			
			var numTop:Number = 0;
			var numBottom:Number = 0;
			
			var startYTop:int = 200;
			var nbObstacles:int = Math.floor((screenHeight - startYTop) / lObs0.height);
			var startYBottom:int = screenHeight - startYTop - lObs0.height * (nbObstacles + 1);
			
			for (var i:int = 0; i <= nbObstacles; i++){
				var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2") as Class;
				var lObs:Obstacle2 = new lClass();
				
				var TopY:int = GameLayer.getInstance().getScreenLimits().top + startYTop + lObs.height * numTop;
				var BottomY:int = GameLayer.getInstance().getScreenLimits().bottom - startYBottom - lObs.height * numBottom;
				parent.addChild(lObs);
				lObs.x = x + startX;
				
				if (i < nbObstacles / 2){
					lObs.y = GameLayer.getInstance().getScreenLimits().top + startYTop;
					TweenLite.to(lObs, 1, {y:TopY});
					if (pMissiles) callMissile(TopY);
					numTop += 1;
				}
				else{
					lObs.y = GameLayer.getInstance().getScreenLimits().bottom - startYBottom;
					TweenLite.to(lObs, 1, {y:BottomY - lObs.height});
					if (pMissiles) callMissile(BottomY - lObs.height);
					numBottom += 1;
				}
				
				//Compense la vitesse du GameLayer
				lObs.immobile = true;
				
				lObs.start();
			}
		}
		
	}

}