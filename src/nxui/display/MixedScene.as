package nxui.display 
{
	

	
	/**
	 * ...
	 */
	public class MixedScene extends SceneBase
	{
	
		override public function update(delta:Number) : void
		{
			
			// This method should be overriden in subclasses
			// Draw each layer to the frame buffer
			var i:int;
			for ( i = 0; i < numChildren; i++)
			{
				
				var obj:Object = getChildAt(i);
				if ( obj is RenderGroup )
				{
					RenderGroup(obj).render();
				}
				
			}	
		}
	
	}

}