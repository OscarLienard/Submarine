package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Allan
	 */
	public class Pause extends Screen 
	{
		
		/**
		 * instance unique de la classe Pause
		 */
		protected static var instance: Pause;
		
		public var btnPlay:SimpleButton;
		public var btnRetry:SimpleButton;
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Pause {
			if (instance == null) instance = new Pause();
			return instance;
		}		
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
			btnRetry.addEventListener(MouseEvent.CLICK, onClickRetry);
			stage.quality = StageQuality.HIGH;
		}
		
		public function onClickPlay(pEvent:MouseEvent):void
		{
			GameManager.resume();
			UIManager.closeScreens();
			SoundManager.getSound("click").start();
		}
		
		protected function onClickRetry(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			Hud.getInstance().destroy();
			GameManager.restart();
			SoundManager.stopSounds();
			SoundManager.getSound("click").start();
			UIManager.addScreen(TitleCard.getInstance());
		}
		
		public function Pause() 
		{
			super();
			
		}
	}
}