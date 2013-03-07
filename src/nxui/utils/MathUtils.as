package nxui.utils
{
	import flash.geom.Vector3D;

	public class MathUtils
	{
		public static function degreeToRadians(angle:Number) : Number
		{
			return angle * Math.PI/180;
		}
		
		
		public static function RandomCircle(angle:Number, center:Vector3D, radius:Number): Vector3D 
		{			
			// create random angle between 0 to 360 degrees			
			var pos: Vector3D = new Vector3D();
			pos.x = center.x + radius * Math.sin(MathUtils.degreeToRadians(angle));
			pos.y = center.y + radius * Math.cos(MathUtils.degreeToRadians(angle));
			pos.z = center.z;
			return pos;
		}
		
		public static function clamp(val:Number, min:Number = 0, max:Number = 100) : Number
		{
			    return Math.max(min, Math.min(max, val))
		}
	}
}