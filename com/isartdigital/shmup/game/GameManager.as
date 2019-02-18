package com.isartdigital.shmup.game {
	
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.layers.ScrollingLayer;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.shmup.game.sprites.Boss.Boss0;
	import com.isartdigital.shmup.game.sprites.Boss.Boss1;
	import com.isartdigital.shmup.game.sprites.Boss.Boss2;
	import com.isartdigital.shmup.game.sprites.BouclierSpecial;
	import com.isartdigital.shmup.game.sprites.Collectibles.Collectibles;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile0;
	import com.isartdigital.shmup.game.sprites.Missiles.Missile0;
	import com.isartdigital.shmup.game.sprites.Missiles.Missiles;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer0;
	import com.isartdigital.shmup.ui.EndScreen;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.Pause;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.WinScreen;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Manager (Singleton) en charge de gérer le déroulement d'une partie
	 * @author Mathieu ANTHOINE
	 */
	public class GameManager
	{
		/**
		 * jeu en pause ou non
		 */
		public static var isPause:Boolean = true;
		public static var timerPause:int = 0;
		public static var killTimer:int = 0;
		
		private static var background1 : ScrollingLayer;
		private static var background2 : ScrollingLayer;
		private static var foreground : ScrollingLayer;
		
		public static var bombesUsed:int = 0;
		
		/**
		 * controlleur
		 */
		protected static var controller:Controller;

		public function GameManager() { }

		public static function start (): void {
			// Lorsque la partie démarre, le type de controleur déterminé est actionné
			if (Controller.type == Controller.PAD){
				controller = ControllerPad.getInstance();
			}
			else if (Controller.type == Controller.TOUCH) controller = ControllerTouch.getInstance();
			else controller = ControllerKey.getInstance();

			Monitor.getInstance().addButton("Game Over",cheatGameOver);
			Monitor.getInstance().addButton("Win", cheatWin);
			Monitor.getInstance().addButton("Colliders", cheatCollider);
			Monitor.getInstance().addButton("Renderers", cheatRenderer);

			UIManager.startGame();
			
			var lGround:Class = getDefinitionByName("Background1") as Class;
			background1 = new lGround();
			GameStage.getInstance().getGameContainer().addChild(background1);
			
			lGround = getDefinitionByName("Background2") as Class;
			background2 = new lGround()
			GameStage.getInstance().getGameContainer().addChild(background2);
			
			GameStage.getInstance().getGameContainer().addChild(GameLayer.getInstance());

			lGround = getDefinitionByName("Foreground") as Class;
			foreground = new lGround();
			GameStage.getInstance().getGameContainer().addChild(foreground);
			
			GameLayer.getInstance().addChild(Player.getInstance());
			Player.getInstance().y += 700;
			
			background1.start();
			background2.start();
			foreground.start();
			GameLayer.getInstance().start();
			Player.getInstance().start();
			background1.stopAllMovieClips();
			background2	.stopAllMovieClips();
			
			background1.init(0.3, GameLayer.getInstance());
			background2.init(0.6, GameLayer.getInstance());
			foreground.init(1.2, GameLayer.getInstance());
			GameLayer.getInstance().init(3);
			
			// pour le restart 
			Config.stage.addEventListener(Event.ENTER_FRAME, gameLoop);
			
			
			Config.stage.addEventListener(Event.ENTER_FRAME, gameLoop2);
				
			resume();
			
			SoundManager.getSound("levelLoop").fadeIn();
			SoundManager.getSound("ambienceLoop").fadeIn();
			
		}
		
		// ==== Mode Cheat =====
		
		protected static function cheatCollider (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.colliderAlpha < 1) StateObject.colliderAlpha = 1; else StateObject.colliderAlpha = 0;
		}
		
		protected static function cheatRenderer (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.rendererAlpha < 1) StateObject.rendererAlpha = 1; else StateObject.rendererAlpha = 0;
		}
		
		protected static function cheatGameOver (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Player.getInstance().destroy();
			gameOver();
		}
		
		protected static function cheatWin (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			win();
		}
		
		/**
		 * boucle de jeu (répétée à la cadence du jeu en fps)
		 * @param	pEvent
		 */
		protected static function gameLoop (pEvent:Event): void {
			background1.doAction();
			background2.doAction();
			foreground.doAction();
			GameLayer.getInstance().doAction();
			Player.getInstance().doAction();
			Bomb.getInstance().doAction();
			
			for (var i:int = 0; i < ShootPlayer.shootList.length; i++){
				ShootPlayer.shootList[i].doAction();
			}
			for (var k:int = 0; k < ShootEnemy.shootEnemiesList.length; k++){
				ShootEnemy.shootEnemiesList[k].doAction();
			}
			for (var f:int = Enemies.enemiesList.length -1; f >= 0; f--){
				Enemies.enemiesList[f].doAction();
			}
			for (var r:int = 0; r < Obstacles.obstacleList.length; r++){
				Obstacles.obstacleList[r].doAction();
			}
			for (var c:int = 0; c < Collectibles.collecList.length; c++){
				Collectibles.collecList[c].doAction();
			}
			for (var d:int = 0; d < IndicateurMissile.list.length; d++){
				IndicateurMissile.list[d].doAction();
			}
			for (var n:int = 0; n < Missiles.list.length; n++){
				Missiles.list[n].doAction();
			}
			
			if (GameLayer.getInstance().toBoss) killTimer++;
			if (killTimer >= 120 || killTimer == 90 || killTimer == 60){
				killAll();
				if (killTimer >= 120){
					GameLayer.getInstance().toBoss = false;
					killTimer = 0;
				}
			}
		}
		
		/**
		 * Gameloop utilisée lorsque le jeu est en pause pour le reprendre
		 * Grâce au compteur de frames, évite d'avoir des problèmes en cas d'appui prolongé sur la commande de pause
		 * @param	pEvent
		 */
		protected static function gameLoop2 (pEvent:Event): void {
			if (isPause) timerPause++;
			if (isPause && controller.pause && timerPause > 10){
				resume();
				timerPause = 0;
			}
		}
		/**
		 * Fait apparaître l'écran GameOver, en mettant à jour son score. 
		 */
		public static function gameOver ():void {
			GameOver.getInstance().updateScore();
			Hud.getInstance().destroy();
			clean();
			UIManager.addScreen(GameOver.getInstance());
			SoundManager.stopSounds();
			SoundManager.getSound("gameoverJingle").start();
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
		}
		
		/**
		 * Fait apparaître l'écran Win, en mettant à jour son score. 
		 */
		public static function win():void {
			WinScreen.getInstance().updateScore();
			Hud.getInstance().destroy();
			clean();
			UIManager.addScreen(WinScreen.getInstance());
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			SoundManager.stopSounds();
			SoundManager.getSound("winJingle").start();
		}
		
		/**
		 * Affiche l'écran pause, et stoppe temporairement le jeu en retirant l'écouteur de la gameloop
		 */
		public static function pause (): void {
			if (!isPause) {
				isPause = true;
				
				UIManager.addScreen(Pause.getInstance());
				Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			}
		}
		
		/**
		 * Si le jeu est en pause, relance la gameloop et ferme l'écran de pause
		 */
		public static function resume (): void {
			// donne le focus au stage pour capter les evenements de clavier
			Config.stage.focus = Config.stage;
			if (isPause) {
				isPause = false;
				
				UIManager.closeScreens();
				Config.stage.addEventListener(Event.ENTER_FRAME, gameLoop);				
			}
		}
		
		/**
		 * En plus de nettoyer le jeu grâce à la méthode clean(), réinitialise le score afin de recommencer une partie sans pertes de performances
		 */
		public static function restart():void
        {
            //for (var i:int = Mobile.list.length - 1; i >= 0; i--)
            //{
                //Mobile.list[i].destroy();
            //}
			clean();
			
            Hud.getInstance().scoreNumber = 0;
			
            Monitor.getInstance().clear();
        }
		
		/**
		 * Nettoie le jeu en supprimant tous les stateObjects et le GameLayer
		 */
		public static function clean():void{
			Player.getInstance().destroy();
			
			killAll();
			
			foreground.destroy();
            background1.destroy();
            background2.destroy();
            GameLayer.getInstance().destroy();
			
			clearWalls();
		}
		
		/**
		 * Détruit tous les sprites à l'écran, excepté les obstacles et le player.
		 */
		public static function killAll():void{
			for (var i:int = 0; i < ShootPlayer.shootList.length; i++){
				ShootPlayer.shootList[i].destroy();
			}
			for (var k:int = 0; k < ShootEnemy.shootEnemiesList.length; k++){
				ShootEnemy.shootEnemiesList[k].destroy();
			}
			for (var f:int = Enemies.enemiesList.length -1; f >= 0; f--){
				if (!(Enemies.enemiesList[f] is Boss)) Enemies.enemiesList[f].destroy();
			}
			for (var c:int = 0; c < Collectibles.collecList.length; c++){
				Collectibles.collecList[c].destroy();
			}
			for (var d:int = 0; d < IndicateurMissile.list.length; d++){
				IndicateurMissile.list[d].destroy();
			}
			for (var n:int = 0; n < Missiles.list.length; n++){
				Missiles.list[n].destroy();
			}
		}
		
		/**
		 * Fait exploser les obstacles destructibles
		 * Méthode utilisée pour les phases de boss
		 */
		public static function clearWalls():void{
			for (var x:int = 0; x < Obstacle2.list.length; x++){
				Obstacle2.list[x].explosion();
			}
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public static function destroy (): void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
		}

	}
}