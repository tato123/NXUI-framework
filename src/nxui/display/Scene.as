package nxui.display
{
	
	

	public class Scene
	{

		private var _pause:Boolean;

		
		public function willAppear() : void			
		{
			// Do something here if we want to 
		}
		
		
		public function update(delta:Number) : void
		{
			// This method should be overriden in subclasses
		}
		
		public function willDisappear() : void
		{
			
		}
		
		
		// +---------------------------------------------------------------------
		// Scene
		// +---------------------------------------------------------------------		
				
		public function set pause(val:Boolean) : void 
		{
			_pause = val;
		}
		
		public function get pause() : Boolean
		{
			return _pause;
		}
	}
}