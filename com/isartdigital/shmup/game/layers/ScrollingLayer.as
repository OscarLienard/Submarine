package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.GameStage;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Classe "Plan de scroll", chaque plan de scroll (y compris le GameLayer) est une instance de ScrollingLayer ou d'une classe fille de ScrollingLayer
	 * TODO: A part GameLayer, toutes les instances de ScrollingLayer contiennent 3 MovieClips dont il faut gérer le "clipping" afin de les faire s'enchainer correctement
	 * alors que l'instance de ScrollingLayer se déplace
	 * @author Mathieu ANTHOINE
	 */
	public class ScrollingLayer extends GameObject
	{
		protected var screenLimits:Rectangle;
		public var baseSpeed : Number = 5;
		protected var ref : ScrollingLayer;
		protected var backgroundPartsLength:int = 1220;
		public var backgroundParts:Vector.<Object> = new Vector.<Object>;
		
		
		public function ScrollingLayer() 
		{
			super();
		}

		public function init (pSpeed : Number, pRef : ScrollingLayer = null) : void{
			baseSpeed = pSpeed;
			ref = pRef;
			for (var e:int = 0; e < numChildren; e++){
				backgroundParts.push(getChildAt(e));
			}
			
			backgroundParts.sort( function (pA:Object, pB:Object) : int { return pA.x < pB.x ? -1 : 1 } );
			for (var i:int = 0; i < backgroundParts.length; i++ ){
				backgroundParts[i].cacheAsBitmap = true;
				if (!(backgroundParts[i] is Shape)) backgroundParts[i].stopAllMovieClips();
			}
		} 
		
		protected function setScreenLimits ():void {
			var lTopLeft:Point = new Point (0, 0);
			var lTopRight:Point = new Point (Config.stage.stageWidth, 0);
			
			lTopLeft = globalToLocal(lTopLeft);
			lTopRight = globalToLocal(lTopRight);
				
			screenLimits=new Rectangle(lTopLeft.x, 0, lTopRight.x-lTopLeft.x, GameStage.SAFE_ZONE_HEIGHT);
		}
		
		/**
		 * Retourne les coordonnées des 4 coins de l'écran dans le repère du plan de scroll concerné 
		 * Petite nuance: en Y, retourne la hauteur de la SAFE_ZONE, pas de l'écran, car on a choisi de condamner le reste de l'écran (voir cours Ergonomie Multi écran)
		 * @return Rectangle dont la position et les dimensions correspondant à la taille de l'écran dans le repère local
		 */
		public function getScreenLimits ():Rectangle {
			return screenLimits;
		}
		
		/**
		 * Fait boucler les trois parties de background afin de donner une impression de vitesse
		 */
		override protected function doActionNormal():void 
		{
			x = ref.x * baseSpeed;
			setScreenLimits();
			
			if (backgroundParts[1].x <= getScreenLimits().left){
				backgroundParts[0].x += backgroundPartsLength * 3;
				backgroundParts.sort( function (pA:MovieClip, pB:MovieClip) : int { return pA.x < pB.x ? -1 : 1 } );
			}
		}
	}

}