package nxui.display 
{
	import com.nxui.display.AnimationSprite;
	import com.nxui.display.LoadingSprite;
	import com.nxui.display.SceneProxy;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	import nxui.core.Nxui;
	import nxui.display.SceneBase;
	import nxui.events.SceneEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import nxui.display.IEngineDisplayProxy;	
	import nxui.events.NxuiEvent;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;

	
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
				if ( obj["type"] == getQualifiedClassName(Starling) )
				{
					Starling(obj["child"]).nextFrame();
				}
				else if ( obj["type"] == getQualifiedClassName(View3D) )
				{
					View3D(obj["child"]).render();
				}
			}	
		}
		
			
		override public function generateRenderGroup(group:RenderGroup) : void
		{
			// Get the current nxui context
			var instance:Nxui = Nxui.current;			
			if ( instance == null ) 
			{
				throw new Error("[MixedScene] NXUI context is null");
			}
			
			// Get our needed variables
			var viewPort:Rectangle = instance.viewPort;
			var stage:Stage3D = instance.stage3D;
			
			// Hydrate the objects
			var i:int;
			for ( i = 0; i < numChildren; i++)
			{
				var proxy:IEngineDisplayProxy = group.getChildAt(i) as IEngineDisplayProxy;
				proxy.createInstance(instance.root.stage, viewPort, stage);
			}			

		}		
	
	}

}