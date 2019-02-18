package com.isartdigital.shmup.ui.hud 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * Classe en charge de gérer les informations du Hud
	 * @author Mathieu ANTHOINE
	 */
	public class Hud extends Screen 
	{
		
		/**
		 * instance unique de la classe Hud
		 */
		protected static var instance: Hud;
		
		public var mcTopLeft:MovieClip;
		public var mcTopCenter:MovieClip;
		public var mcTopRight:MovieClip;
		public var mcBottomRight:MovieClip;
		public var mcSpecialBar:MovieClip;
		public var mcBar:MovieClip;
		public var mcGuide0:MovieClip;
		public var mcGuide1:MovieClip;
		public var btnPause:SimpleButton;
		public var boolPause:Boolean;
		public var txtScore:TextField;
		
		protected var score:TextField;
		public var scoreNumber:int = 0;
		public function Hud() 
		{
			super();
			if (!Config.debug && Controller.type != Controller.TOUCH) {
				removeChild(mcBottomRight);
				mcBottomRight = null;
			}
			addEventListener(Event.ENTER_FRAME, gameLoop);
			mcTopRight.btnPause.addEventListener(MouseEvent.CLICK, pause);
		}
		
		/**
		 * Permet à la barre de special de se scale en fonction de son mana
		 * Affiche le score actuel
		 * @param	pEvent
		 */
		public function gameLoop(pEvent:Event){
			mcTopCenter.txtScore.text = "" + scoreNumber;
			
			mcTopLeft.mcSpecialBar.mcBar.scaleX = Player.getInstance().manaSpecial / 50;
			
		}
		
		protected function pause(pEvent:MouseEvent):void{
			if (!boolPause){
				GameManager.pause();
				boolPause = true;
			}
			else {
				GameManager.resume();
				boolPause = false;
			}
		}
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Hud {
			if (instance == null) instance = new Hud();
			return instance;
		}
		
		/**
		 * Adapte le placement du Hud en fonction de la taille de la fenêtre
		 * 
		 * Le conteneur du score placé en fonction de la position du conteneur TopRight pour aller dans le sens du GDD
		 * @param	pEvent
		 */
		override protected function onResize (pEvent:Event=null): void {
			UIManager.setPosition(mcTopLeft, UIPosition.TOP_LEFT);
			//UIManager.setPosition(mcTopCenter, UIPosition.TOP);
			UIManager.setPosition(mcTopRight, UIPosition.TOP_RIGHT);
			mcTopCenter.x = mcTopRight.x - mcTopRight.width*1.3;
			mcTopCenter.y = mcTopRight.y - 50 
			if (mcBottomRight!=null) UIManager.setPosition(mcBottomRight, UIPosition.BOTTOM_RIGHT);
		}
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			parent.removeChild(this);
			instance = null;
			super.destroy();
		}

	}
}