package nxui.display
{
	import flash.display.Stage;
	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;

	public class View3DProxy implements IEngineDisplayProxy
	{
		public function View3DProxy()
		{
		}
		
		
		public function createInstance(stage:Stage, stage3DProxy:Stage3DProxy) : Object
		{
			var viewRoot:View3D = new View3D();
			viewRoot.stage3DProxy = stage3DProxy;
			viewRoot.shareContext = true;
			viewRoot.camera.lens = new PerspectiveLens(55);
			viewRoot.width = stage.width;
			viewRoot.height = stage.height;
			return viewRoot;
		}
	}
}