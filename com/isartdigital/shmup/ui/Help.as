package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.GameInput;
	
	/**
	 * Ecran d'aide
	 * @author Mathieu ANTHOINE
	 */
	public class Help extends Screen 
	{
		
		/**
		 * instance unique de la classe Help
		 */
		protected static var instance: Help;

		public var btnNext:SimpleButton;
		public var btnBack:SimpleButton;
		
		public var mcPad:Sprite;
		public var mcKeyboard:Sprite;
		public var mcTouch:Sprite;
		
		protected var pad:GameInput;
		
		public function Help() 
		{
			super();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Help {
			if (instance == null) instance = new Help();
			return instance;
		}
		
		override protected function init (pEvent:Event): void {
			super.init(pEvent);
			btnNext.addEventListener(MouseEvent.CLICK, onClickNext);
			btnBack.addEventListener(MouseEvent.CLICK, onClickBack);
			stage.quality = StageQuality.HIGH;
			
			//Adapte l'écran Help en fonction du Controller detecté au lancement du jeu
			switch (Controller.type) {
				case Controller.KEYBOARD:
					mcPad.visible = false;
					mcTouch.visible = false;
					break;
				case Controller.PAD:
					mcKeyboard.visible = false;
					mcTouch.visible = false;
					break;
				case Controller.TOUCH:
					mcPad.visible = false;
					mcKeyboard.visible = false;
			}
		}
		
		protected function onClickNext (pEvent:MouseEvent) : void 
		{
			UIManager.closeScreens();
			SoundManager.stopSounds();
			SoundManager.getSound("click").start();
			GameManager.start();
			
		}
		
		protected function onClickBack(pEvent:MouseEvent): void
		{
			UIManager.closeScreens();
			SoundManager.getSound("click").start();
			UIManager.addScreen(TitleCard.getInstance());
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			btnNext.removeEventListener(MouseEvent.CLICK, onClickNext);
			instance = null;
			super.destroy();
		}

	}
}