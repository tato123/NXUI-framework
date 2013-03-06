package nxui.display 
{
	import com.nxui.display.AnimationSprite;
	import com.nxui.display.LoadingSprite;
	import com.nxui.display.SceneProxy;
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
	public class MixedSceneBase extends SceneBase
	{
		
		public function MixedSceneBase() 
		{
			
		}
		
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
			if ( children ) 
			{
				for each ( var child:Object in children ) 
				{
					if ( child is IEngineDisplayProxy)
					{						
						addChild(IEngineDisplayProxy(child).createInstance(_root.stage, stage3DProxy));
					}
					else if ( child is Object ) 
					{
						addChild(IEngineDisplayProxy(child["layer"]).createInstance(_root.stage, stage3DProxy), child["id"]);
					}
				}
			}
		}
	
		/**
		 * Add a display child
		 */
		/*public function addChild(child:Object, id:String=null) : void
		{
			if ( child is Starling || child is View3D) 
			{				
				
				var ref:Object = {"type":getQualifiedClassName(child), "child":child, "id":id};				
				_displayList.push(ref);
				
				if ( child is View3D )
				{					
					_root.addChild(View3D(child));	
				}
				
				 
			}
			else
			{
				throw new Error("[NXUI] Scene child must be of type starling or away3d");
			}
		}*/
		
	
	}

}