package com.isartdigital.shmup.game.sprites.Collectibles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class Collectibles extends StateObject
	{
		protected var collecName:String;
		protected var boolGet:Boolean;
		protected static var collecSet1:Vector.<String> = new <String>["CollectableBomb", "CollectableFirePower", "CollectableFireUpgrade", "CollectableLife"];
		protected static var collecSet2:Vector.<String> = new <String>[];
		public static var index2:int;
		public static var collecList:Vector.<Collectibles> = new <Collectibles>[];
		public var bombs = Player.getInstance().bombs;
		public function Collectibles() 
		{
			super();
			collecList.push(this);
		}
		
		/**
		 * Fait apparaître de manière semi-aléatoire un collectible choisi depuis une liste, 
		 * et supprime le collectible obtenu de la liste afin de ne pas l'obtenir deux fois de suite
		 * 
		 * @param	Position en X du collectible à faire apparaître 
		 * @param	Position en Y du collectible à faire apparaître
		 * @param	Probabilité de faire apparaître un collectible, permet de personnaliser le taux d'obtention selon les ennemis, avec 1 = 100% et 5 = 20%
		 */
		public static function spawn(pX:int, pY:int, pDropChance):void{
			if (Math.floor(Math.random()*pDropChance) == pDropChance-1){
			var lClass:Class = Class(getDefinitionByName("com.isartdigital.shmup.game.sprites.Collectibles." + semiAlea() ));
			var lCollec = new lClass();
			lCollec.x = pX;
			lCollec.y = pY;
			lCollec.start();
			GameLayer.getInstance().addChild(lCollec);
			collecSet2.removeAt(index2);
			}
			else {}
		}
		
		/**
		 * Gère les collisions, les sons, et le changement d'état des collectibles grâce au booléen boolGet
		 * (possible de le faire également sans passer par le booléen avec (state == get) ou l'inverse en condition
		 * Détruit le collectible une fois son animation terminée
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox)){
				if (this is CollectableLife && !boolGet){
					SoundManager.getSound("powerupLife").start();
					if (Player.getInstance().life < 3){
						Player.getInstance().life++;
						if (Player.getInstance().life == 3) TweenLite.to(Hud.getInstance().mcTopRight.getChildAt(4), 0.5, {scaleX:1, scaleY:1});
						if (Player.getInstance().life == 2) TweenLite.to(Hud.getInstance().mcTopRight.getChildAt(1), 0.5, {scaleX:1, scaleY:1});
					}
				}
				if (this is CollectableBomb && !boolGet){
					SoundManager.getSound("powerupBomb").start();
					if (Player.getInstance().bombs < 2){
						Player.getInstance().bombs++;
						if (Player.getInstance().bombs == 2) TweenLite.to(Hud.getInstance().mcTopLeft.getChildAt(1), 0.5, {scaleX:1, scaleY:1});
						if (Player.getInstance().bombs == 1) TweenLite.to(Hud.getInstance().mcTopLeft.getChildAt(0), 0.5, {scaleX:1, scaleY:1});
					}
				}
				if (this is CollectableFireUpgrade && !boolGet){
					SoundManager.getSound("powerupFireUpgrade").start();
					if (Player.getInstance().shootLevel < 2){
						Player.getInstance().shootLevel++;
					}
				}
				if (this is CollectableFirePower && !boolGet){
					SoundManager.getSound("powerupFirePower").start();
				}
				
				setState("get");
				boolGet = true;
				
			}
			if (boolGet && renderer.currentFrame == renderer.totalFrames) destroy();
		}
		
		/**
		 * Remplit le tableau dans lequel les collectibles sont choisis, quand il est vide
		 * @return le collectible à générer grâce à la méthode spawn()
		 */
		public static function semiAlea():String{
			if (collecSet2.length == 0){
				collecSet2 = collecSet1.slice(0);
			}
			
			var index = Math.floor(collecSet2.length * Math.random());
			index2 = index;
			return collecSet2[index];
		}
		
		override public function destroy():void 
		{
			super.destroy();
			collecList.splice(collecList.indexOf(this), 1);
		}
		
	}

}