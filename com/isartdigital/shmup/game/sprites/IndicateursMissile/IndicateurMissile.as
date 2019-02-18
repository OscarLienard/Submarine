package com.isartdigital.shmup.game.sprites.IndicateursMissile 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * ...
	 * @author oscar
	 */
	public class IndicateurMissile extends StateObject 
	{
		public static var list:Vector.<IndicateurMissile> = new Vector.<IndicateurMissile>();
		protected var speed:int = 10;
		
		public function IndicateurMissile() 
		{
			super();
			list.push(this);
		}
		
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			x += GameLayer.getInstance().getSpeed();
		}
	}

}