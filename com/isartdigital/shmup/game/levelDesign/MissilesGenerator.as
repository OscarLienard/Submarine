package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Missiles.Missile0;
	import com.isartdigital.shmup.game.sprites.Missiles.Missiles;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author oscar
	 */
	public class MissilesGenerator extends GameObjectsGenerator 
	{

		
		public function MissilesGenerator() 
		{
			super();
		}
		/**
		 * Génère les missiles en fonction du nom du générateur
		 */
		override public function generate (): void {
			var lNum:String = getQualifiedClassName(this).substr( -1);
			var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Missiles.Missile" + lNum) as Class;
			var lMissile = new lClass();
			
			lMissile.x = x;
			lMissile.y = y;
			lMissile.start();
			GameLayer.getInstance().addChild(lMissile);
			super.generate();
		}
		
	}

}