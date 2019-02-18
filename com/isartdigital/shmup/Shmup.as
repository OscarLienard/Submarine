package com.isartdigital.shmup 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.game.levelDesign.EnemiesGenerator;
	import com.isartdigital.shmup.game.levelDesign.MissilesGenerator;
	import com.isartdigital.shmup.game.levelDesign.ObstaclesGenerator;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.game.sprites.Boss.Boss0;
	import com.isartdigital.shmup.game.sprites.Boss.Boss1;
	import com.isartdigital.shmup.game.sprites.Boss.Boss2;
	import com.isartdigital.shmup.game.sprites.Collectibles.CollectableBomb;
	import com.isartdigital.shmup.game.sprites.Collectibles.CollectableFirePower;
	import com.isartdigital.shmup.game.sprites.Collectibles.CollectableFireUpgrade;
	import com.isartdigital.shmup.game.sprites.Collectibles.CollectableLife;
	import com.isartdigital.shmup.game.sprites.Collectibles.Collectibles;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy2;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile0;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile1;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile2;
	import com.isartdigital.shmup.game.sprites.Missiles.Missile0;
	import com.isartdigital.shmup.game.sprites.Missiles.Missile1;
	import com.isartdigital.shmup.game.sprites.Missiles.Missile2;
	import com.isartdigital.shmup.game.sprites.Missiles.Missiles;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle0;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle1;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy0;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy1;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy2;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer0;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer1;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer2;
	import com.isartdigital.shmup.ui.GraphicLoader;
	import com.isartdigital.shmup.ui.TitleCard;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.events.AssetsLoaderEvent;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.loader.AssetsLoader;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.text.LocalizedTextField;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.ui.GameInput;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * Classe initiale du Shmup associée au fichier Shmup.fla
	 * Est en charge d'assurer le chargement des fichiers de configuration et
	 * des premières ressources du jeu
	 * @author Mathieu ANTHOINE
	 */
	public class Shmup extends MovieClip 
	{
		
		/**
		 * instance unique de la classe Shmup
		 */
		protected static var instance: Shmup;
		
		/**
		 * chemin vers le fichier de configuration
		 */
		protected static const CONFIG_PATH:String = "config.json";
		public static const SOUND_PATH:String = "sound.json";
		
		/**
		 * vérifie qu'un pad est connecté
		 */
		protected var padInput:GameInput;
			
		public function Shmup() 
		{
			super();
			
			// cas particulier de cette classe qui est associée au document et qui n'invoque donc pas getInstance() au moment de sa création.
			instance = this;

			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Shmup {
			if (instance == null) instance = new Shmup();
			return instance;
		}
		
		/**
		 * Initialisation
		 * @param pEvent
		 */
		protected function init (pEvent:Event=null): void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align =  StageAlign.TOP_LEFT;
			
			stage.quality = StageQuality.MEDIUM;
			
			var lLoader:AssetsLoader = new AssetsLoader ();
			lLoader.addTxtFile(CONFIG_PATH);
			
			lLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadConfigComplete);
			
			lLoader.load();
			
			//Passe en fullscreen au lancement du swf
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		/**
		 * Déclenché à la fin du chargement des fichiers de configuration
		 * @param	pEvent
		 */
		protected function onLoadConfigComplete (pEvent:AssetsLoaderEvent): void {
			
			pEvent.target.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadConfigComplete);
			
			Config.init(CONFIG_PATH, stage);
			
			detectControlsCapabilities();
			
			addChild(GameStage.getInstance());
			GameStage.getInstance().init(loadAssets);

			addChild(Monitor.getInstance());
		}

		/**
		 * Crée une référence vers un pad
		 * @param	pEvent
		 */
		protected function addPad (pEvent:GameInputEvent) : void {
			padInput.removeEventListener(GameInputEvent.DEVICE_ADDED, addPad);
			Controller.type = Controller.PAD;
			ControllerPad.init(pEvent.device);	
		}
		
		/**
		 * Détecte la configuration des controls. Dans config.json, controlerType peut forcer le controler
		 * controlerType = "keyboard" force le clavier
		 * controlerType = "touch" force le touch. Ces deux dictinctions sont faites car certains trackPad d'ordinateur portable
		 * considère leur touchPad comme un Touch de mobile ou tablette.
		 * controlerType = "pad" va laisser la détection naturelle du pad, il faut donc brancher le pad lorsque Shmup.swf est lancé pour que
		 * cette détection puisse avoir lieu.
		 * Si controlerType = "", laisser le système détecter automatiquement, pouvant donc entrainer le souci de confusion touchPad d'ordinateur avec Touch.
		 */
		private function detectControlsCapabilities (): void {
				if ( (Capabilities.touchscreenType == TouchscreenType.FINGER && Config.controlerType == "") || Config.controlerType == Controller.TOUCH) {
					Controller.type = Controller.TOUCH;
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				} else {
					if (Config.controlerType != Controller.KEYBOARD)
					{
						padInput = new GameInput();
						padInput.addEventListener(GameInputEvent.DEVICE_ADDED, addPad);
					}
				}
		}
		
		/**
		 * Lance le chargement principal
		 */
		protected function loadAssets (): void {
			
			var lLoader:AssetsLoader = new AssetsLoader ();
			
			// paramétrage (la propriété statique colliderAlpha n'est pas déclarée explicitement dans la classe Config, pour accéder à une propriété dynamiquement créé, on utilise la syntaxe [])
			if (Config.debug) {
				if (Config["colliderAlpha"]!=null) StateObject.colliderAlpha = Config["colliderAlpha"];
				if (Config["rendererAlpha"]!=null) StateObject.rendererAlpha = Config["rendererAlpha"];
			}
			
			lLoader.addTxtFile(Config.langPath + Config.language+"/main.xlf");
			lLoader.addDisplayFile("ui.swf");
			
			lLoader.addDisplayFile("assets.swf");
			
			lLoader.addDisplayFile("colliders.swf");
			lLoader.addDisplayFile("leveldesign.swf");
			lLoader.addTxtFile(SOUND_PATH);
			lLoader.addDisplayFile("sound.swf");
			
			lLoader.addEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
			lLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);
			
			UIManager.addScreen(GraphicLoader.getInstance());
			
			lLoader.load();
		}
		
		protected function onLoadProgress (pEvent:AssetsLoaderEvent): void {
			GraphicLoader.getInstance().update(pEvent.filesLoaded / pEvent.nbFiles);
		}
		
		protected function onLoadComplete (pEvent:AssetsLoaderEvent): void {
			pEvent.target.removeEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
			pEvent.target.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);

			LocalizedTextField.init(String(AssetsLoader.getContent(Config.langPath + Config.language+"/main.xlf")));
			
			UIManager.addScreen(TitleCard.getInstance());
		}
		
		/**
		 * Détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			padInput.removeEventListener(GameInputEvent.DEVICE_ADDED, addPad);
			instance = null;
		}
		
		/**
		 * Classe "hack" pour forcer l'import de classes dans le fichier Shmup.swf
		 * Par exemple ObstaclesGenerator n'est utilisé que dans le fichier leveldesign.swf
		 * si on ne force pas son import dans Shmup.swf par l'intermédiaire de cette méthode
		 * le code de la classe ne sera mis à jour que si on recompile leveldesign.swf
		 * ce qui est une grosse source d'erreur.
		 * Seules les classes dans ce cas sont à intégrer ici
		 */
		private static function importClasses (): void {
			ObstaclesGenerator;
			EnemiesGenerator;
			Enemy0;
			Enemy1;
			Enemy2;
			ShootPlayer0;
			ShootPlayer1;
			ShootPlayer2;
			ShootEnemy0;
			ShootEnemy1;
			ShootEnemy2;
			Boss0;
			Boss1;
			Boss2;
			CollectableLife;
			CollectableFireUpgrade;
			CollectableBomb;
			CollectableFirePower;
			Collectibles;
			Bomb;
			IndicateurMissile0;
			IndicateurMissile;
			IndicateurMissile1;
			IndicateurMissile2;
			MissilesGenerator;
			Missiles;
			Missile0;
			Missile1;
			Missile2;
			Obstacle0;
			Obstacle1;
			Obstacle2;
		}
		

	}
}