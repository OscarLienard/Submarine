package com.isartdigital.shmup.game.sprites 
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import fl.transitions.easing.*;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * Classe du joueur (Singleton)
	 * En tant que classe héritant de StateObject, Player contient un certain nombre d'états définis par les constantes LEFT_STATE, RIGHT_STATE, etc.
	 * @author Mathieu ANTHOINE
	 */
	public class Player extends StateObject
	{
		
		/**
		 * instance unique de la classe Player
		 */
		protected static var instance: Player;
		
		/**
		 * controleur de jeu
		 */
		protected var controller: Controller;
		
		/**
		 * vitesse du joueur
		 */
		protected var speed:Number = 25;
		protected var margeSecure:int = 90;
		
		public var shootLevel:int = 0;
		public var life:int = 3;
		public var bombs:int = 1;
		private var weapon:MovieClip;
		private var timerShoot:int = 15;
		private var timerHurt:int = 0;
		private var timerLife:int = 0;
		private var timerShake:int = 0;
		private var timerPause:int = 0;
		private var timerBomb:int = 0;
		private var timerDead:int = 0;
		private var timerGod:int = 0;
		private var timerSpecial:int = 0;
		public var manaSpecial:int = 100;
		private var boolHurt:Boolean;
		private var boolAnim:Boolean;
		private var boolExplo:Boolean;
		public var boolRespawn:Boolean;
		public var specialMode:Boolean;
		public var lShot:ShootPlayer;
		public var god:Boolean;
		protected var shield:MovieClip;
		
		public function Player() 
		{
			super();
			// crée le controleur correspondant à la configuration du jeu
			if (Controller.type == Controller.PAD) controller = ControllerPad.getInstance();
			else if (Controller.type == Controller.TOUCH) controller = ControllerTouch.getInstance();
			else controller = ControllerKey.getInstance();
			start();
			scaleX = 0.8;
			scaleY = 0.8;
			Hud.getInstance().mcTopLeft.getChildAt(1).scaleX = 0;
			Hud.getInstance().mcTopLeft.getChildAt(1).scaleY = 0;
			weapon.stop();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Player {
			if (instance == null) instance = new Player();
			return instance;
		}

		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			x += GameLayer.getInstance().getSpeed();
			if (!boolHurt && !weapon.isPlaying) setState("default");
			
			// Gère les contrôles du Player, son déplacement et son état
			if (controller.left > 0 && !boolRespawn){
				x -= speed;
				if (!boolHurt) setState("left");
			}
			if (controller.right > 0 && !boolRespawn){
				x += speed;
				if (!boolHurt) setState("right");
			}
			if (controller.up > 0 && !boolRespawn){
				y -= speed;
				if (!boolHurt) setState("up");
			}
			if (controller.down > 0 && !boolRespawn){
				y += speed;
				if (!boolHurt) setState("down");
			}
			
			// Permet au Player de ne pas se superposer aux obstacles destructibles
			collisObstacle2();
			
			// Passe le Player en état "default" si il cherche à sortir de l'écran
			var limits = GameLayer.getInstance().getScreenLimits();
			if (y < limits.top + margeSecure){
				y = limits.top + margeSecure;
				if (!boolHurt) setState("default");
			}
			if (y > limits.bottom - margeSecure){
				y = limits.bottom - margeSecure;
				if (!boolHurt) setState("default");
			}
			
			// Empêche le Player de sortir de la zone de jeu
			if (x < limits.left + margeSecure + 70){
				//respawn du player
				if (boolRespawn){
					x += 10;
					GameLayer.getInstance().baseSpeed = 0;
				}
				else{
				x = limits.left + margeSecure + 70;
				if (!boolHurt) setState("default");
				}
			}
			if (x > limits.right - margeSecure - 70){
				x = limits.right - margeSecure - 70;
				if (!boolHurt) setState("default");
			}
			
			// Rend invisible l'asset mcWeapon, dans la gameLoop car regeneré à chaque changement d'état
			MovieClip(renderer.getChildAt(0)).mcWeapon.visible = false;
			
			// Fait tirer le Player
			if (controller.fire){
				createShoot();
				weapon.play();
			}
			// Appelle la méthode pause du Gamemanager
			if (controller.pause && timerPause >= 10){
				timerPause = 0;
				GameManager.pause();
				weapon.stop();
			}
			
			
			if (timerLife < 60) timerLife++;
			
			//Appelle la méthode bomb()
			if (controller.bomb && bombs > 0 && timerBomb <= 0){
				bomb();
			}
			
			// Gère la regen du mana
			if (manaSpecial < 80) manaSpecial++;
			//Gère le déplacement du player pendant la special
			if (controller.special){
				if (manaSpecial >= 80) special();
				else{
					TweenLite.to(Hud.getInstance().mcTopLeft.mcSpecialBar, 0.5, {scaleX:1.5, scaleY:1.5});
					TweenLite.to(Hud.getInstance().mcTopLeft.mcSpecialBar, 0.5, {delay:0.5, scaleX:1, scaleY:1});
				}
			}
			
			if (specialMode){
				x += 50;
				timerSpecial ++;
			}
			if (timerSpecial >= 10){
				BouclierSpecial.getInstance().destroy();
				specialMode = false;
				timerSpecial = 0;
			}
			if (!specialMode) alpha = 1;
			
			
			if (state == "hurt"){
				timerHurt ++;
				alpha = 0.5;
			}
			if (state == "hurt" && timerHurt >= 30){
				boolHurt = false;
				boolRespawn = false;
				GameLayer.getInstance().baseSpeed = 5;	
				alpha = 1;
			}
			
			timerShoot--;
			
			timerBomb--;
			
			dead();
			
			godMode();
			
			// Remet le GameStage à sa place initiale après qu'il se soit fait "secouer"
			if (boolRespawn){
				timerShake--;
				if (timerShake == 0) GameStage.getInstance().unshake();
			}
			
			timerPause++;
			
			if (weapon.currentFrame == weapon.totalFrames) weapon.stop();
		}
		
		/**
		 * Appliquée lorsque le player perd une vie, cette méthode gère l'animation de l'Hud et le changement d'état du Player
		 */
		public function hurt():void{
			boolHurt = true;
			timerHurt = 0;
			setState("hurt");
			if (boolHurt && timerLife >= 60){
				life --;
				if (life == 2) TweenLite.to(Hud.getInstance().mcTopRight.getChildAt(4), 0.5, {scaleX:0, scaleY:0});
				if (life == 1) TweenLite.to(Hud.getInstance().mcTopRight.getChildAt(1), 0.5, {scaleX:0, scaleY:0});
				if (life == 0) TweenLite.to(Hud.getInstance().mcTopRight.getChildAt(0), 0.5, {scaleX:0, scaleY:0});
				timerLife = 0;
				manaSpecial = 100;
			}
		}
		
		/**
		 * La méthode bomb génère une bombe sur la position du player, et détruit tous les ennemis/tir ennemis à l'écran
		 * Elle gère également l'animation de l'Hud et déclenche le son associé
		 */
		public function bomb():void{
			if (bombs > 2) bombs = 2;
			addChild(Bomb.getInstance());
			Bomb.getInstance().start();
			Bomb.getInstance().goto();
			
			bombs--;
			if (bombs == 1) TweenLite.to(Hud.getInstance().mcTopLeft.getChildAt(1), 0.5, {scaleX:0, scaleY:0});
			if (bombs == 0) TweenLite.to(Hud.getInstance().mcTopLeft.getChildAt(0), 0.5, {scaleX:0, scaleY:0});
			
			timerBomb = 60;
			
			for (var i:int = 0; i < Enemies.enemiesList.length; i++){
				if (!(Enemies.enemiesList[i] is Boss)) Enemies.enemiesList[i].hp = 0;
			}
			for (var s:int = 0; s < ShootEnemy.shootEnemiesList.length; s++){
				ShootEnemy.shootEnemiesList[s].explosion();
			}
			for (var o:int = 0; o < Obstacle2.list.length; o++){
				Obstacle2.list[o].explosion();
			}
			SoundManager.getSound("bomb").start();
			GameManager.bombesUsed ++;
		}
		
		/**
		 * Stoppe le GameLayer, puis appelle l'écran gameOver arpès 40 frames 
		 */
		public function dead():void{
			if (life == 0 && timerDead <= 40){
				timerDead++;
				
				GameLayer.getInstance().baseSpeed = 0;
				
				if (timerDead >= 40){
					destroy();
					GameManager.gameOver();
				}
			}
		}
		
		/**
		 * Permet au Player de ne pas se superposer aux obstacles destructibles
		 */
		public function collisObstacle2():void{
			if (controller.left){
				for (var f:int = 0; f < Obstacle2.list.length; f++){
					if (CollisionManager.hasCollision(hitBox, Obstacle2.list[f].hitBox)) x += speed + GameLayer.getInstance().getSpeed();
				}
			}
			if (controller.right){
				for (var e:int = 0; e < Obstacle2.list.length; e++){
					if (CollisionManager.hasCollision(hitBox, Obstacle2.list[e].hitBox)) x -= speed + GameLayer.getInstance().getSpeed();
				}
			}
			if (controller.up){
				for (var l:int = 0; l < Obstacle2.list.length; l++){
					if (CollisionManager.hasCollision(hitBox, Obstacle2.list[l].hitBox, hitBoxes)) y += speed;
				}
			}
			if (controller.down){
				for (var r:int = 0; r < Obstacle2.list.length; r++){
					if (CollisionManager.hasCollision(hitBox, Obstacle2.list[r].hitBox)) y -= speed;
				}
			}
		}
		
		/**
		 * Renvoie le player dans le jeu si il perd une vie, appelle la méthode hurt() et fait perdre 2000 de score
		 * Fait également appel à la méthode shake() qui secoue le GameStage sur un court temps.
		 */
		public function respawn():void{
			if (!boolRespawn){
				GameStage.getInstance().shake();
				timerShake = 3;
				boolRespawn = true;
				SoundManager.getSound("loseLife").start();
				Hud.getInstance().scoreNumber -= 1000;
			}
			
			x = GameLayer.getInstance().getScreenLimits().left - 100;
			y = 700;
			hurt();
			
			if (Hud.getInstance().scoreNumber < 0) Hud.getInstance().scoreNumber = 0;
		}
		
		/**
		 * Déclenche un dash vers l'avant grâce au booléen specialMode, et génère un bouclier renvoyant les balles devant le Player
		 */
		public function special ():void{
			manaSpecial = 0;
			alpha = 0.5;
			specialMode = true;
			addChild(BouclierSpecial.getInstance());
			BouclierSpecial.getInstance().x += Player.getInstance().width / 2 + 200;
			SoundManager.getSound("special").start();
		}
		
		/**
		 * Fait apparaître un bouclier autour du Player, le rendant invulnérable tant que le godMode est actif
		 */
		public function godMode():void{
			if (controller.god && !god && timerGod <= 0){
				god = true;
				timerGod = 20;
				var lShieldClass:Class = getDefinitionByName("Shield_default") as Class
				shield = new lShieldClass();
				parent.addChild(shield);
			}
			timerGod--;
			if (controller.god && god && timerGod <= 0){
				god = false;
				timerGod = 20;
			}
			if (god){
				shield.x = x;
				shield.y = y;
				shield.alpha = 0.5;
			}
		}
		
		override protected function setState(pState:String, pLoop:Boolean = false, pStart:uint = 1):void 
		{
			super.setState(pState, pLoop, pStart);
			
			if (weapon != null){
				removeChild(weapon)
				weapon = null
			}
			var lWeaponClass:Class = getDefinitionByName("Weapon" + shootLevel) as Class
			weapon = new lWeaponClass();
			addChild(weapon);
			weapon.x = MovieClip(renderer.getChildAt(0)).mcWeapon.x;
			
		}
		
		/**
		 * Génère autant de shoots que le player a de canons, grâce à la variable shootLevel.
		 * Chaque shot prend la rotation du canon dont il est issu
		 * Appelle le son qui correspond au type de tir
		 */
		public function createShoot ():void{
			if (timerShoot <= 0){
				for (var i:int=0; i < (1 + 2 * shootLevel); i++){
					
					var lClass:Class = Class(getDefinitionByName("com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer" + shootLevel));
					var lLocalWeaponPoint:Point = new Point (collider.getChildByName("mcWeapon" + i).x, collider.getChildByName("mcWeapon" + i).y);
					var lGlobaltoLocalPoint:Point = GameLayer.getInstance().globalToLocal(localToGlobal(lLocalWeaponPoint));
					
					lShot = new lClass();
					lShot.rotation = collider.getChildByName("mcWeapon" + i).rotation;
					lShot.velocity.x = Math.cos(lShot.rotation * Math.PI / 180);
					lShot.velocity.y = Math.sin(lShot.rotation * Math.PI / 180);
					lShot.x = lGlobaltoLocalPoint.x;
					lShot.y = lGlobaltoLocalPoint.y;
					lShot.start();
					parent.addChild(lShot);
				}
				timerShoot = 10;
				
				SoundManager.getSound("playerShoot" + shootLevel).start();
				
			}
		}
		
		/**
		 * 
		 * @return la vitesse du Player
		 */
		public function getSpeed ():Number{
			return speed
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}

		override public function get hitBoxes():Vector.<DisplayObject> 
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2];
		}
	}
}