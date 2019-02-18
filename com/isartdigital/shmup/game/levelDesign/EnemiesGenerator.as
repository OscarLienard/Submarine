package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.sprites.Boss.Boss0;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe qui permet de générer des classes d'ennemis
	 * TODO: S'inspirer de la classe ObstacleGenerator pour le développement
	 * @author Mathieu ANTHOINE
	 */
	public class EnemiesGenerator extends GameObjectsGenerator 
	{
		
		public function EnemiesGenerator() 
		{
			super();
			
		}
		
		/**
		 * Génère les ennemis et le boss en fonction du nom du générateur
		 */
		override public function generate():void 
		{
			var lNum:String = getQualifiedClassName(this).substr( -1);
			if (lNum == "n") lEnemy = new Boss0();
			else {
			var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Enemies.Enemy" + lNum) as Class;
			var lEnemy = new lClass();
			}
			lEnemy.x = x;
			lEnemy.y = y;
			lEnemy.start();
			parent.addChild(lEnemy);
			super.generate();
			
		}

	}

}