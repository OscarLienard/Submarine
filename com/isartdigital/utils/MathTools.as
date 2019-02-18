package com.isartdigital.utils 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Chadi Husser
	 */
	public class MathTools 
	{
		
		public static var DEG2RAD : Number = Math.PI / 180;
		public static var RAD2DEG : Number = 180 / Math.PI;
		
		public static function randomRange(pMin:Number, pMax:Number): Number {
			return Math.random() * (pMax - pMin) + pMin;
		}
		
		public static function lerp(pMin:Number, pMax:Number, pCoeff:Number) : Number {
			pCoeff = clamp(pCoeff, 0, 1);
			return pMin * (1 - pCoeff) + pMax * pCoeff;
		}
		
		public static function clamp(pNumber:Number, pMin:Number, pMax:Number) : Number {
			return Math.max(Math.min(pNumber, pMax), pMin);
		}
	}

}