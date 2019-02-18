package com.isartdigital.shmup.game.sprites.Obstacles 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacles.Obstacles;
	/**
	 * ...
	 * @author oscar
	 */
	public class Obstacle2 extends Obstacles 
	{
		public static var list:Vector.<Obstacle2> = new Vector.<Obstacle2>();
		
		protected var timerExplo:int = 0;
		public var immobile:Boolean;
		
		public function Obstacle2() 
		{
			super();
			list.push(this);
		}
		
		public function explosion():void{
			cacheAsBitmap = false;
			setState("explosion");
		}
		
		// J'ai dû utiliser un timer car problème avec l'animation du graphisme, pas possible d'utiliser isAnimEnd()
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (state == "explosion") timerExplo++;
			if (state == "explosion" && timerExplo > 30){
				destroy();
			}
			
			if (immobile) x += GameLayer.getInstance().getSpeed();
			
			if (hp == 0 && !(state == "explosion")) explosion();
		}
		
		override public function takeDamage():void 
		{
			super.takeDamage();
			explosion();			
		}
		override public function destroy():void 
		{
			super.destroy();
			list.splice(list.indexOf(this), 1);
		}
	}

}