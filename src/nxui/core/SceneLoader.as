package nxui.core 
{

	import flash.utils.*;
	import nxui.display.SceneBase;
	/**
	 * ...
	 */
	public class SceneLoader 
	{	
		private var classes:Dictionary;
		
		public function SceneLoader()
		{
			classes = new Dictionary();
		}
		
		public function pushType(instance:SceneBase) : void
		{
			classes[getQualifiedClassName(instance)] = instance;
		}
		
	}

}