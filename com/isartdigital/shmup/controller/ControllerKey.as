package com.isartdigital.shmup.controller 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.Config;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * Controleur clavier
	 * @author Mathieu ANTHOINE
	 */
	public class ControllerKey extends Controller
	{
		/**
		 * instance unique de la classe ControllerKey
		 */
		protected static var instance: ControllerKey;
		
		/**
		 * tableau stockant l'etat appuyé ou non des touches
		 */
		protected var keys:Array = new Array();
		
		public function ControllerKey() 
		{
			super();
			
			Config.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Config.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): ControllerKey {
			if (instance == null) instance = new ControllerKey();
			return instance;
		}

		private function onKeyDown(pEvent:KeyboardEvent):void{
			keys[pEvent.keyCode] = true;
		}
		
		private function onKeyUp(pEvent:KeyboardEvent):void{
			keys[pEvent.keyCode] = false;
		}
		
		override public function get left():Number 
		{
			return keys[Keyboard[Config["keyLeft"]]] ? 1 : 0;
		}
		
		override public function get right():Number 
		{
			return keys[Keyboard[Config["keyRight"]]] ? 1 : 0;
		}
		
		override public function get up():Number 
		{
			return keys[Keyboard[Config["keyUp"]]] ? 1 : 0;
		}
		
		override public function get down():Number 
		{
			return keys[Keyboard[Config["keyDown"]]] ? 1 : 0;
		}
		
		override public function get fire():Boolean 
		{
			return keys[Keyboard[Config["keyFire"]]] ? true : false;
		}
		override public function get bomb():Boolean 
		{
			return keys[Keyboard[Config["keyBomb"]]] ? true : false;
		}
		
		override public function get special():Boolean 
		{
			return keys[Keyboard[Config["keySpecial"]]] ? true : false;
		}
		
		override public function get pause():Boolean 
		{
			return keys[Keyboard[Config["keyPause"]]] ? true : false;
		}
		
		override public function get god():Boolean 
		{
			return keys[Keyboard[Config["keyGod"]]] ? true : false;
		}
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			Config.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Config.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
	}
}