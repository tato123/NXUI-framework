package nxui.core
{

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import nxui.display.IEngineDisplayProxy;
	import nxui.events.NxuiEvent;
	import nxui.display.Scene;
	
	import starling.core.Starling;
	

	/**
	 * Scene simiplifies the creation of a away3d + starling project
	 * by completly managing 
	 * 
	 * 
	 * 
	 */
	public class Nxui extends EventDispatcher
	{
		// Current context
		private var _root:Sprite;
		private var _displayList:Array;
		private var _sceneList:Array;
		private var _context:Nxui;
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var stage3DProxy : Stage3DProxy;
		
		// 
		private static var _current:Nxui;
		
		public function Nxui(root:Sprite, contextCreated:Function = null)
		{
			_root = root;
			
			// Init the display list and scenes
			_displayList = new Array();
			_sceneList = new Array();
			
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(_root.stage);
			
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 1;
			//stage3DProxy.color = 0x0;
			
			_root.stage.align = StageAlign.TOP_LEFT;
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;
		
			dispatchEvent(new NxuiEvent(NxuiEvent.CONTEXT_CREATED));
			
			_current = this;
		}
		
		public function start() : void
		{
			_root.stage.addEventListener(Event.ENTER_FRAME, onFrameEnter);
		}
		
		public function stop() : void
		{
			_root.stage.removeEventListener(Event.ENTER_FRAME, onFrameEnter);
		}
		
		// +---------------------------------------------------------------------
		// Event Listeners
		// +---------------------------------------------------------------------
		
		public function onContextCreated(evt:Stage3DEvent=null) : void
		{
			dispatchEvent(evt);			
		}
		
		public function onFrameEnter(evt:Event ) : void
		{
			stage3DProxy.clear();
			
			
			// Render the content for each layer
			if ( _sceneList.length > 0 )
			{
				Scene(_sceneList[_sceneList.length-1]).render();
			}
			
			// Draw each layer to the frame buffer
			for each (var obj:Object in _displayList ) 
			{
				
				if ( obj["type"] == getQualifiedClassName(Starling) )
				{
					Starling(obj["child"]).nextFrame();
				}
				else if ( obj["type"] == getQualifiedClassName(View3D) )
				{
					View3D(obj["child"]).render();
				}
			}
			
			// Swap for display buffer
			stage3DProxy.present();
		}

		
		// +---------------------------------------------------------------------
		// Display Hiearchy
		// +---------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function getChildWithTag(id:String) : Object
		{
			for each (var child:Object in _displayList)
			{
				if ( child["id"] == id )
				{
					return child["child"];
				}
			}
			return null;
		}
		
		/**
		 * Add a display child
		 */
		public function addChild(child:Object, id:String=null) : void
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
		}
		
		/**
		 * Get the children 
		 */
		public function getChildAt(index:Number, prefetch:Number) : Object
		{
			return _displayList.getItemAt(index, prefetch);
		}
		
		/**
		 * Provides an immutable array instance
		 */
		public function getChildren() : Array
		{
			return _displayList.toArray();
		}
		
		/**
		 * Pushes a scene onto the current display hiearchy
		 */
		public function pushScene(scene:Scene, effects:Array=null) : void
		{
			if ( _sceneList ) 
			{
				_sceneList.push(scene);
			}
		}
		
		// +---------------------------------------------------------------------
		// Dispatcher Implementation
		// +---------------------------------------------------------------------
		
		public function generateLayers(children:Array) : void
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
		
		// +---------------------------------------------------------------------
		// Other Get / Set
		// +---------------------------------------------------------------------
		
		/** Root flash view */
		public function get root() : Sprite { return _root;}
		/** Current context*/
		public function get current() :  Nxui { return _current;}
		
		
	}
}