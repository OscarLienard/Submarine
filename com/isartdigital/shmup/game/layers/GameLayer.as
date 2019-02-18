package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.levelDesign.GameObjectsGenerator;
	import com.isartdigital.shmup.game.levelDesign.ObstaclesGenerator;
	import com.isartdigital.shmup.game.sprites.Boss.Boss;
	import com.isartdigital.shmup.game.sprites.Collectibles.Collectibles;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile;
	import com.isartdigital.shmup.game.sprites.Missiles.Missiles;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootEnemies.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
	import com.isartdigital.utils.Monitor;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//import com.isartdigital.utils.Debug;
	
	/**
	 * Classe "plan de jeu", elle contient tous les éléments du jeu, Generateurs, Player, Ennemis, shoots...
	 * @author Mathieu ANTHOINE
	 */
	public class GameLayer extends ScrollingLayer 
	{
		
		/**
		 * instance unique de la classe GameLayer
		 */
		protected static var instance: GameLayer;
		public var list:Vector.<GameObjectsGenerator> = new <GameObjectsGenerator>[];
		
		public var toBoss:Boolean;
		
		public function GameLayer() 
		{
			super();
			visible = true;
			
			for (var i:int = 0; i < numChildren; i++ ){
				if (i < 33 || i > 37) list.push(getChildAt(i));
				
			}
		}
		
		override public function init(pSpeed:Number, pRef:ScrollingLayer = null):void 
		{
			Monitor.getInstance().addSlideBar("Scroll speed", 0, 100, pSpeed, 0.5, onUpdate);
			Monitor.getInstance().addButton("ShootLevel", onUpdate2);
			Monitor.getInstance().addButton("Go to Boss", onUpdate3);
			super.init(pSpeed, pRef);
			list.sort( function (pA:MovieClip, pB:MovieClip) : int { return pA.x < pB.x ? -1 : 1 } );
			x = 0;
		}
		
		/**
		 * Permet de mofifier la vitesse de scroll du GameLayer
		 * @param	pEvent
		 */
		private function onUpdate(pEvent:Event):void{
			baseSpeed = pEvent.target.value;
		}
		
		/**
		 * Permet de régler le ShootLevel, boucle de 0 à 2
		 * @param	pEvent
		 */
		private function onUpdate2(pEvent:Event):void{
			if (Player.getInstance().shootLevel == 2) Player.getInstance().shootLevel = -1;
			Player.getInstance().shootLevel += 1;
		}
		/**
		 * Permet de skip le niveau pour passer directement au boss
		 * @param	pEvent
		 */
		private function onUpdate3(pEvent:Event):void{
			x = -16000;
			
			toBoss = true;
		}
		/**s
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameLayer {
			if (instance == null) instance = new GameLayer();
			return instance;
		}

		override protected function doActionNormal():void 
		{
			x -= baseSpeed;
			setScreenLimits();
			
			if (list.length == 0) return;
			
			/**
			 * Appelle la méthode generate() des générateurs lorsqu'ils arrivent dans la zone de jeu
			 */
			if (list[0].x <= screenLimits.right + list[0].width/2 +100){
				list[0].generate();
				list.shift();
			}
		}
		
		/**
		 * 
		 * @return la vitesse du GameLayer
		 */
		public function getSpeed ():Number{
			return baseSpeed
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			super.destroy();
			list.splice(0, 1);
		}

	}
}