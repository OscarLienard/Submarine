package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class BouclierSpecial extends StateObject 
	{
		
		/**
		 * instance unique de la classe BouclierSpecial
		 */
		protected static var instance: BouclierSpecial;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): BouclierSpecial {
			if (instance == null) instance = new BouclierSpecial();
			return instance;
		}		
	
		public function BouclierSpecial() 
		{
			super();
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