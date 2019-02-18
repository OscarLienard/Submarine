package com.isartdigital.shmup.ui 
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * Classe mère des écrans de fin
	 * @author Mathieu ANTHOINE
	 */
	public class EndScreen extends Screen 
	{
		
		public var mcBackground:Sprite;
		public var mcScore:MovieClip;
		public var txtScore:TextField;
		
		public var btnNext:SimpleButton;
	
		public function EndScreen() 
		{
			super();
		}
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnNext.addEventListener(MouseEvent.CLICK, onClickNext);
			TweenLite.fromTo(mcScore, 1, {scaleX:0.5, scaleY:0.5}, {scaleX:1, scaleY:1});
		}
		
		protected function onClickNext(pEvent:MouseEvent):void
		{
			UIManager.closeScreens();
			SoundManager.stopSounds();
			UIManager.addScreen(TitleCard.getInstance());
			SoundManager.getSound("click").start();
			GameManager.restart();
		}
		
		/**
		 * Permet de mettre à jour le score à l'affichage des écrans Win/GameOver
		 */
		public function updateScore():void{
			mcScore.txtScore.text = "Score : " + Hud.getInstance().scoreNumber;
		}
		
		override protected function onResize (pEvent:Event=null): void {	
			UIManager.setPosition(mcBackground, UIPosition.FIT_SCREEN);
		}
	}
}