package nxui.support 
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 */
	public interface IEngineSupport extends IEventDispatcher
	{
		
		function initializeStage3D(root:Sprite) : Stage3D;
		function clearScreenBuffer() : void;
		function presentScreenBuffer() : void;
		function createAnimationLayer() : Object;
		function createLoadingLayer() : Object;
		function isStageContextReady() : Boolean;
		function renderAnimationLayer() : void;
		function renderLoadingLayer() : void;
	}
	
}