package nxui.core 
{
	import nxui.display.Scene;
	/**
	 * ...
	 */
	public class SceneController implements BootStrapObject
	{
		private var _scene:Scene;
		private var _bootstrapper:SceneBootstrapper;
		
		public function SceneController(scene:Scene=null)
		{
			_scene = scene;
		}
		
		
		public function get scene() : Scene
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