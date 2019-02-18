package com.isartdigital.utils.game {

	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer;
	import com.isartdigital.shmup.game.sprites.ShootsPlayer.ShootPlayer0;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe de base des objets interactifs ayant plusieurs états graphiques
	 * Elle gère la représentation graphique (renderer) et les conteneurs utiles au gamePlay (collider) qui peuvent être de simples boites de collision ou beaucoup plus
	 * suivant l'implémentation faite par le développeur dans les classes filles
	 * @author Mathieu ANTHOINE
	 */
	public class StateObject extends GameObject 
	{
		/**
		 * renderer (animation) de l'état courant
		 */
		protected var renderer:MovieClip;
		protected var rendererWeapon:MovieClip;
		
		public static var list:Vector.<StateObject> = new <StateObject>[];
		/**
		 * collider de l'état courant ou collider générale si multiColliders est false
		 */
		protected var collider:MovieClip;
		
		/**
		 * suffixe du nom d'export des Symboles Animés
		 */
		protected static const RENDERER_SUFFIX:String = "";
		
		/**
		 //* suffixe du nom d'export des Symboles collider
		 */
		protected static const COLLIDER_SUFFIX:String = "_collider";	
		
		/**
		 * etat par défaut
		 */
		protected const DEFAULT_STATE:String = "default";
		
		/**
		 * Nom de l'asset (sert à identifier les symboles utilisées dans les fichiers assets.fla et colliders.fla)
		 */
		protected var assetName:String;
		
		/**
		 * état en cours
		 */
		protected var state:String;
		
		/**
		 * Animation de renderer qui boucle ou pas
		 * l'animation de renderer n'est jamais stoppée même quand loop est false
		 * l'animation de renderer ne renvoie jamais isAnimEnd si loop est true
		 */
		protected var loop:Boolean;
		
		/**
		 * Si multiColliders est false, seul un Symbole sert de collider pour tous les états
		 * Son nom d'export etant assetName+"_"+COLLIDER_SUFFIX
		 */
		protected var multiColliders:Boolean;
		
		/**
		 * niveau d'alpha des colliders, si l'alpha est à 0 (valeur par défaut), les colliders sont en fait invisibles
		 */
		public static var colliderAlpha:Number = 0;
		
		/**
		 * niveau d'alpha des graphismes, si l'alpha est à 0 (valeur par défaut), les graphismes sont en fait invisibles
		 */
		public static var rendererAlpha:Number=1;
		
		public function StateObject() 
		{
			super();
			if (assetName == null) assetName = getQualifiedClassName(this).split("::").pop();
			setState (DEFAULT_STATE);
			list.push(this);
		}
		
		/**
		 * défini l'état courant du MySprite
		 * @param	pState nom de l'état. Par exemple si pState est "run" et assetName "Player", renderer va chercher l'export "Player_run" dans le fichier assets.fla et collider "Player_run_collider" dans le fichier colliders.fla
		 * @param	pLoop l'animation boucle (isAnimEnd sera toujours false) ou pas
		 * @param	pStart lance l'animation à cette frame
		 */
		protected function setState (pState:String, pLoop:Boolean = false, pStart:uint = 1): void {
			if (state == pState) return;
			
			clearState();
			
			loop = pLoop;
			
			var lClass:Class = getDefinitionByName(assetName+"_" + pState+RENDERER_SUFFIX) as Class;
			
			renderer = new lClass();
			addChild(renderer);
			
			if (rendererAlpha== 0) renderer.visible = false;
			else renderer.alpha = rendererAlpha;
			
			if (renderer.totalFrames>1) renderer.gotoAndPlay(pStart);
			
			if (multiColliders || collider==null) {
				lClass = getDefinitionByName(assetName+ (multiColliders ? "_" + pState+COLLIDER_SUFFIX : COLLIDER_SUFFIX)) as Class;
				
				collider = new lClass();
				if (colliderAlpha== 0) collider.visible = false;
				else collider.alpha = colliderAlpha;
				addChild (collider);	
			}
			
			state = pState;
			
		}
		
		/**
		 * nettoie les conteneurs renderer et collider
		 * @param	pDestroy force un nettoyage complet
		 */
		protected function clearState (pDestroy:Boolean=false): void {
			if (state != null) {
				renderer.stop();
				removeChild(renderer);
				if (pDestroy || multiColliders) removeChild(collider);
			}
			state = null;
		}
		
		/**
		 * met en pause l'animation
		 */
		public function pause ():void {
			if (renderer != null) StateObject.pauseChildren(renderer);
		}
		
		static protected function pauseChildren (pParent:MovieClip):void {
			pParent.stop();
			var lLength:int = pParent.numChildren;
			for (var i:int = 0; i < lLength; i++) {
					if(pParent.getChildAt(i) is MovieClip) StateObject.pauseChildren(MovieClip(pParent.getChildAt(i)));
			}
		}
		
		/**
		 * relance l'animation
		 */
		public function resume ():void {
			if (renderer != null) StateObject.resumeChildren(renderer);
		}
		
		static protected function resumeChildren (pParent:MovieClip):void {
			pParent.play();
			var lLength:int = pParent.numChildren;
			for (var i:int = 0; i < lLength; i++) {
					if(pParent.getChildAt(i) is MovieClip) StateObject.resumeChildren(MovieClip(pParent.getChildAt(i)));
			}
		}
		
		/**
		 * précise si l'animation est arrivée à la fin
		 * @return animation finie ou non
		 */
		public function isAnimEnd (): Boolean {
			if (renderer != null && !loop) return renderer.currentFrame == renderer.totalFrames;
			return false;
		}
		
		/**
		 * retourne la zone de hit de l'objet
		 * fonction getter: est utilisé comme une propriété ( questionner hitBox et non hitBox() )
		 */
		public function get hitBox (): DisplayObject {
			return collider;
		}
		
		/**
		 * retourne un tableau de boites de collision
		 */
		public function get hitBoxes (): Vector.<DisplayObject> {
			return /*new Vector.<DisplayObject>(collider.getChildByName("mcHitPoint0"), collider.getChildByName("mcHitPoint2"));*/ null;
		}

		/**
		 * retourne un tableau de points de collision
		 */
		public function get hitPoints (): Vector.<Point> {
			return null;
		}

		/**
		 * nettoyage et suppression de l'instance
		 */
		override public function destroy (): void {
			clearState(true);
			renderer = null;
			collider = null;
			super.destroy();
		}
		
	}

}