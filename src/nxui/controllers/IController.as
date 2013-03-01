package nxui.controllers
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	public interface IController extends IEventDispatcher
	{
		function deviceInput(evt:Event) : void;
	}
}