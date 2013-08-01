/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ApplicationControlBar;
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.effects.CompositeEffect;
	import mx.effects.Effect;
	import mx.effects.effectClasses.CompositeEffectInstance;
	import mx.events.EffectEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ArrayUtil;
	
	import org.trueagile.amdi.containers.MDIApplication;
	import org.trueagile.amdi.containers.MDIApplicationBar;
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.containers.MDIWindowState;
	import org.trueagile.amdi.effects.IMDIEffectsDescriptor;
	import org.trueagile.amdi.effects.MDIEffectsDescriptorBase;
	import org.trueagile.amdi.effects.effectClasses.MDIGroupEffectItem;
	import org.trueagile.amdi.events.MDIManagerEvent;
	import org.trueagile.amdi.events.MDIWindowEvent;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when a window is added to the manager.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_ADD
	 */
	[Event(name="windowAdd", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_MINIMIZE
	 */
	[Event(name="windowMinimize", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  If the window is minimized, this event is dispatched when the titleBar is clicked. 
	 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
	 *  or double clicking the titleBar.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_RESTORE
	 */
	[Event(name="windowRestore", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the maximize button is clicked or when the window is in a
	 *  normal state (not minimized or maximized) and the titleBar is double clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_MAXIMIZE
	 */
	[Event(name="windowMaximize", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_CLOSE
	 */
	[Event(name="windowClose", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_FOCUS_START
	 */
	[Event(name="windowFocusStart", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_FOCUS_END
	 */
	[Event(name="windowFocusEnd", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the window begins being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_DRAG_START
	 */
	[Event(name="windowDragStart", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched while the window is being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_DRAG
	 */
	[Event(name="windowDrag", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the window stops being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_DRAG_END
	 */
	[Event(name="windowDragEnd", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when a resize handle is pressed.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_RESIZE_START
	 */
	[Event(name="windowResizeStart", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched while the mouse is down on a resize handle.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_RESIZE
	 */
	[Event(name="windowResize", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the mouse is released from a resize handle.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_RESIZE_END
	 */
	[Event(name="windowResizeEnd", type="org.trueagile.amdi.events.MDIManagerEvent")]

	/**
	 *  Dispatched while the window's menu is show.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_SHOW_MENU
	 */
	[Event(name="windowShowMenu", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the an item is selected from the window's menu.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.WINDOW_MENU_ITEM_CLICK
	 */
	[Event(name="windowMenuItemClick", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the app's menu is show.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.APP_SHOW_MENU
	 */
	[Event(name="appShowMenu", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the an item is selected from the app's menu.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.APP_MENU_ITEM_CLICK
	 */
	[Event(name="appMenuItemClick", type="org.trueagile.amdi.events.MDIManagerEvent")]	
	
	/**
	 *  Dispatched when the an item is selected from the app's menu.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.APP_BAR_ROLLOVER
	 */
	[Event(name="appBarRollOver", type="org.trueagile.amdi.events.MDIManagerEvent")]	
	
	/**
	 *  Dispatched when the an item is selected from the app's menu.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.APP_BAR_ROLLOUT
	 */
	[Event(name="appBarRollOut", type="org.trueagile.amdi.events.MDIManagerEvent")]	
	
	
	/**
	 *  Dispatched when the windows are cascaded.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.CASCADE
	 */
	[Event(name="cascade", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the windows are tiled.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.TILE
	 */
	[Event(name="tile", type="org.trueagile.amdi.events.MDIManagerEvent")]

	/**
	 *  Dispatched when the windows are all closed.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.CLOSE_ALL
	 */
	[Event(name="closeAll", type="org.trueagile.amdi.events.MDIManagerEvent")]
	
	/**
	 *  Dispatched when the windows are all minimized.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIManagerEvent.MINIMIZE_ALL
	 */
	[Event(name="minimizeAll", type="org.trueagile.amdi.events.MDIManagerEvent")]
	

	/**
	 * Class responsible for applying effects and default behaviors to MDIWindow instances such as
	 * tiling, cascading, minimizing, maximizing, etc.
	 */
	public class MDIManager extends EventDispatcher
	{
		
		private var isGlobal:Boolean = false;
		private var windowToManagerEventMap:Dictionary;

		private var tiledWindows:ArrayCollection;
		private var tileMinimize:Boolean = true;
		public var tileMinimizeWidth:int = 200;
		public var tilePadding:Number = 8;
		public var minTilePadding:Number = 5;
		public var enforceBoundaries:Boolean = true;
		
		public var mdiApplication : MDIApplication;
		
		public var effects:IMDIEffectsDescriptor = new MDIEffectsDescriptorBase();
		
		public static var CONTEXT_MENU_LABEL_TILE:String;
		public static var CONTEXT_MENU_LABEL_TILE_FILL:String;
		public static var CONTEXT_MENU_LABEL_CASCADE:String;
		public static var CONTEXT_MENU_LABEL_SHOW_ALL:String;
		
		/**
     	*   Contstructor()
     	*/    	
		public function MDIManager(application:MDIApplication, effects:IMDIEffectsDescriptor = null):void
		{
			CONTEXT_MENU_LABEL_TILE = MDIApplication.titleText;
			CONTEXT_MENU_LABEL_TILE_FILL = MDIApplication.titleFillText;
			CONTEXT_MENU_LABEL_CASCADE = MDIApplication.cascadeText;
			CONTEXT_MENU_LABEL_SHOW_ALL = MDIApplication.showAllText;

			this.container = application.container;
			this.mdiApplication = application;
			
			if(effects != null)
			{
				this.effects = effects;
			}
			if(tileMinimize)
			{
				tiledWindows = new ArrayCollection();
			}
			
			// map of window events to corresponding manager events
			windowToManagerEventMap = new Dictionary();
			windowToManagerEventMap[MDIWindowEvent.MINIMIZE] = MDIManagerEvent.WINDOW_MINIMIZE;
			windowToManagerEventMap[MDIWindowEvent.RESTORE] = MDIManagerEvent.WINDOW_RESTORE;
			windowToManagerEventMap[MDIWindowEvent.MAXIMIZE] = MDIManagerEvent.WINDOW_MAXIMIZE;
			windowToManagerEventMap[MDIWindowEvent.CLOSE] = MDIManagerEvent.WINDOW_CLOSE;
			windowToManagerEventMap[MDIWindowEvent.FOCUS_START] = MDIManagerEvent.WINDOW_FOCUS_START;
			windowToManagerEventMap[MDIWindowEvent.FOCUS_END] = MDIManagerEvent.WINDOW_FOCUS_END;
			windowToManagerEventMap[MDIWindowEvent.DRAG_START] = MDIManagerEvent.WINDOW_DRAG_START;
			windowToManagerEventMap[MDIWindowEvent.DRAG] = MDIManagerEvent.WINDOW_DRAG;
			windowToManagerEventMap[MDIWindowEvent.DRAG_END] = MDIManagerEvent.WINDOW_DRAG_END;
			windowToManagerEventMap[MDIWindowEvent.RESIZE_START] = MDIManagerEvent.WINDOW_RESIZE_START;
			windowToManagerEventMap[MDIWindowEvent.RESIZE] = MDIManagerEvent.WINDOW_RESIZE;
			windowToManagerEventMap[MDIWindowEvent.RESIZE_END] = MDIManagerEvent.WINDOW_RESIZE_END;
			windowToManagerEventMap[MDIWindowEvent.SHOW_MENU] = MDIManagerEvent.WINDOW_SHOW_MENU;
			windowToManagerEventMap[MDIWindowEvent.MENU_ITEM_CLICK] = MDIManagerEvent.WINDOW_MENU_ITEM_CLICK;

			// these handlers execute default behaviors, these events are dispatched by this class
			addEventListener(MDIManagerEvent.WINDOW_ADD, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_MINIMIZE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_RESTORE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_MAXIMIZE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_CLOSE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
	
			addEventListener(MDIManagerEvent.WINDOW_FOCUS_START, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_FOCUS_END, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_DRAG_START, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_DRAG, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_DRAG_END, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_RESIZE_START, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_RESIZE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_RESIZE_END, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			
			addEventListener(MDIManagerEvent.WINDOW_SHOW_MENU, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.WINDOW_MENU_ITEM_CLICK, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.APP_SHOW_MENU, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.APP_SHOW_MENU, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.APP_BAR_ROLLOVER, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.APP_BAR_ROLLOUT, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);			
			addEventListener(MDIManagerEvent.CASCADE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(MDIManagerEvent.TILE, executeDefaultBehavior, false, EventPriority.DEFAULT_HANDLER);
		}
		
		private var _container:Canvas;
		public function get container():Canvas
		{
			return _container;
		}
		public function set container(value:Canvas):void
		{
			this._container = value;
		}
		

		/**
     	*  @private
     	*  the managed window stack
     	*/
     	[Bindable]
		public var windowList:Array = new Array();

		public function add(window:MDIWindow, cascadePosition:Boolean=true):void
		{
			if(windowList.indexOf(window) < 0)
			{
				window.windowManager = this;
				
				this.addListeners(window);
				
				this.windowList.push(window);
				
				//this.addContextMenu(window);
				
				if(this.isGlobal)
				{
					PopUpManager.addPopUp(window,this.mdiApplication as DisplayObject);
					if (cascadePosition){
						this.position(window);	
					}
				}
				else
				{
					// to accomodate mxml impl
					if(window.parent == null)
					{
						this.container.addChild(window);
						if (cascadePosition){
							this.position(window);	
						}
					}
				} 		
				
				dispatchEvent(new MDIManagerEvent(MDIManagerEvent.WINDOW_ADD, window, this));
				bringToFront(window);
			}
		}
		
		/**
		 *  Positions a window on the screen 
		 *  
		 * 	<p>This is primarly used as the default space on the screen to position the window.</p>
		 * 
		 *  @param window:MDIWindow Window to position
		 */
		public function position(window:MDIWindow):void
		{	
			window.x = this.windowList.length * 30;
			window.y = this.windowList.length * 30;

			if((window.x + window.width) > container.width) window.x = 40;
			if((window.y + window.height) > container.height) window.y = 40; 	
		}
		
		private function windowEventProxy(event:Event):void
		{
			if(event is MDIWindowEvent && !event.isDefaultPrevented())
			{
				var winEvent:MDIWindowEvent = event as MDIWindowEvent;
				var mgrEvent:MDIManagerEvent = new MDIManagerEvent(windowToManagerEventMap[winEvent.type], winEvent.window,this);
				mgrEvent.item = winEvent.item;
				switch(winEvent.type)
				{
					case MDIWindowEvent.MINIMIZE:						
						mgrEvent.window.saveStyle();
						mgrEvent.window.deactivateClicks();
						var minimizePoint:Point = new Point(0, mgrEvent.window.y);
						mgrEvent.effect = this.effects.getWindowMinimizeEffect(mgrEvent.window, this, minimizePoint);
					break;
					
					case MDIWindowEvent.RESTORE:
						if (mgrEvent.window.isMinimized){
							this.mdiApplication.minimizedWindowsContainer.removeWindow(mgrEvent.window);
							this.container.addChild(mgrEvent.window);
							this.container.setChildIndex(mgrEvent.window,this.container.numChildren-1);
							mgrEvent.effect = this.effects.getWindowRestoreMinimizedEffect(winEvent.window, this, winEvent.window.savedWindowRect);
						}
						else{
							mgrEvent.effect = this.effects.getWindowRestoreEffect(winEvent.window, this, winEvent.window.savedWindowRect);
						}
						mgrEvent.window.restoreStyle();
						
					break;
					
					case MDIWindowEvent.MAXIMIZE:
						if (mgrEvent.window.isMinimized){
							this.mdiApplication.minimizedWindowsContainer.removeWindow(mgrEvent.window);
							this.container.addChild(mgrEvent.window);
							this.container.setChildIndex(mgrEvent.window,this.container.numChildren-1);
						}
						mgrEvent.window.restoreStyle();
						mgrEvent.effect = this.effects.getWindowMaximizeEffect(winEvent.window, this);
					break;
					
					case MDIWindowEvent.CLOSE:
						mgrEvent.effect = this.effects.getWindowCloseEffect(mgrEvent.window, this);
					break;
					
					case MDIWindowEvent.FOCUS_START:
						mgrEvent.effect = this.effects.getWindowFocusStartEffect(winEvent.window, this);
					break;
					
					case MDIWindowEvent.FOCUS_END:
						mgrEvent.effect = this.effects.getWindowFocusEndEffect(winEvent.window, this);
					break;
		
					case MDIWindowEvent.DRAG_START:
						mgrEvent.effect = this.effects.getWindowDragStartEffect(winEvent.window, this);
					break;
		
					case MDIWindowEvent.DRAG:
						mgrEvent.effect = this.effects.getWindowDragEffect(winEvent.window, this);
					break;
		
					case MDIWindowEvent.DRAG_END:
						mgrEvent.effect = this.effects.getWindowDragEndEffect(winEvent.window, this);
					break;
					
					case MDIWindowEvent.RESIZE_START:
						mgrEvent.effect = this.effects.getWindowResizeStartEffect(winEvent.window, this);
					break;
					
					case MDIWindowEvent.RESIZE:
						mgrEvent.effect = this.effects.getWindowResizeEffect(winEvent.window, this);
					break;
					
					case MDIWindowEvent.RESIZE_END:
						mgrEvent.effect = this.effects.getWindowResizeEndEffect(winEvent.window, this);
					break;
				}
				
				dispatchEvent(mgrEvent);
			}			
		}
		
		public function executeDefaultBehavior(event:Event):void
		{
			if(event is MDIManagerEvent && !event.isDefaultPrevented())
			{
				var mgrEvent:MDIManagerEvent = event as MDIManagerEvent;
				
				switch(mgrEvent.type)
				{					
					case MDIManagerEvent.WINDOW_ADD:
						// get the effect here because this doesn't pass thru windowEventProxy()
						mgrEvent.effect = this.effects.getWindowAddEffect(mgrEvent.window, this);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_MINIMIZE:						
						mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END, onMinimizeEffectEnd);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_RESTORE:
						removeTileInstance(mgrEvent.window);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_MAXIMIZE:
						removeTileInstance(mgrEvent.window);
						maximizeWindow(mgrEvent.window);
					break;
					
					case MDIManagerEvent.WINDOW_CLOSE:
						removeTileInstance(mgrEvent.window);
						mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END, onCloseEffectEnd);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_FOCUS_START:
						mgrEvent.window.hasFocus = true;
						mgrEvent.window.validateNow();
						if (!mgrEvent.window.isMinimized){
							container.setChildIndex(mgrEvent.window, this.container.numChildren-1);	
						}
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_FOCUS_END:
						mgrEvent.window.hasFocus = false;
						mgrEvent.window.validateNow();
						mgrEvent.effect.play();
					break;
		
					case MDIManagerEvent.WINDOW_DRAG_START:
						mgrEvent.effect.play();
					break;
		
					case MDIManagerEvent.WINDOW_DRAG:
						mgrEvent.effect.play();
					break;
		
					case MDIManagerEvent.WINDOW_DRAG_END:
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_RESIZE_START:
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_RESIZE:
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.WINDOW_RESIZE_END:
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.CASCADE:
						// get the effect here because this doesn't pass thru windowEventProxy()
						mgrEvent.effect = this.effects.getCascadeEffect(mgrEvent.effectItems, this);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.TILE:
						// get the effect here because this doesn't pass thru windowEventProxy()
						mgrEvent.effect = this.effects.getTileEffect(mgrEvent.effectItems, this);
						mgrEvent.effect.play();
					break;
					
					case MDIManagerEvent.APP_BAR_ROLLOUT:
					//do nothing
					break;
					
					case MDIManagerEvent.APP_BAR_ROLLOVER:
					//do nothing
					break;
				}
			}			
		}
		
		private function onMinimizeEffectEnd(event:EffectEvent):void
		{
			// if this was a composite effect (almost definitely is), we make sure a target was defined on it
			// since that is optional, we look in its first child if we don't find one
			var targetWindow:MDIWindow = event.effectInstance.target as MDIWindow;
			var movePoint:Point;
			
			if(targetWindow == null && event.effectInstance is CompositeEffectInstance)
			{
				var compEffect:CompositeEffect = event.effectInstance.effect as CompositeEffect;
				targetWindow = Effect(compEffect.children[0]).target as MDIWindow;
			}
			tiledWindows.addItem(targetWindow);
			
			if (mdiApplication.barPossition==MDIApplication.TOP_POSITON){
				movePoint= new Point(0, -targetWindow.titleBarOverlay.height*2);	
			}
			else if (mdiApplication.barPossition==MDIApplication.BOTTON_POSITON){
				movePoint= new Point(0, this.container.height+targetWindow.titleBarOverlay.height);
			}
			else{
				movePoint= new Point(0, -targetWindow.titleBarOverlay.height*2);
			}
			
			var effect:Effect =  this.effects.reTileMinWindowsEffect(targetWindow, this, movePoint);
			effect.addEventListener(EffectEvent.EFFECT_END,addToMinimizedContainer);
			effect.play();		
		}
		
		private function onCloseEffectEnd(event:EffectEvent):void
		{
			remove(event.effectInstance.target as MDIWindow);
		}	
		
		private function addToMinimizedContainer(event:EffectEvent):void{
			this.mdiApplication.minimizedWindowsContainer.addWindow((MDIWindow(event.effectInstance.target)));
			this.windowEventProxy(new MDIWindowEvent(MDIWindowEvent.FOCUS_END,(MDIWindow(event.effectInstance.target))));
			MDIWindow(event.effectInstance.target).activateClicks();
		}
		
		/**
		 * Maximizing of Window
		 * 
		 * @param window MDIWindowinstance to maximize
		 * 
		 **/
		private function maximizeWindow(window:MDIWindow):void
		{
			var maxTiles:int = this.container.width / (this.tileMinimizeWidth + this.minTilePadding);
			this.effects.getWindowMaximizeEffect(window, this).play();

		}
		

		
		/**
		 * Removes the closed window from the ArrayCollection of tiled windows
		 * 
		 *  @param event MDIWindowEvent instance containing even type and window instance that is being handled
		 * 
		 * */
		private function removeTileInstance(window:MDIWindow):void
		{
			for(var i:int = 0; i < tiledWindows.length; i++)
			{
				if(tiledWindows.getItemAt(i) == window)
				{
					this.tiledWindows.removeItemAt(i);
				}
			}
		}


		
		public function addCenter(window:MDIWindow):void
		{
			this.add(window);
			this.center(window);
		}
		
		
		/**
		 * Brings a window to the front of the screen. 
		 * 
		 *  @param win Window to bring to front
		 * */
		public function bringToFront(window:MDIWindow):void
		{
			if(this.isGlobal)
			{
				PopUpManager.bringToFront(window as IFlexDisplayObject);
			}
			else
			{				
				for each(var win:MDIWindow in windowList)
				{
					if(win != window && win.hasFocus)
					{
						win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_END, win));
					}
					if(win == window && !window.hasFocus)
					{
						win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_START, win));
					}
				}
			}
			
		}
		
		
		/**
		 * Positions a window in the center of the available screen. 
		 * 
		 *  @param window:MDIWindow to center
		 * */
		public function center(window:MDIWindow):void
		{
			window.x = this.container.width / 2 - window.width/2;
			window.y = this.container.height / 2 - window.height/2;
		}
		
		/**
		 * Removes all windows from managed window stack; 
		 * */
		public function removeAll():void
		{	
		
			for each(var window:MDIWindow in windowList)
			{
				if(this.isGlobal)
				{
					PopUpManager.removePopUp(window as IFlexDisplayObject);
				}
				else
				{
					container.removeChild(window);
				}
				
				this.removeListeners(window);
			}
			
			this.windowList = new Array();
		}
		
		/**
		 *  @private
		 * 
		 *  Adds listeners 
		 *  @param window:MDIWindow  
		 */
		
		private function addListeners(window:MDIWindow):void
		{
			window.addEventListener(MDIWindowEvent.MINIMIZE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.RESTORE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.MAXIMIZE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.CLOSE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			
			window.addEventListener(MDIWindowEvent.FOCUS_START, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.FOCUS_END, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.DRAG_START, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.DRAG, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.DRAG_END, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.RESIZE_START, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.RESIZE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.RESIZE_END, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.SHOW_MENU, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			window.addEventListener(MDIWindowEvent.MENU_ITEM_CLICK, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
			
		}


		/**
		 *  @private
		 * 
		 *  Removes listeners 
		 *  @param window:MDIWindow 
		 */
		private function removeListeners(window:MDIWindow):void
		{
			window.removeEventListener(MDIWindowEvent.MINIMIZE, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.RESTORE, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.MAXIMIZE, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.CLOSE, windowEventProxy);
			
			window.removeEventListener(MDIWindowEvent.FOCUS_START, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.FOCUS_END, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.DRAG_START, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.DRAG, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.DRAG_END, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.RESIZE_START, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.RESIZE, windowEventProxy);	
			window.removeEventListener(MDIWindowEvent.RESIZE_END, windowEventProxy);
			window.removeEventListener(MDIWindowEvent.SHOW_MENU, windowEventProxy);	
			window.removeEventListener(MDIWindowEvent.MENU_ITEM_CLICK, windowEventProxy);			
		}
		

		/**
		 *  Removes a window instance from the managed window stack 
		 *  @param window:MDIWindow Window to remove 
		 */
		public function remove(window:MDIWindow):void
		{	
			
			var index:int = ArrayUtil.getItemIndex(window, this.windowList);
			
			windowList.splice(index, 1);
			
			if(this.isGlobal)
			{
				PopUpManager.removePopUp(window as IFlexDisplayObject);
			}
			else
			{
				if (window.isMinimized){
					this.mdiApplication.minimizedWindowsContainer.removeWindow(window);	
				}
				else{
					container.removeChild(window);	
				}
			}
			
			removeListeners(window);
			
			// set focus to newly-highest depth window
			for(var i:int = container.numChildren - 1; i > -1; i--)
			{
				var dObj:DisplayObject = container.getChildAt(i);
				if(dObj is MDIWindow)
				{
					bringToFront(MDIWindow(dObj));
					return;
				}
			}
		}				
		
		/**
		 * Pushes a window onto the managed window stack 
		 * 
		 *  @param win Window:MDIWindow to push onto managed windows stack 
		 * */
		public function manage(window:MDIWindow):void
		{	
			if(window != null)
				windowList.push(window);
		}
		
		/**
		 *  Positions a window in an absolute position 
		 * 
		 *  @param win:MDIWindow Window to position
		 * 
		 *  @param x:int The x position of the window
		 * 
		 *  @param y:int The y position of the window 
		 */
		public function absPos(window:MDIWindow,x:int,y:int):void
		{
			window.x = x;
			window.y = y;		
		}
		
		/**
		 * Gets a list of open windows for scenarios when only open windows need to be managed
		 * 
		 * @return Array
		 */
		public function getOpenWindowList():Array
		{	
			var array:Array = [];
			for(var i:int = 0; i < windowList.length; i++)
			{
				if(!MDIWindow(windowList[i]).minimized)
				{
					array.push(windowList[i]);
				}
			}
			return array;
		}
		
		public function getTiledWindows():Array {
			var array:Array = new Array();
			return array.concat(this.tiledWindows.source); 
		}
		
		/**
		 *  Tiles the window across the screen
		 *  
		 *  <p>By default, windows will be tiled to all the same size and use only the space they can accomodate.
		 *  If you set fillAvailableSpace = true, tile will use all the space available to tile the windows with
		 *  the windows being arranged by varying heights and widths. 
     	 *  </p>
		 * 
		 *  @param fillAvailableSpace:Boolean Variable to determine whether to use the fill the entire available screen
		 * 
		 */
		public function tile(fillAvailableSpace:Boolean = false,gap:Number = 0):void
		{			
			var openWinList:Array = getOpenWindowList();
				
			var numWindows:int = openWinList.length;
			
			if(numWindows == 1)
			{
				MDIWindow(openWinList[0]).maximizeRestore();
			}
			else if(numWindows > 1)
			{
				var sqrt:int = Math.round(Math.sqrt(numWindows));
				var numCols:int = Math.ceil(numWindows / sqrt);
				var numRows:int = Math.ceil(numWindows / numCols);
				var col:int = 0;
				var row:int = 0;
				var availWidth:Number = this.container.width;
				var availHeight:Number = this.container.height
				var maxTiles:int = this.container.width / (this.tileMinimizeWidth + this.minTilePadding);
				var targetWidth:Number = availWidth / numCols - ((gap * (numCols - 1)) / numCols);
				var targetHeight:Number = availHeight / numRows - ((gap * (numRows - 1)) / numRows);
				
				var effectItems:Array = [];
					
				for(var i:int = 0; i < openWinList.length; i++)
				{
					
					var win:MDIWindow = openWinList[i];
					
					bringToFront(win)
					
					var item:MDIGroupEffectItem = new MDIGroupEffectItem(win);
					
					item.widthTo = targetWidth;
					item.heightTo = targetHeight;

					if(i % numCols == 0 && i > 0)
					{
						row++;
						col = 0;
					}
					else if(i > 0)
					{
						col++;
					}
	
					item.moveTo = new Point((col * targetWidth), (row * targetHeight)); 
			
					//pushing out by gap
					if(col > 0) 
						item.moveTo.x += gap * col;
					
					if(row > 0) 
						item.moveTo.y += gap * row;
	
					effectItems.push(item);
	
				}
				
	
				if(col < numCols && fillAvailableSpace)
				{
					var numOrphans:int = numWindows % numCols;
					var orphanWidth:Number = availWidth / numOrphans - ((gap * (numOrphans - 1)) / numOrphans);
					//var orphanWidth:Number = availWidth / numOrphans;
					var orphanCount:int = 0
					for(var j:int = numWindows - numOrphans; j < numWindows; j++)
					{
						//var orphan:MDIWindow = openWinList[j];
						var orphan:MDIGroupEffectItem = effectItems[j];
						
						orphan.widthTo = orphanWidth;
						//orphan.window.width = orphanWidth;
						
						orphan.moveTo.x = (j - (numWindows - numOrphans)) * orphanWidth;
						if(orphanCount > 0) 
							orphan.moveTo.x += gap * orphanCount;
						orphanCount++;
					}
				} 
				
				dispatchEvent(new MDIManagerEvent(MDIManagerEvent.TILE, null, this, null, effectItems));
			}
		}
		

		public function resize(window:MDIWindow):void
		{		
			var w:int = this.container.width * .6;
			var h:int = this.container.height * .6
			if(w > window.width)
				window.width = w;
			if(h > window.height)
				window.height=h;
		}
		
		
		
		/**
		 *  Cascades all managed windows from top left to bottom right 
		 * 
		 */	
		public function cascade():void
		{
			var effectItems:Array = [];
			
			var windows:Array = getOpenWindowList();
			var xIndex:int = 0;
			var yIndex:int = -1;
			
			for(var i:int = 0; i < windows.length; i++)
			{
				var window:MDIWindow = windows[i] as MDIWindow;
				
				bringToFront(window);
				
				var item:MDIGroupEffectItem = new MDIGroupEffectItem(window);
				item.widthFrom = window.width;
				item.widthTo = container.width * .5;
				item.heightFrom = window.height;
				item.heightTo = container.height * .5;
				
				if(yIndex * 40 + item.heightTo + 25 >= container.height)
				{
					yIndex = 0;
					xIndex++;
				}
				else
				{
					yIndex++;
				}
				
				var destX:int = xIndex * 40 + yIndex * 20;
				var destY:int = yIndex * 40;
				item.moveTo = new Point(destX, destY);
					
				effectItems.push(item);
			}
			
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.CASCADE, null, this, null, effectItems));
		}
		
		/**
		 *  Show all windows 
		 * 
		 */			
		public function showAllWindows():void
		{
			// this prevents retiling of windows yet to be unMinimized()
			tiledWindows.removeAll();			
			
			for each(var window:MDIWindow in windowList)
			{
				if(window.minimized)
				{
					window.unMinimize();
				}
			}
		}
		/**
		*  Close window with focus and stop
		* 
		*/	
		public function closeOpen():void{
			for each(var window:MDIWindow in windowList){
				if (window.hasFocus){
					window.close();
					break;
				}
			}
		}
		
		/**
		 * Close all the windows. 
		 * 
		 */
		public function closeAll():void{
			for each(var window:MDIWindow in windowList){
				window.close();
			}
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.CLOSE_ALL,null,this));
		}
		
		/**
		*  Returns the window that has the current focus
		* 
		*/			
		public function getFocusWindow():MDIWindow{
			for each(var window:MDIWindow in windowList){
				if (window.hasFocus){
					return window;
				}
			}
			return null;
		}
		
		/**
		 * Hide all the menues in all the windows. 
		 * 
		 */
		public function hideAllMenus():void{
			for each(var window:MDIWindow in windowList){
				if (window.menuBtn){
					window.menuBtn.hideMenu();	
				}
			}			
		}

		/**
		 * Minimize all the windows. 
		 * 
		 */
		public function minimizeAll():void{
			var minimizeArray : Array = new Array();

			for each(var window:MDIWindow in windowList){
				if (window.publicState != MDIWindowState.MINIMIZED){
					minimizeArray.push(window);
				}
			}
			
			this.mdiApplication.minimizedWindowsContainer.minimizeAll(minimizeArray);
			for each (var windowToMinimize:MDIWindow in minimizeArray){
				windowToMinimize.minimize();
			}

			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.MINIMIZE_ALL,null,this));		
		}
		
		public function addApplicationBarListeners(appBar:ApplicationControlBar):void{
			appBar.addEventListener(MouseEvent.ROLL_OVER,appBarRollOverListener);
			appBar.addEventListener(MouseEvent.ROLL_OUT,appBarRollOutListener);
		}
		
		private function appBarRollOverListener(event:MouseEvent):void{
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.APP_BAR_ROLLOVER,null,this,null,null,false,null,event.target as MDIApplicationBar));
		}
		
		private function appBarRollOutListener(event:MouseEvent):void{
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.APP_BAR_ROLLOUT,null,this,null,null,false,null,event.target as MDIApplicationBar));
		}
		
		public function appMenuShowListener(event:MenuEvent):void{
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.APP_SHOW_MENU,null,this,null,null,false,event.item));
		}
		
		public function appMenuItemClickListener(event:MenuEvent):void{
			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.APP_MENU_ITEM_CLICK,null,this,null,null,false,event.item));
		}
		
		public function get windowInContainer():Array{
			var _windowInContainer:Array = new Array();
			for each (var window:MDIWindow in this.windowList){
				if (!window.isMinimized){
					_windowInContainer.push(window);
				}
			}
			return _windowInContainer;
		}
			
	}
}