package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.SimpleButton;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * Classe Game OVer (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class GameOver extends EndScreen 
	{
		/**
		 * instance unique de la classe GameOver
		 */
		protected static var instance: GameOver;
		
		public var btnRetry:SimpleButton;
		
		public function GameOver() 
		{
			super();
		}
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnRetry.addEventListener(MouseEvent.CLICK, onClickRetry);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameOver {
			if (instance == null) instance = new GameOver();
			return instance;
		}
		
		protected function onClickRetry(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			SoundManager.stopSounds();
			UIManager.addScreen(Help.getInstance());
			SoundManager.getSound("click").start();
			SoundManager.getSound("uiLoop").fadeIn(0.1);
			GameManager.restart();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
	}

}