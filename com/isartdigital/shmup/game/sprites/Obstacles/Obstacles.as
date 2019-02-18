package com.isartdigital.shmup.game.sprites.Obstacles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	
	/**
	 * Classe Obstacle
	 * Cette classe hérite de la classe StateObject elle possède donc une propriété renderer représentation graphique
	 * de l'obstacle et une propriété collider servant de boite de collision de l'Obstacle
	 * @author Mathieu ANTHOINE
	 */
	public class Obstacles extends StateObject 
	{
		
		public static var obstacleList:Vector.<Obstacles> = new Vector.<Obstacles>();
		public var hp:int = 10;
		
		public function Obstacles() 
		{
			super();
			obstacleList.push(this);
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, null, Player.getInstance().hitBoxes)){
				if (Player.getInstance().god == false && !(this is Obstacle2)){
					Player.getInstance().respawn();
				}
			}
			if (x < GameLayer.getInstance().getScreenLimits().left - width / 2) destroy();
		}
		
		public function takeDamage():void{
			
		}
		
		override public function destroy():void 
		{
			super.destroy();
			obstacleList.splice(obstacleList.indexOf(this), 1);
		}
		
		override public function get hitBox():DisplayObject 
		{
			return super.hitBox;
		}
	}
}