package nxui.display 
{
	import spark.components.Group;
	
	
	/**
	 * Render group represents a logical set of objects that
	 * should attempt to be rendered during the same frame render pass	 
	 */
	public class RenderGroup extends Group 
	{
		private var rawLayers:Array = []
		
		
		override public function invalidateDisplayList() : void
		{
			var i:int;
			for ( i = 0; i < numChildren; i++)
			{
				
				var obj:Object = getChildAt(i);
				// Create the instance 
				var renderObject:Object = Stage3DRenderObject(obj).createInstance();
				
			}	
		}
		
		
		public function render() : void
		{
			
		}
		
	}

}