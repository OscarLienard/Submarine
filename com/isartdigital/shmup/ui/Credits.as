package com.isartdigital.shmup.ui 
{
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
	public class Credits extends Screen 
	{
		
		/**
		 * instance unique de la classe Credits
		 */
		protected static var instance: Credits;
		
		public var btnBack:SimpleButton;
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Credits {
			if (instance == null) instance = new Credits();
			return instance;
		}		
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnBack.addEventListener(MouseEvent.CLICK, onClickBack);
			stage.quality = StageQuality.HIGH;
		}
		
		public function onClickBack(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			UIManager.addScreen(TitleCard.getInstance());
			SoundManager.getSound("click").start();
		}
		
		public function Credits() 
		{
			super();
			
		}
	}
}