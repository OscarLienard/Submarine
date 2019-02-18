package com.isartdigital.shmup.game.sprites.Missiles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile0;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacle2;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Missiles extends StateObject 
	{
		public static var list:Vector.<Missiles> = new Vector.<Missiles>();
		
		protected var speed:int = 50;
		
		protected var boolInit:Boolean;
		protected var boolIndic:Boolean;
		protected var boolStopIndic:Boolean;
		protected var timerRush:int;
		protected var lIndic:IndicateurMissile;
		protected var runBool:Boolean;
		protected var velocity:Point;
		
		public function Missiles() 
		{
			super();
			list.push(this);
		}
		/**
		 * Gère les collisions avec les obstacles et le player
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			
			if (state == "explosion" && isAnimEnd()){
				destroy();
			}
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, null, Player.getInstance().hitBoxes)){
				setState("explosion");
				speed = 0;
				if (Player.getInstance().god == false) Player.getInstance().respawn();
			}
			
			//Si il y a collision avec un Obstacle
			for (var o:int = 0; o < Obstacles.obstacleList.length; o++){
				if (CollisionManager.hasCollision(hitBox, Obstacles.obstacleList[o].hitBox) && !(state == "explosion") && runBool){
					setState("explosion");
					speed = 0;
					Obstacles.obstacleList[o].takeDamage();
				}
			}
			
			if (!boolInit){
				x = GameLayer.getInstance().getScreenLimits().right + width/2;
				timerRush--;
				if (!boolStopIndic) boolIndic = true;
			}
			
			if (boolIndic){
				var lNum:String = getQualifiedClassName(this).substr( -1);
				var lClass: Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile" + lNum) as Class;
				lIndic = new lClass();
				
				lIndic.x = GameLayer.getInstance().getScreenLimits().right - lIndic.width - 100;
				lIndic.y = y;
				lIndic.start();
				GameLayer.getInstance().addChild(lIndic);
				boolStopIndic = true;
				boolIndic = false;
				
			}
			
			if (timerRush < 0 && !runBool){
				runBool = true;
				lIndic.destroy();
				boolInit = true;
			}
			
			if (runBool && !(this is Missile2)) {
				x -= speed;
			}
			
			if (x < GameLayer.getInstance().getScreenLimits().left || y < GameLayer.getInstance().getScreenLimits().top || y > GameLayer.getInstance().getScreenLimits().bottom){
				destroy();
			}
		}
		override public function destroy():void 
		{
			super.destroy();
			list.splice(list.indexOf(this), 1);
		}
	}

}