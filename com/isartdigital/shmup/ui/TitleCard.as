package com.isartdigital.shmup.ui
{
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.Credits;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Ecran principal
	 * @author Mathieu ANTHOINE
	 */
	public class TitleCard extends Screen
	{
		
		/**
		 * instance unique de la classe TitleCard
		 */
		protected static var instance:TitleCard;
		
		public var btnPlay:SimpleButton;
		public var btnCredits:SimpleButton;
		
		/**
		 * Lance le son d'UI au démarrage du jeu plutôt que quand on arrive sur l'écran, afin d'éviter de redémarrer le son à chaque changement d'écran
		 */
		public function TitleCard()
		{
			super();
			if (!(SoundManager.getSound("uiLoop").isPlaying)) SoundManager.getSound("uiLoop").fadeIn(0.1);
			
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance():TitleCard
		{
			if (instance == null) instance = new TitleCard();
			return instance;
		}
		
		override protected function init(pEvent:Event):void
		{
			super.init(pEvent);
			btnPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
			btnCredits.addEventListener(MouseEvent.CLICK, onClickCredits);
			stage.quality = StageQuality.HIGH;
		}
		
		protected function onClickPlay(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			UIManager.addScreen(Help.getInstance());
			SoundManager.getSound("click").start();
		}
		
		protected function onClickCredits(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			UIManager.addScreen(Credits.getInstance());
			SoundManager.getSound("click").start();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void
		{
			btnPlay.removeEventListener(MouseEvent.CLICK, onClickPlay);
			btnCredits.removeEventListener(MouseEvent.CLICK, onClickCredits);
			instance = null;
			super.destroy();
		}
	
	}
}