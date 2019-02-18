package com.isartdigital.shmup.game.sprites.Enemies 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.shmup.game.sprites.BouclierSpecial;
	import com.isartdigital.shmup.game.sprites.Collectibles.Collectibles;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy2;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.MathTools;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import fl.transitions.easing.*;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author oscar
	 */
	public class Enemies extends StateObject 
	{
		public static var enemiesList:Vector.<Enemies> = new <Enemies>[];
		public var hp:int;
		protected var timerShoot:int = 15; // Définit la fréquence de tir des ennemis, qui sera plus tard déterminée dans chaque classe fille. Lui donner une valeur permet aux ennemis de ne pas tirer instantanément dès qu'ils sont générés
		protected var timerBack:int = 30;
		protected var shootFrequence:int = 0;
		protected var timerMove:int = 0;
		protected var stopX:int = 800; // Détermine la position à partir de laquelle l'ennemi arrêtera d'avancer, pour une question de difficulté
		protected var enemyLevel:int = 0; // Détermine le niveau de l'enemi, afin que chacun tire son type de shoot visuellement
		private var limits = GameLayer.getInstance().getScreenLimits();
		protected var speed:int; // Définit la vitesse de déplacement des ennemis, déterminée dans chaque classe fille.
		protected var numWeapons:int; // Définit le nombre d'armes de chaque ennemi, déterminé dans chaque classe fille.
		public var lBool:Boolean; // Booléen actif si l'ennemi est en train d'exploser
		public var backBool:Boolean;
		public var lShot:ShootEnemy;
		public var collecDropChance:int; // Indique le taux d'obtention de collectible, déterminé dans chaque classe fille. Cf paramètre pDropChance de la fonction spawn dans Collectibles
		
		public var boolUp:Boolean;
		public var boolDown:Boolean = true;
		public var yMax:int = 400;
		
		public function Enemies() 
		{
			super();
			enemiesList.push(this);
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			move();
			
			if (isAnimEnd() && state == "fire"){
				if (hp > 0) setState("default");
			}
			
			if ((state == "explosion") && renderer.currentFrame == renderer.totalFrames){
				destroy();
			}
			
			if (hp <= 0 && !(state == "explosion") && !lBool){
				explosion();
			}
			
			if (state == "explosion") lBool = true;
			else {
				lBool = false;
			}
			
			//Si collis avec Player
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, null, Player.getInstance().hitBoxes) && !(state == "explosion")){
				if (Player.getInstance().god == false) Player.getInstance().respawn();
				if (this is Enemy0) hp = 0;
			}
			//Si collis avec bouclier
			if (CollisionManager.hasCollision(hitBox, BouclierSpecial.getInstance().hitBox) && !backBool){
				if (this is Enemy0){
				backBool = true;
				timerBack = 10;
				}
			}
			if (timerBack >= 0) timerBack--;
			if (backBool && timerBack >= 0 && x < GameLayer.getInstance().getScreenLimits().right){
				x += 40;
			}
			
			//Si collis avec ShootPlayer
			for (var i:int = 0; i < ShootPlayer.shootList.length; i++){
				if (CollisionManager.hasCollision(hitBox, ShootPlayer.shootList[i].hitBox)){
					if (hp > 1 && !(state == "hurt")){
						hurt();
					}
				}
			}
			
			//Si collis avec Obstacle
			for (var o:int = 0; o < Obstacles.obstacleList.length; o++){
				if (CollisionManager.hasCollision(hitBox, Obstacles.obstacleList[o].hitBox)){
					if (!(this is Enemy2) && !(state == "explosion")){
						hp = 0;
					}
				}
			}
			if (state == "hurt" && renderer.currentFrame == renderer.totalFrames){
				if (hp > 0) setState("default");
			}
			
			if (timerShoot > 0) timerShoot --;
			if (timerShoot <= 0 && !(state == "explosion") && !(this is Enemy0)) createShoot();
			
			if (x <= limits.left + 1000 || y >= limits.bottom || y <= limits.top){
				destroy();
			}
			//if (y >= limits.bottom) destroy();
			//if (y <= limits.top) destroy();
			
		}
		/**
		 * Tire autant de shoots que l'ennemi possède de weapons, chaque shoot prenant la rotation de sa weapon
		 */
		public function createShoot ():void{
			if (!(state == "explosion")){
				for (var i:int=0; i < (numWeapons); i++){
					var lClass:Class = Class(getDefinitionByName("com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy" + enemyLevel));
					var lLocalWeaponPoint:Point = new Point (collider.getChildByName("mcWeapon" + i).x, collider.getChildByName("mcWeapon" + i).y);
					var lGlobaltoLocalPoint:Point = GameLayer.getInstance().globalToLocal(localToGlobal(lLocalWeaponPoint));
					
					lShot = new lClass();
					lShot.rotation = collider.getChildByName("mcWeapon" + i).rotation;
					lShot.velocity.x = Math.cos(lShot.rotation * Math.PI / 180);
					lShot.velocity.y = Math.sin(lShot.rotation * Math.PI / 180);
					lShot.x = lGlobaltoLocalPoint.x;
					lShot.y = lGlobaltoLocalPoint.y;
					parent.addChild(lShot);
					lShot.start();
					//if (lShot is ShootEnemy2){
						//lShot.rotation = Math.atan2(Player.getInstance().x - x, Player.getInstance().y - y) * MathTools.RAD2DEG;
						//lShot.velocity.setTo(Math.cos(rotation * MathTools.DEG2RAD), Math.sin(rotation * MathTools.DEG2RAD));
					//}
					
					SoundManager.getSound("enemyShoot").start();
				}
			}
			
			
			timerShoot = shootFrequence;
			setState("fire");
		}
		
		/**
		 * L'ennemi passe en état "touché"
		 */
		public function hurt():void{
			setState("hurt");
		}
		
		/**
		 * Permet à l'ennemi de se déplacer sur une boucle de 120 frames
		 * 
		 * Stoppe l'ennemi à une certaine distance pour ne pas submerger le joueur
		 */
		public function move():void{
			timerMove ++;
			if (timerMove < 60){
				y -= speed;
				x -= speed;
			}
			if (timerMove > 60){
				y += speed;
				x += speed/3;
			}
			if (timerMove > 120) timerMove = 0;
			
			if (x < GameLayer.getInstance().getScreenLimits().right -stopX) x += GameLayer.getInstance().getSpeed();
		}
		
		/**
		 * Fait faire des allers retours de haut en bas
		 */
		public function moveUpDown():void{
			if (y >= GameLayer.getInstance().getScreenLimits().bottom - yMax){
				boolUp = true;
				boolDown = false;
			}
			
			if (boolDown) y += speed;
			if (boolUp) y -= speed;
			
			if (y <= GameLayer.getInstance().getScreenLimits().top + yMax){
				boolUp = false;
				boolDown = true;
			}
		}
		
		
		//override protected function setState(pState:String, pLoop:Boolean = false, pStart:uint = 1):void 
		//{
			//super.setState(pState, pLoop, pStart);
		//}
		
		/**
		 * Gère l'explosion et le son de chaque ennemi
		 */
		public function explosion():void{
			if (!(state == "explosion")){
				setState("explosion");
				speed = 0;
				
				var lNum:String = getQualifiedClassName(this).substr( -1);				
				if(!(this is Boss)) SoundManager.getSound("enemyExplosion" + lNum).start();
			}
		}
		
		/**
		 * Génère (peut être) un collectible avant de détruire l'ennemi, la probabilité étant déterminée selon son type 
		 */
		override public function destroy():void 
		{
			Collectibles.spawn(x, y, collecDropChance);
			super.destroy();
			enemiesList.splice(enemiesList.indexOf(this), 1);
		}
	}
}