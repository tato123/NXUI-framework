package nxui.display 
{
	import spark.components.Group;
	/**
	 * ...
	 */
	public class Stage3DRenderObject extends Group
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
		
		
	}

}