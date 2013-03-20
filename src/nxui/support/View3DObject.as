package nxui.support
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	
	import nxui.display.Stage3DRenderObject;

	public class View3DObject extends Stage3DRenderObject
	{
		private var camera:Camera3D;		
		private var scene:Scene3D;
		
		
		override public function createInstance() : Object
		{
			var viewRoot:View3D = new View3D();
			
			viewRoot.shareContext = true;
			scene = viewRoot.scene;
			camera = viewRoot.camera;
			return viewRoot;
		}
	}
}