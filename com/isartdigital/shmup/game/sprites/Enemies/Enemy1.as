package com.isartdigital.shmup.game.sprites.Enemies 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemies;
	import com.isartdigital.shmup.game.sprites.IndicateursMissile.IndicateurMissile0;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Enemy1 extends Enemies 
	{
		protected var boolPosPlayer:Boolean;
		protected var boolInit:Boolean;
		protected var boolStartMove:Boolean;
		protected var boolRota:Boolean;
		protected var boolIndic:Boolean;
		protected var boolStopIndic:Boolean;
		protected var timer:int = 60;
		protected var incrementX:int = 40;
		protected var timerRush:int = 120;
		protected var lIndic:IndicateurMissile0 = new IndicateurMissile0();
		
		public function Enemy1() 
		{
			super();
			numWeapons = 3;
			enemyLevel = 1;
			stopX = 750;
			shootFrequence = 80;
			speed = 3;
			hp = 10;
			collecDropChance = 2;
			rotation = 180;
		}
		
		/**
		 * L'ennemi 1 voit son pattern décomposé en 4 parties :
		 * Tout d'abord il se place à gauche de l'écran en dehors de la zone de jeu, un indicateur apparaît sur sa position X
		 * Une fois le timer écoulé, l'indicateur disparait et l'ennemi effectue un rush horizontal vers la droite jusqu'à un certain point
		 * Il amorce alors une rotation de 180° pour faire face au Player
		 * Enfin, il commence à se déplacer verticalement et à tirer (appel du super)
		 */
		override protected function doActionNormal():void 
		{
			if (!boolInit){
				x = GameLayer.getInstance().getScreenLimits().left - width/2;
				timerRush--;
				if (!boolStopIndic) boolIndic = true;
			}
			if (boolIndic){
				lIndic.x = GameLayer.getInstance().getScreenLimits().left + lIndic.width/2;
				lIndic.y = y;
				lIndic.start();
				GameLayer.getInstance().addChild(lIndic);
				boolStopIndic = true;
				boolIndic = false;
			}
			if (timerRush <= 0){
				x += incrementX;
				if (!boolInit) lIndic.destroy();
				boolInit = true;
			}
			if (x > (GameLayer.getInstance().getScreenLimits().right - stopX)){
				timerRush = 1;
				boolStartMove = true;
				cacheAsBitmap = false;
			}
			if (boolStartMove){
				super.doActionNormal();
				if (rotation > 0){
					rotation -= 10;
				}
				move();
			}
		}
		
		/**
		 * Une fois sa rotation terminée, essaye de s'aligner sur la position en Y du player, sans pour autant réussir.
		 */
		override public function move():void 
		{
			super.move();
			timer ++;
				if (boolPosPlayer) y -= 3;
				if (!boolPosPlayer) y += 3;
				if (timer >= 50){
					if (Player.getInstance().y > y) boolPosPlayer = false;
					if (Player.getInstance().y < y) boolPosPlayer = true;
					timer = 0;
				}
		}
		override public function get hitBoxes():Vector.<DisplayObject> 
		{
			return new <DisplayObject>[collider.hitBox1, collider.hitBox2, collider.hitBox3, collider.hitBox4];
		}
	}

}