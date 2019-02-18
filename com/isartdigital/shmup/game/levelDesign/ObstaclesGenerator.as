package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe qui permet de générer des Obstacles dans le GameLayer
	 * @author Mathieu ANTHOINE
	 */
	public class ObstaclesGenerator extends GameObjectsGenerator 
	{
		
		public function ObstaclesGenerator() 
		{
			super();
		}
		
		/**
		 * Génère les obstacles en fonction du nom du générateur
		 */
		override public function generate (): void {
			var lNum:String = getQualifiedClassName(this).substr( -1);
			var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.Obstacles.Obstacle" + lNum) as Class;
			var lObstacle = new lClass();
			lObstacle.x = x;
			lObstacle.y = y;
			lObstacle.start();
			parent.addChild(lObstacle);
			
			super.generate();
		}
		
		
	}

}