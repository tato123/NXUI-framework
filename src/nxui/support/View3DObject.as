package nxui.support
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	import nxui.display.IEngineDisplayProxy;
	import nxui.display.Stage3DRenderObject;
	import spark.components.Group;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;

	public class View3DObject extends Stage3DRenderObject
	{
		private var camera:Camera3D;		
		private var scene:Scene3D;
		
		
		override public function createInstance(stage:Stage, viewPort:Rectangle, stage3D:Stage3D) : Object
		{
			var viewRoot:View3D = new View3D();
			
			viewRoot.shareContext = true;
			scene = viewRoot.scene;
			camera = viewRoot.camera;
			return viewRoot;
		}
	}
}