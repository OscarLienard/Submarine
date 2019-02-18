package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Bomb extends StateObject 
	{
		
		/**
		 * instance unique de la classe Bomb
		 */
		protected static var instance: Bomb;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Bomb {
			if (instance == null) instance = new Bomb();
			return instance;
		}		
	
		public function Bomb() 
		{
			super();
			scaleX = 1.5;
			scaleY = 1.5;
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (renderer.currentFrame == renderer.totalFrames){
				destroy();
			}
		}
		
		/**
		 * Permet de faire commencer l'animation de la bombe dès sa première image lorsqu'on l'active depuis une autre classe (cf bomb() dans Player)
		 */
		public function goto():void{
			renderer.gotoAndPlay(0);
		}
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			super.destroy();
			instance = null;
		}

	}
}