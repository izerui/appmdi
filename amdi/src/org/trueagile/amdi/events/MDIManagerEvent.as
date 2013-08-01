/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.events
{
	import flash.events.Event;
	
	import mx.effects.Effect;
	
	import org.trueagile.amdi.containers.MDIApplicationBar;
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.managers.MDIManager;
	
	/**
	 * Event type dispatched by MDIManager. Majority of events based on/relayed from managed windows.
	 */
	public class MDIManagerEvent extends Event
	{
		public static const WINDOW_ADD:String = "windowAdd";
		public static const WINDOW_MINIMIZE:String = "windowMinimize";
		public static const WINDOW_RESTORE:String = "windowRestore";
		public static const WINDOW_MAXIMIZE:String = "windowMaximize";
		public static const WINDOW_CLOSE:String = "windowClose";
		
		public static const WINDOW_FOCUS_START:String = "windowFocusStart";
		public static const WINDOW_FOCUS_END:String = "windowFocusEnd";
		public static const WINDOW_DRAG_START:String = "windowDragStart";
		public static const WINDOW_DRAG:String = "windowDrag";
		public static const WINDOW_DRAG_END:String = "windowDragEnd";
		public static const WINDOW_RESIZE_START:String = "windowResizeStart";
		public static const WINDOW_RESIZE:String = "windowResize";
		public static const WINDOW_RESIZE_END:String = "windowResizeEnd";
		public static const WINDOW_SHOW_MENU:String = "windowShowMenu";
		public static const WINDOW_MENU_ITEM_CLICK:String = "windowMenuItemClick";
		
		public static const APP_SHOW_MENU:String = "appShowMenu";
		public static const APP_MENU_ITEM_CLICK:String = "appMenuItemClick";

		public static const APP_BAR_ROLLOVER:String = "appBarRollOver";
		public static const APP_BAR_ROLLOUT:String = "appBarRollOut";

		public static const CASCADE:String = "cascade";
		public static const TILE:String = "tile";
		public static const CLOSE_ALL:String = "closeAll";
		public static const MINIMIZE_ALL:String = "minimizeAll";
		
		public var window:MDIWindow;
		public var manager:MDIManager;
		public var effect:Effect;
		public var effectItems:Array;
		public var item:Object;
		public var appBar:MDIApplicationBar;
		
		public function MDIManagerEvent(type:String, window:MDIWindow, manager:MDIManager, effect:Effect = null, effectItems:Array = null, bubbles:Boolean = false, item:Object = null, appBar:MDIApplicationBar=null)
		{
			super(type, bubbles, true);
			this.window = window;
			this.manager = manager;
			this.effect = effect;
			this.effectItems = effectItems;
			this.item = item;
			this.appBar = appBar;
		}
		
		override public function clone():Event
		{
			return new MDIManagerEvent(type, window, manager, effect, effectItems, bubbles, item, appBar);
		}
	}
}