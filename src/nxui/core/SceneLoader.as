package nxui.core 
{

	import flash.utils.*;
	import nxui.display.Scene;
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
		
		public function pushType(instance:Scene) : void
		{
			classes[getQualifiedClassName(instance)] = instance;
		}
		
	}

}