package nxui.core 
{
	
	import nxui.display.SceneBase;
	/**
	 * ...
	 */
	public class SceneController implements BootStrapObject
	{
		private var _scene:SceneBase;
		private var _bootstrapper:SceneBootstrapper;
		
		public function SceneController(scene:SceneBase=null)
		{
			_scene = scene;
		}
		
		
		public function get scene() : SceneBase
		{
			return _scene;
		}
		
		public function get bootstrapper() :SceneBootstrapper
		{
			return _bootstrapper;
		}
		
		public function set bootstrapper(val:SceneBootstrapper) : void
		{
			_bootstrapper = val;
		}
		
	}

}