package nxui.display 
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	import spark.components.Group;
	/**
	 * ...
	 */
	public class Stage3DRenderObject extends Group implements IEngineDisplayProxy
	{
		protected var _objectType:String;		
		private var _dataProvider:Array;
		
		public var type:String;
		public var eulerX:Number;
		public var eulerY:Number;
		public var eulerZ:Number;
		
		
		public function Stage3DRenderObject() 
		{
			objectType = "null";
			
		}
		
		//+-------------------------------------------------------------
		// Getters / Setters
		//+-------------------------------------------------------------
		
		public function get objectType() : String
		{
			return _objectType;
		}
		
		public function set objectType(val:String) : void
		{
			_objectType = val;
		}
		
		public function get dataProvider() : Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(val:Array) : void
		{
			_dataProvider = val;
		}
		
		//+-------------------------------------------------------------
		// Generate this object
		//+-------------------------------------------------------------
		public function createInstance(stage:Stage, viewPort:Rectangle, stage3D:Stage3D) : Object
		{
			throw new Error("[NXUI] Method createInstance should be overriden");
		}
	}

}