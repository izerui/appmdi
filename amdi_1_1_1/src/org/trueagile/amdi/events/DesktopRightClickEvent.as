package org.trueagile.amdi.events
{
	import flash.events.Event;
	
	public class DesktopRightClickEvent extends Event
	{
		/**
		 * 右键点击的名称
		 */
		public var label:String ;
		
		public static const DESKTOP_RIGHTCLICK_EVENT:String = "desktopRightClickEvent";
		
		public function DesktopRightClickEvent(type:String,label:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.label = label;
		}
	}
}