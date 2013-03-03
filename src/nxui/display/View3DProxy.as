package nxui.display
{
	import flash.display.Stage;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;

	public class View3DProxy implements IEngineDisplayProxy
	{
		private var camera:Camera3D;
		
		private var scene:Scene3D;
		
		public function View3DProxy()
		{
		}
		
		
		public function createInstance(stage:Stage, stage3DProxy:Stage3DProxy) : Object
		{
			var viewRoot:View3D = new View3D();
			viewRoot.stage3DProxy = stage3DProxy;
			viewRoot.shareContext = true;
			scene = viewRoot.scene;
			camera = viewRoot.camera;
			return viewRoot;
		}
	}
}