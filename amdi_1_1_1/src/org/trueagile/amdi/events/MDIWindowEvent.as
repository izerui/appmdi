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
	import org.trueagile.amdi.containers.MDIWindow;
	
	import flash.events.Event;
	
	/**
	 * Event type dispatched by MDIWindow. Events will also be rebroadcast (as MDIManagerEvents)
	 * by the window's manager, if one is present.
	 */
	public class MDIWindowEvent extends Event
	{
		public static const MINIMIZE:String = "minimize";
		public static const RESTORE:String = "restore";
		public static const MAXIMIZE:String = "maximize";
		public static const CLOSE:String = "close";
		
		public static const FOCUS_START:String = "focusStart";
		public static const FOCUS_END:String = "focusEnd";
		public static const DRAG_START:String = "dragStart";
		public static const DRAG:String = "drag";
		public static const DRAG_END:String = "dragEnd";
		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZE:String = "resize";
		public static const RESIZE_END:String = "resizeEnd";
		
		public static const SHOW_MENU:String = "showMenu";
		public static const MENU_ITEM_CLICK:String = "menuItemClick";
		
		public var window:MDIWindow;
		public var item:Object;
		
		public function MDIWindowEvent(type:String, window:MDIWindow, bubbles:Boolean = false, item:Object=null)
		{
			super(type, bubbles, true);
			this.window = window;
			this.item = item;
		}
		
		override public function clone():Event
		{
			return new MDIWindowEvent(type, window, bubbles, item);
		}
	}
}