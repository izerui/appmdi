/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.containers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.BitmapAsset;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.trueagile.amdi.events.MDIWindowEvent;
	import org.trueagile.amdi.managers.MDIManager;

	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.MINIMIZE
	 */
	[Event(name="minimize", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  If the window is minimized, this event is dispatched when the titleBar is clicked. 
	 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
	 *  or double clicking the titleBar.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.RESTORE
	 */
	[Event(name="restore", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the maximize button is clicked or when the window is in a
	 *  normal state (not minimized or maximized) and the titleBar is double clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.MAXIMIZE
	 */
	[Event(name="maximize", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the close button is clicked.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.CLOSE
	 */
	[Event(name="close", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.FOCUS_START
	 */
	[Event(name="focusStart", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.FOCUS_END
	 */
	[Event(name="focusEnd", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window starts being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.DRAG_START
	 */
	[Event(name="dragStart", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the window is being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.DRAG
	 */
	[Event(name="drag", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window stops being dragged.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.DRAG_END
	 */
	[Event(name="dragEnd", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when a resize handle is pressed.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.RESIZE_START
	 */
	[Event(name="resizeStart", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the mouse is down on a resize handle.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.RESIZE
	 */
	[Event(name="resize", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the mouse is released from a resize handle.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.RESIZE_END
	 */
	[Event(name="resizeEnd", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window menu is showed.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.SHOW_MENU
	 */
	[Event(name="showMenu", type="org.trueagile.amdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the an item is selected from the window menu.
	 *
	 *  @eventType org.trueagile.amdi.events.MDIWindowEvent.MENU_ITEM_CLICK
	 */
	[Event(name="menuItemClick", type="org.trueagile.amdi.events.MDIWindowEvent")]	
	
	//--------------------------------------
	//  Skins + Styles
	//--------------------------------------
	
	/**
	 *  Style declaration name for the window when it has focus.
	 *
	 *  @default "mdiWindowFocus"
	 */
	[Style(name="styleNameFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window when it does not have focus.
	 *
	 *  @default "mdiWindowNoFocus"
	 */
	[Style(name="styleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the text in the title bar
	 * 	when the window is in focus. If <code>titleStyleName</code> (inherited from Panel)
	 *  is set, titleStyleNameFocus will be overridden by it.
	 *
	 *  @default "mdiWindowTitleStyle"
	 */
	[Style(name="titleStyleNameFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the text in the title bar
	 * 	when the window is not in focus. If <code>titleStyleName</code> (inherited from Panel)
	 *  is set, <code>titleStyleNameNoFocus</code> will be overridden by it.
	 *  If <code>titleStyleNameNoFocus</code> is not set but <code>titleStyleNameFocus</code>
	 *  is, <code>titleStyleNameFocus</code> will be used, regardless of the window's focus state.
	 */
	[Style(name="titleStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Reference to class that will contain window control buttons like
	 *  minimize, close, etc. Changes to this style will be detected and will
	 *  initiate the instantiation and addition of a new class instance.
	 *
	 *  @default org.trueagile.amdi.containers.MDIWindowControlsContainer
	 */
	[Style(name="windowControlsClass", type="Class", inherit="no")]
	
	/**
	 *  Style declaration name for the window's minimize button.
	 *  If <code>minimizeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>minimizeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "org.trueagile.amdi"
	 */
	[Style(name="minimizeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's minimize button when window does not have focus.
	 *  See <code>minimizeBtnStyleName</code> documentation for details.
	 */
	[Style(name="minimizeBtnStyleNameNoFocus", type="String", inherit="no")]

	/**
	 *  Style declaration name for the window's minimize button.
	 *  If <code>menuBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>menuBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowMinimizeBtn"
	 */
	[Style(name="menuBtnStyleName", type="String", inherit="no")]

	/**
	 *  Style declaration name for the window's menu.
	 *  @default "mdiMenu"
	 */
	[Style(name="menuStyleName", type="String", inherit="no")]

	/**
	 *  Style declaration name for the window's menu.
	 *  @default "mdiWindowImage"
	 */
	[Style(name="windowImageStyleName", type="String", inherit="no")]
	
	
	/**
	 *  Style declaration name for the window's minimize button when window does not have focus.
	 *  See <code>menuBtnStyleName</code> documentation for details.
	 */
	[Style(name="menuBtnStyleNameNoFocus", type="String", inherit="no")]

	/**
	 *  Style declaration name for the window's maximize button.
	 *  If <code>maximizeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>maximizeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowMaximizeBtn"
	 */
	[Style(name="maximizeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's maximize button when window does not have focus.
	 *  See <code>maximizeBtnStyleName</code> documentation for details.
	 */
	[Style(name="maximizeBtnStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's restore button.
	 *  If <code>restoreBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>restoreBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowRestoreBtn"
	 */
	[Style(name="restoreBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's restore button when window does not have focus.
	 *  See <code>restoreBtnStyleName</code> documentation for details.
	 */
	[Style(name="restoreBtnStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's close button.
	 *  If <code>closeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>closeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowCloseBtn"
	 */
	[Style(name="closeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's close button when window does not have focus.
	 *  See <code>closeBtnStyleName</code> documentation for details.
	 */
	[Style(name="closeBtnStyleNameNoFocus", type="String", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing the window horizontally.
	 */
	[Style(name="resizeCursorHorizontalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing the window vertically.
	 */
	[Style(name="resizeCursorVerticalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top left or bottom right corner.
	 */
	[Style(name="resizeCursorTopLeftBottomRightSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top right or bottom left corner.
	 */
	[Style(name="resizeCursorTopRightBottomLeftSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftYOffset", type="Number", inherit="no")]
	
	
	/**
	 * Central window class used in org.trueagile.amdi. Includes min/max/close buttons by default.
	 */
	public class MDIWindow extends Panel
	{		
		/**
	     * Size of edge handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
	    public var edgeHandleSize:Number = 4;
	    
	    /**
	     * Size of corner handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
		public var cornerHandleSize:Number = 10;
	    
	    /**
	     * @private
	     * Internal storage for windowState property.
	     */
		private var _windowState:int;
		
		public var publicState:int;		
		
		/**
	     * @private
	     * Internal storage of previous state, used in min/max/restore logic.
	     */
		private var _prevWindowState:int;
		
		/**
		 * @private
		 * Internal storage of style name to be applied when window is in focus.
		 */
		private var _styleNameFocus:String;
		
		/**
		 * @private
		 * Internal storage of style name to be applied when window is out of focus.
		 */
		private var _styleNameNoFocus:String;
		
		/**
	     * Parent of window controls (min, restore/max and close buttons).
	     */
		private var _windowControls:MDIWindowControlsContainer;
		
		/**
		 * @private
		 * Flag to determine whether or not close button is visible.
		 */
		private var _showCloseButton:Boolean = true;
		
		/**
		 * Height of window when minimized.
		 */
		private var _minimizeHeight:Number;
		
		/**
		 * Flag determining whether or not this window is resizable.
		 * 是否允许改变窗口大小
		 */
		public var resizable:Boolean = true;
		
		/**
		 * Flag determining whether or not this window is draggable.
		 */
		public var draggable:Boolean = true;
		
		/**
	     * @private
	     * Resize handle for top edge of window.
	     */
		private var resizeHandleTop:Button;
		
		/**
	     * @private
	     * Resize handle for right edge of window.
	     */
		private var resizeHandleRight:Button;
		
		/**
	     * @private
	     * Resize handle for bottom edge of window.
	     */
		private var resizeHandleBottom:Button;
		
		/**
	     * @private
	     * Resize handle for left edge of window.
	     */
		private var resizeHandleLeft:Button;
		
		/**
	     * @private
	     * Resize handle for top left corner of window.
	     */
		private var resizeHandleTL:Button;
		
		/**
	     * @private
	     * Resize handle for top right corner of window.
	     */
		private var resizeHandleTR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom right corner of window.
	     */
		private var resizeHandleBR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom left corner of window.
	     */
		private var resizeHandleBL:Button;		
		
		/**
		 * Resize handle currently in use.
		 */
		private var currentResizeHandle:Button;
		
		/**
	     * Rectangle to represent window's size and position when resize begins
	     * or window's size/position is saved.
	     */
		public var savedWindowRect:Rectangle;
		
		/**
		 * @private
		 * Flag used to intelligently dispatch resize related events
		 */
		private var _resizing:Boolean;
		
		/**
		 * Invisible shape laid over titlebar to prevent funkiness from clicking in title textfield.
		 * Making it public gives child components like controls container access to size of titleBar.
		 */
		public var titleBarOverlay:Canvas;
		
		/**
		 * @private
		 * Flag used to intelligently dispatch drag related events
		 */
		private var _dragging:Boolean;
		
		/**
		 * @private
	     * Mouse's x position when resize begins.
	     */
		private var dragStartMouseX:Number;
		
		/**
		 * @private
	     * Mouse's y position when resize begins.
	     */
		private var dragStartMouseY:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minWidth.
	     */
		private var dragMaxX:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minHeight.
	     */
		private var dragMaxY:Number;
		
		/**
		 * @private
	     * Amount the mouse's x position has changed during current resizing.
	     */
		private var dragAmountX:Number;
		
		/**
		 * @private
	     * Amount the mouse's y position has changed during current resizing.
	     */
		private var dragAmountY:Number;
		
		
		/**
		 * Window's context menu.
		 */
		public var winContextMenu:ContextMenu = null;
		
		/**
		 * Reference to MDIManager instance this window is managed by, if any.
	     */
		public var windowManager:MDIManager;
		
		/**
		 * @private
		 * Storage var to hold value originally assigned to styleName since it gets toggled per focus change.
		 */
		private var _windowStyleName:Object;
		
		/**
		 * @private
		 * Storage var for hasFocus property.
		 */
		private var _hasFocus:Boolean;
		
		/**
		 * @private store the backgroundAlpha when minimized.
	     */
		private var backgroundAlphaRestore:Number = 0.5;
		
		public var menuBtn:MDIWindowMenuButton;
		
		
		private var _dataProvider:Object;
		
		// assets for default buttons
		[Embed(source="/org/trueagile/amdi/assets/img/minimizeButton.png")]
		private static var DEFAULT_MINIMIZE_BUTTON:Class;
		
		[Embed(source="/org/trueagile/amdi/assets/img/maximizeButton.png")]
		private static var DEFAULT_MAXIMIZE_BUTTON:Class;
		
		[Embed(source="/org/trueagile/amdi/assets/img/restoreButton.png")]
		private static var DEFAULT_RESTORE_BUTTON:Class;
		
		[Embed(source="/org/trueagile/amdi/assets/img/closeButton.png")]
		private static var DEFAULT_CLOSE_BUTTON:Class;
		
		[Embed(source="/org/trueagile/amdi/assets/img/windowMenuButton.png")]
		private static var DEFAULT_ICON:Class;		
	
		[Embed(source="/org/trueagile/amdi/assets/img/resizeCursorH.gif")]
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL:Class;
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET:Number = -10;
		
		[Embed(source="/org/trueagile/amdi/assets/img/resizeCursorV.gif")]
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL:Class;
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET:Number = -10;
		
		[Embed(source="/org/trueagile/amdi/assets/img/resizeCursorTLBR.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TL_BR:Class;
		private static var DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET:Number = -10;
		
		[Embed(source="/org/trueagile/amdi/assets/img/resizeCursorTRBL.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TR_BL:Class;
		private static var DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET:Number = -10;
		
		private static var classConstructed:Boolean = classConstruct();
		
		public static const minSize : Number = 150;
		
		public var isMinimized : Boolean = false;

		public var minWindow:Panel;
		
		public var bitmapDataBefore:BitmapData;
		
		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean
		{
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIWindow");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all windows that don't have an override for these styles.
			selector.defaultFactory = function():void
			{
				this.styleNameFocus = "mdiWindowFocus";
				this.styleNameNoFocus = "mdiWindowNoFocus";
				this.titleStyleName = "mdiWindowTitleStyle";
				this.minimizeBtnStyleName = "mdiWindowMinimizeBtn";
				this.maximizeBtnStyleName = "mdiWindowMaximizeBtn";
				this.restoreBtnStyleName = "mdiWindowRestoreBtn";				
				this.closeBtnStyleName = "mdiWindowCloseBtn";
				this.menuBtnStyleName = "mdiWindowMenuBtn";
				this.menuStyleName = "mdiWindowMenu";
				this.windowImageStyleName = "mdiWindowImage";
				
				this.windowControlsClass = MDIWindowControlsContainer;
				
				this.resizeCursorHorizontalSkin = DEFAULT_RESIZE_CURSOR_HORIZONTAL;
				this.resizeCursorHorizontalXOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET;
				this.resizeCursorHorizontalYOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET;
				
				this.resizeCursorVerticalSkin = DEFAULT_RESIZE_CURSOR_VERTICAL;
				this.resizeCursorVerticalXOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET;
				this.resizeCursorVerticalYOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET;
				
				this.resizeCursorTopLeftBottomRightSkin = DEFAULT_RESIZE_CURSOR_TL_BR;
				this.resizeCursorTopLeftBottomRightXOffset = DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET;
				this.resizeCursorTopLeftBottomRightYOffset = DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET;
				
				this.resizeCursorTopRightBottomLeftSkin = DEFAULT_RESIZE_CURSOR_TR_BL;
				this.resizeCursorTopRightBottomLeftXOffset = DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET;
				this.resizeCursorTopRightBottomLeftYOffset = DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET;
			}
			
			//------------------------
		    //  focus style
		    //------------------------
			var styleNameFocus:String = selector.getStyle("styleNameFocus");
			var winFocusSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + styleNameFocus);
			if(!winFocusSelector)
			{
				winFocusSelector = new CSSStyleDeclaration();
			}
			winFocusSelector.defaultFactory = function():void
			{
				this.headerHeight = 26;
				this.roundedBottomCorners = true;
				this.borderColor = 0x000000;
				this.borderThicknessTop = 0;
				this.borderThicknessRight = 4;
				this.borderThicknessBottom = 4;
				this.borderThicknessLeft = 4;
				this.borderAlpha = 0.7;
				this.backgroundAlpha = 1;
			}
			StyleManager.setStyleDeclaration("." + styleNameFocus, winFocusSelector, false);
			
			//------------------------
		    //  no focus style
		    //------------------------
			var styleNameNoFocus:String = selector.getStyle("styleNameNoFocus");
			var winNoFocusSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + styleNameNoFocus);
			if(!winNoFocusSelector)
			{
				winNoFocusSelector = new CSSStyleDeclaration();
			}
			winNoFocusSelector.defaultFactory = function():void
			{
				this.headerHeight = 26;
				this.roundedBottomCorners = true;
				this.borderColor = 0x000000;
				this.borderThicknessTop = 0;
				this.borderThicknessRight = 4;
				this.borderThicknessBottom = 4;
				this.borderThicknessLeft = 4;
				this.borderAlpha = 0.4;
				this.backgroundAlpha = .8;
			}					
			StyleManager.setStyleDeclaration("." + styleNameNoFocus, winNoFocusSelector, false);
			
			//------------------------
		    //  title style
		    //------------------------
			var titleStyleName:String = selector.getStyle("titleStyleName");
			var winTitleSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + titleStyleName);
			if(!winTitleSelector)
			{
				winTitleSelector = new CSSStyleDeclaration();
			}
			winTitleSelector.defaultFactory = function():void
			{
				this.fontFamily = "Arial";
				this.fontSize = 11;
				this.fontWeight = "bold";
				this.color = 0xFAF7F7;
			}
			StyleManager.setStyleDeclaration("." + titleStyleName, winTitleSelector, false);
		
			//------------------------
		    //  menu button
		    //------------------------
			var menuBtnStyleName:String = selector.getStyle("menuBtnStyleName");
			var menuBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + menuBtnStyleName);
			if(!menuBtnSelector)
			{
				menuBtnSelector = new CSSStyleDeclaration();
			}
			menuBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_ICON;
				this.overSkin = DEFAULT_ICON;
				this.downSkin = DEFAULT_ICON;
				this.disabledSkin = DEFAULT_ICON;
			}					
			StyleManager.setStyleDeclaration("." + menuBtnStyleName, menuBtnSelector, false);

			//------------------------
		    //  menu windowImage
		    //------------------------
			var windowImageStyleName:String = selector.getStyle("windowImageStyleName");
			var windowImageSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + windowImageStyleName);
			if(!windowImageSelector)
			{
				windowImageSelector = new CSSStyleDeclaration();
			}
			windowImageSelector.defaultFactory = function():void
			{
				this.borderThicknessLeft= 4;
				this.borderThicknessRight= 4;
				this.borderThicknessTop= 4;
				this.borderThicknessBottom= 4;
				this.borderAlpha= 0.2;
				this.borderColor= 0xFFFFFF;
				this.headerHeight= 0;
				this.roundedBottomCorners= true;
				this.cornerRadius= 5;
			}					
			StyleManager.setStyleDeclaration("." + windowImageStyleName, windowImageSelector, false);			

			//------------------------
		    //  Application Menu
		    //------------------------
			var menuStyleName:String = selector.getStyle("menuStyleName");
			var menuSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + menuStyleName);
			if(!menuSelector)
			{
				menuSelector = new CSSStyleDeclaration();
			}
			menuSelector.defaultFactory = function():void
			{
				this.rollOverColor=0xA5A5A5;
				this.selectionColor=0xE0E0E0;
				this.backgroundColor=0x000000;
				this.borderColor=0x000000;
				this.cornerRadius=6;
				this.borderThickness=3;
				this.fontSize=11;
				this.paddingTop=6;
				this.paddingBottom=6;
				this.openDuration=0;
				this.borderStyle="solid";
				this.color=0xFFFFFF;
				this.backgroundAlpha=0.85;
				this.dropShadowEnabled=false;
			}					
			StyleManager.setStyleDeclaration("." + menuStyleName, menuSelector, false);

			//------------------------
		    //  minimize button
		    //------------------------
			var minimizeBtnStyleName:String = selector.getStyle("minimizeBtnStyleName");
			var minimizeBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + minimizeBtnStyleName);
			if(!minimizeBtnSelector)
			{
				minimizeBtnSelector = new CSSStyleDeclaration();
			}
			minimizeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_MINIMIZE_BUTTON;
				this.overSkin = DEFAULT_MINIMIZE_BUTTON;
				this.downSkin = DEFAULT_MINIMIZE_BUTTON;
				this.disabledSkin = DEFAULT_MINIMIZE_BUTTON;
			}					
			StyleManager.setStyleDeclaration("." + minimizeBtnStyleName, minimizeBtnSelector, false);
			
			//------------------------
		    //  maximize button
		    //------------------------
			var maximizeBtnStyleName:String = selector.getStyle("maximizeBtnStyleName");
			var maximizeBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + maximizeBtnStyleName);
			if(!maximizeBtnSelector)
			{
				maximizeBtnSelector = new CSSStyleDeclaration();
			}
			maximizeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.overSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.downSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.disabledSkin = DEFAULT_MAXIMIZE_BUTTON;
			}					
			StyleManager.setStyleDeclaration("." + maximizeBtnStyleName, maximizeBtnSelector, false);
			
			//------------------------
		    //  restore button
		    //------------------------
			var restoreBtnStyleName:String = selector.getStyle("restoreBtnStyleName");
			var restoreBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + restoreBtnStyleName);
			if(!restoreBtnSelector)
			{
				restoreBtnSelector = new CSSStyleDeclaration();
			}
			restoreBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_RESTORE_BUTTON;
				this.overSkin = DEFAULT_RESTORE_BUTTON;
				this.downSkin = DEFAULT_RESTORE_BUTTON;
				this.disabledSkin = DEFAULT_RESTORE_BUTTON;
			}					
			StyleManager.setStyleDeclaration("." + restoreBtnStyleName, restoreBtnSelector, false);
			
			//------------------------
		    //  close button
		    //------------------------
			var closeBtnStyleName:String = selector.getStyle("closeBtnStyleName");
			var closeBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + closeBtnStyleName);
			if(!closeBtnSelector)
			{
				closeBtnSelector = new CSSStyleDeclaration();
			}
			closeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_CLOSE_BUTTON;
				this.overSkin = DEFAULT_CLOSE_BUTTON;
				this.downSkin = DEFAULT_CLOSE_BUTTON;
				this.disabledSkin = DEFAULT_CLOSE_BUTTON;
			}
			StyleManager.setStyleDeclaration("." + closeBtnStyleName, closeBtnSelector, false);
			
			// apply it all
			StyleManager.setStyleDeclaration("MDIWindow", selector, false);
			
			return true;
		}
		
		/**
		 * Constructor
	     */
		public function MDIWindow()
		{
			super();
			minWidth = minHeight = width = height = MDIWindow.minSize;
			windowState = MDIWindowState.NORMAL;
			doubleClickEnabled = true;
			windowControls = new MDIWindowControlsContainer();
			updateContextMenu();
		}
		
		/**
		 * 添加子可见组件 屏蔽子组件的右键
		 */
		public function addChildUI(child:UIComponent):DisplayObject{
			
			var ct:ContextMenu = new ContextMenu;
			ct.hideBuiltInItems();
			child.contextMenu = ct;
			return super.addChild(child);
		}
		
		
		/**
		 * Returns the dindows style name. 
		 * @return 
		 * 
		 */
		public function get windowStyleName():Object
		{
			return _windowStyleName;
		}
		
		/**
		 * Sets the window style name. 
		 * @param value
		 * 
		 */
		public function set windowStyleName(value:Object):void
		{
			if(_windowStyleName == value)
				return;
			
			_windowStyleName = value;
			updateStyles();
		}
		
		/**
		 * Create resize handles and window controls.
		 */
		override protected function createChildren():void
		{
			super.createChildren();

			if(!titleBarOverlay)
			{
				titleBarOverlay = new Canvas();
				titleBarOverlay.width = this.width;
				titleBarOverlay.height = this.titleBar.height;
				titleBarOverlay.alpha = 0;
				titleBarOverlay.setStyle("backgroundColor", 0x000000);
				rawChildren.addChild(titleBarOverlay);
			}
			// edges
			if(!resizeHandleTop)
			{
				resizeHandleTop = new Button();
				resizeHandleTop.x = cornerHandleSize * .5;
				resizeHandleTop.y = -(edgeHandleSize * .5);
				resizeHandleTop.height = edgeHandleSize;
				resizeHandleTop.alpha = 0;
				resizeHandleTop.focusEnabled = false;
				rawChildren.addChild(resizeHandleTop);
			}
			
			if(!resizeHandleRight)
			{
				resizeHandleRight = new Button();
				resizeHandleRight.y = cornerHandleSize * .5;
				resizeHandleRight.width = edgeHandleSize;
				resizeHandleRight.alpha = 0;
				resizeHandleRight.focusEnabled = false;
				rawChildren.addChild(resizeHandleRight);
			}
			
			if(!resizeHandleBottom)
			{
				resizeHandleBottom = new Button();
				resizeHandleBottom.x = cornerHandleSize * .5;
				resizeHandleBottom.height = edgeHandleSize;
				resizeHandleBottom.alpha = 0;
				resizeHandleBottom.focusEnabled = false;
				rawChildren.addChild(resizeHandleBottom);
			}
			
			if(!resizeHandleLeft)
			{
				resizeHandleLeft = new Button();
				resizeHandleLeft.x = -(edgeHandleSize * .5);
				resizeHandleLeft.y = cornerHandleSize * .5;
				resizeHandleLeft.width = edgeHandleSize;
				resizeHandleLeft.alpha = 0;
				resizeHandleLeft.focusEnabled = false;
				rawChildren.addChild(resizeHandleLeft);
			}
			
			// corners
			if(!resizeHandleTL)
			{
				resizeHandleTL = new Button();
				resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .3);
				resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
				resizeHandleTL.alpha = 0;
				resizeHandleTL.focusEnabled = false;
				rawChildren.addChild(resizeHandleTL);
			}
			
			if(!resizeHandleTR)
			{
				resizeHandleTR = new Button();
				resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
				resizeHandleTR.alpha = 0;
				resizeHandleTR.focusEnabled = false;
				rawChildren.addChild(resizeHandleTR);
			}
			
			if(!resizeHandleBR)
			{
				resizeHandleBR = new Button();
				resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
				resizeHandleBR.alpha = 0;
				resizeHandleBR.focusEnabled = false;
				rawChildren.addChild(resizeHandleBR);
			}
			
			if(!resizeHandleBL)
			{
				resizeHandleBL = new Button();
				resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
				resizeHandleBL.alpha = 0;
				resizeHandleBL.focusEnabled = false;
				rawChildren.addChild(resizeHandleBL);
			}
			
			// bring windowControls to top as they are created in constructor
			if (menuBtn){
				rawChildren.setChildIndex(DisplayObject(menuBtn), rawChildren.numChildren - 2);	
				menuBtn.x = Number(this.getStyle("borderThicknessRight"));
				menuBtn.y = titleBarOverlay.height/2 + Number(this.getStyle("borderThicknessRight"));
			}
			rawChildren.setChildIndex(DisplayObject(windowControls), rawChildren.numChildren - 1);

			addListeners();
		}
		
		/**
		 * Position and size resize handles and window controls.
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			titleBarOverlay.width = this.width;
			titleBarOverlay.height = this.titleBar.height;
			
			// edges
			resizeHandleTop.x = cornerHandleSize * .5;
			resizeHandleTop.y = -(edgeHandleSize * .5);
			resizeHandleTop.width = this.width - cornerHandleSize;
			resizeHandleTop.height = edgeHandleSize;
			
			resizeHandleRight.x = this.width - edgeHandleSize * .5;
			resizeHandleRight.y = cornerHandleSize * .5;
			resizeHandleRight.width = edgeHandleSize;
			resizeHandleRight.height = this.height - cornerHandleSize;
			
			resizeHandleBottom.x = cornerHandleSize * .5;
			resizeHandleBottom.y = this.height - edgeHandleSize * .5;
			resizeHandleBottom.width = this.width - cornerHandleSize;
			resizeHandleBottom.height = edgeHandleSize;
			
			resizeHandleLeft.x = -(edgeHandleSize * .5);
			resizeHandleLeft.y = cornerHandleSize * .5;
			resizeHandleLeft.width = edgeHandleSize;
			resizeHandleLeft.height = this.height - cornerHandleSize;
			
			// corners
			resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .5);
			resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
			
			resizeHandleTR.x = this.width - cornerHandleSize * .5;
			resizeHandleTR.y = -(cornerHandleSize * .5);
			resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
			
			resizeHandleBR.x = this.width - cornerHandleSize * .5;
			resizeHandleBR.y = this.height - cornerHandleSize * .5;
			resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
			
			resizeHandleBL.x = -(cornerHandleSize * .5);
			resizeHandleBL.y = this.height - cornerHandleSize * .5;
			resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
			
			// cause windowControls container to update
			UIComponent(windowControls).invalidateDisplayList();
		}
		
				
		/**
		 * Returns if this windows has focus or not. 
		 * @return 
		 * 
		 */
		public function get hasFocus():Boolean
		{
			return _hasFocus;
		}
		
		/**
		 * Property is set by MDIManager when a window's focus changes. Triggers an update to the window's styleName.
		 */
		public function set hasFocus(value:Boolean):void
		{
			// guard against unnecessary processing
			if(_hasFocus == value)
				return;
			
			// set new value
			_hasFocus = value;
			updateStyles();
		}
		
		/**
		 * Mother of all styling functions. All styles fall back to the defaults if necessary.
		 */
		private function updateStyles():void
		{
			var selectorList:Array = getSelectorList();
			
			// if the style specifies a class to use for the controls container that is
			// different from the current one we will update it here
			if(getStyleByPriority(selectorList, "windowControlsClass"))
			{
				var clazz:Class = getStyleByPriority(selectorList, "windowControlsClass") as Class;
				var classNameExisting:String = getQualifiedClassName(windowControls);
				var classNameNew:String = getQualifiedClassName(clazz);
				
				if(classNameExisting != classNameNew)
				{
					windowControls = new clazz();
					// sometimes necessary to adjust windowControls subcomponents
					callLater(windowControls.invalidateDisplayList);
				}
			}
			
			// set window's styleName based on focus status
			if(hasFocus)
			{
				setStyle("styleName", getStyleByPriority(selectorList, "styleNameFocus"));
			}
			else
			{
				setStyle("styleName", getStyleByPriority(selectorList, "styleNameNoFocus"));
			}
			
			// style the window's title
			// this code is probably not as efficient as it could be but i am sick of dealing with styling
			// if titleStyleName (the style inherited from Panel) has been set we use that, regardless of focus
			if(!hasFocus && getStyleByPriority(selectorList, "titleStyleNameNoFocus"))
			{
				setStyle("titleStyleName", getStyleByPriority(selectorList, "titleStyleNameNoFocus"));
			}
			else if(getStyleByPriority(selectorList, "titleStyleNameFocus"))
			{
				setStyle("titleStyleName", getStyleByPriority(selectorList, "titleStyleNameFocus"));
			}
			else
			{
				getStyleByPriority(selectorList, "titleStyleName")
			}

			if(this.minWindow)
			{
				minWindow.styleName = getStyleByPriority(selectorList, "windowImageStyleName");
			}

			// style minimize button
			if(menuBtn)
			{
				// use noFocus style if appropriate and one exists
				if(!hasFocus && getStyleByPriority(selectorList, "menuBtnStyleNameNoFocus"))
				{
					menuBtn.styleName = getStyleByPriority(selectorList, "menuBtnStyleNameNoFocus");
				}
				else
				{
					menuBtn.styleName = getStyleByPriority(selectorList, "menuBtnStyleName");
				}
				
				if (menuBtn.menu){
					menuBtn.menu.styleName = getStyleByPriority(selectorList, "menuStyleName");
				}

			}

			
			// style minimize button
			if(minimizeBtn)
			{
				// use noFocus style if appropriate and one exists
				if(!hasFocus && getStyleByPriority(selectorList, "minimizeBtnStyleNameNoFocus"))
				{
					minimizeBtn.styleName = getStyleByPriority(selectorList, "minimizeBtnStyleNameNoFocus");
				}
				else
				{
					minimizeBtn.styleName = getStyleByPriority(selectorList, "minimizeBtnStyleName");
				}
			}
			
			// style maximize/restore button
			if(maximizeRestoreBtn)
			{
				// fork on windowState
				if(maximized)
				{
					// use noFocus style if appropriate and one exists
					if(!hasFocus && getStyleByPriority(selectorList, "restoreBtnStyleNameNoFocus"))
					{
						maximizeRestoreBtn.styleName = getStyleByPriority(selectorList, "restoreBtnStyleNameNoFocus");
					}
					else
					{
						maximizeRestoreBtn.styleName = getStyleByPriority(selectorList, "restoreBtnStyleName");
					}
				}
				else
				{
					// use noFocus style if appropriate and one exists
					if(!hasFocus && getStyleByPriority(selectorList, "maximizeBtnStyleNameNoFocus"))
					{
						maximizeRestoreBtn.styleName = getStyleByPriority(selectorList, "maximizeBtnStyleNameNoFocus");
					}
					else
					{
						maximizeRestoreBtn.styleName = getStyleByPriority(selectorList, "maximizeBtnStyleName");
					}
				}
			}
			
			// style close button
			if(closeBtn)
			{
				// use noFocus style if appropriate and one exists
				if(!hasFocus && getStyleByPriority(selectorList, "closeBtnStyleNameNoFocus"))
				{
					closeBtn.styleName = getStyleByPriority(selectorList, "closeBtnStyleNameNoFocus");
				}
				else
				{
					closeBtn.styleName = getStyleByPriority(selectorList, "closeBtnStyleName");
				}
			}
		}
		
		protected function getSelectorList():Array
		{
			// initialize array with ref to ourself since inline styles take highest priority
			var selectorList:Array = new Array(this);
			
			// if windowStyleName was set by developer we associated styles to the list
			if(windowStyleName)
			{
				// make sure a corresponding style actually exists
				var classSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + windowStyleName);
				if(classSelector)
				{
					selectorList.push(classSelector);
				}
			}
			// add type selector (created in classConstruct so we know it exists)
			var typeSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIWindow");
			selectorList.push(typeSelector);
			
			return selectorList;
		}
		
		/**
		 * Function to return appropriate style based on our funky setup.
		 * Precedence of styles is inline, class selector (as specified by windowStyleName)
		 * and then type selector (MDIWindow).
		 * 
		 * @private
		 */
		protected function getStyleByPriority(selectorList:Array, style:String):Object
		{			
			var n:int = selectorList.length;			
			
			for(var i:int = 0; i < n; i++)
			{
				// we need to make sure this.getStyle() is not pointing to the style defined
				// in the type selector because styles defined in the class selector (windowStyleName)
				// should take precedence over type selector (MDIWindow) styles
				// this.getStyle() will return styles from the type selector if an inline
				// style was not specified
				if(selectorList[i] == this 
				&& selectorList[i].getStyle(style) 
				&& this.getStyle(style) === selectorList[n - 1].getStyle(style))
				{
					continue;
				}
				if(selectorList[i].getStyle(style))
				{
					// if this is a style name make sure the style exists
					if(typeof(selectorList[i].getStyle(style)) == "string"
						&& !(StyleManager.getStyleDeclaration("." + selectorList[i].getStyle(style))))
					{
						continue;
					}
					else
					{
						return selectorList[i].getStyle(style);
					}
				}
			}
			
			return null;
		}
		
		/**
		 * Detects change to styleName that is executed by MDIManager indicating a change in focus.
		 * Iterates over window controls and adjusts their styles if they're focus-aware.
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			if(!styleProp || styleProp == "styleName")
				updateStyles(); 
		}
		
		/**
		 * Reference to class used to create windowControls property.
		 */
		public function get windowControls():MDIWindowControlsContainer
		{
			return _windowControls;
		}
		
		/**
		 * When reference is set windowControls will be reinstantiated, meaning runtime switching is supported.
		 */
		public function set windowControls(controlsContainer:MDIWindowControlsContainer):void
		{
			if(_windowControls)
			{
				var cntnr:Container = Container(windowControls);
				cntnr.removeAllChildren();
				rawChildren.removeChild(cntnr);
				_windowControls = null;
			}
			
			_windowControls = controlsContainer;
			_windowControls.window = this;
			rawChildren.addChild(UIComponent(_windowControls));
			if(windowState == MDIWindowState.MINIMIZED)
			{
				showControls = false;
			}
		}
		
		/**
		 * Minimize window button.
		 */
		public function get minimizeBtn():Button
		{
			return windowControls.minimizeBtn;
		}
		
		/**
		 * Maximize/restore window button.
		 */
		public function get maximizeRestoreBtn():Button
		{
			return windowControls.maximizeRestoreBtn;
		}
		
		/**
		 * Close window button.
		 */
		public function get closeBtn():Button
		{
			return windowControls.closeBtn;
		}
		
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}
		
		public function set showCloseButton(value:Boolean):void
		{
			_showCloseButton = value;
			if(closeBtn && closeBtn.visible != value)
			{
				closeBtn.visible = value;
				invalidateDisplayList();
			}
		}
		
		/**
		 * Returns reference to titleTextField which is protected by default.
		 * Provided to allow MDIWindowControlsContainer subclasses as much freedom as possible.
		 */
		public function getTitleTextField():UITextField
		{
			return titleTextField as UITextField;
		}
		
		/**
		 * Returns reference to titleIconObject which is mx_internal by default.
		 * Provided to allow MDIWindowControlsContainer subclasses as much freedom as possible.
		 */
		public function getTitleIconObject():DisplayObject
		{
			use namespace mx_internal;
			return titleIconObject as DisplayObject;
		}
		
		/**
		 * Save style settings for minimizing.
	     */
		public function saveStyle():void
		{
			//this.backgroundAlphaRestore = this.getStyle("backgroundAlpha");
		}
		
		/**
		 * Restores style settings for restore and maximize
	     */
		public function restoreStyle():void
		{
			//this.setStyle("backgroundAlpha", this.backgroundAlphaRestore);
		}
		
		/**
		 * Add listeners for resize handles and window controls.
		 */
		private function addListeners():void
		{
			titleBarOverlay.addEventListener(MouseEvent.MOUSE_OVER,showImage);
			
			// edges
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// corners
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// titleBar overlay
			titleBarOverlay.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarPress, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);

			// window controls
			addEventListener(MouseEvent.CLICK, windowControlClickHandler, false, 0, true);
			
			// clicking anywhere brings window to front
			addEventListener(MouseEvent.MOUSE_DOWN, bringToFrontProxy);
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, bringToFrontProxy);//右键遮罩
		}
		
		/**
		 * Desactivates click and double click in the windows, usefull when you are moving it around.
		 * 
		 */
		public function deactivateClicks():void{
			titleBarOverlay.removeEventListener(MouseEvent.DOUBLE_CLICK,maximizeRestore);
			titleBarOverlay.removeEventListener(MouseEvent.CLICK,unMinimize);
			if (menuBtn){
				menuBtn.removeEventListener(MouseEvent.DOUBLE_CLICK,maximizeRestore);
				menuBtn.removeEventListener(MouseEvent.CLICK,unMinimize);
			}
		}

		/**
		 * Activates click and double click in the windows.
		 * 
		 */		
		public function activateClicks():void{
			titleBarOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);
			if (menuBtn){
				menuBtn.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
				menuBtn.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);
			}				
		}
		
		/**
		 * Click handler for default window controls (minimize, maximize/restore and close).
		 */
		private function windowControlClickHandler(event:MouseEvent):void
		{
			if(windowControls)
			{
				if(windowControls.minimizeBtn && event.target == windowControls.minimizeBtn)
				{
					minimize();
				}
				else if(windowControls.maximizeRestoreBtn && event.target == windowControls.maximizeRestoreBtn)
				{
					maximizeRestore();
				}
				else if(windowControls.closeBtn && event.target == windowControls.closeBtn)
				{
					close();
				}
			}
		}
		
		/**
		 * Called automatically by clicking on window this now delegates execution to the manager.
		 * 触发激活窗口, 遮罩
		 */
		public function bringToFrontProxy(event:Event):void
		{
			windowManager.bringToFront(this);		
		}
		
		/**
		 *  Minimize the window.
		 */
		public function minimize(event:MouseEvent = null):void
		{	
			// if the panel is floating, save its state
			if(windowState == MDIWindowState.NORMAL)
			{
				savePanel();
			}
			this.takeImage();
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MINIMIZE, this));
			windowState = MDIWindowState.MINIMIZED;
			showControls = false;
			if (this.menuBtn){
				this.menuBtn.disableShow();	
			}
		}
		
		
		/**
		 *  Called from maximize/restore button 
		 * 
		 *  @event MouseEvent (optional)
		 */
		public function maximizeRestore(event:MouseEvent = null):void
		{
			if(windowState == MDIWindowState.NORMAL)
			{
				savePanel();
				maximize();
			}
			else
			{
				restore();
			}
		}
		
		/**
		 * Restores the window to its last floating position.
		 */
		public function restore():void
		{
			windowState = MDIWindowState.NORMAL;
			updateStyles();
			this.windowManager.bringToFront(this);
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, this));
		}
		
		/**
		 * Maximize the window.
		 */
		public function maximize():void
		{
			if(maxEnabled){
				if(windowState == MDIWindowState.NORMAL)
				{
					savePanel();
				}
				showControls = true;
				windowState = MDIWindowState.MAXIMIZED;
				updateStyles();
				this.windowManager.bringToFront(this);
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, this));
			}
		}
		
		/**
		 * Close the window.
		 */
		public function close(event:MouseEvent = null):void
		{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE, this));
		}
		
		/**
		 * Save the panel's floating coordinates.
		 * 
		 * @private
		 */
		private function savePanel():void
		{
			savedWindowRect = new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Title bar dragging.
		 * 
		 * @private
		 */
		private function onTitleBarPress(event:MouseEvent):void
		{
			// only floating windows can be dragged
			if(this.windowState == MDIWindowState.NORMAL && draggable)
			{
				if(windowManager.enforceBoundaries)
				{
					this.startDrag(false, new Rectangle(0, 0, parent.width - this.width, parent.height - this.height));
				}
				else
				{
					this.startDrag(false,new Rectangle(-this.width+5, - this.height+20, this.width+parent.width - 5, this.height+parent.height -this.windowManager.mdiApplication._appBarHeight-15));
				}				
				
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onWindowMove);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
			}
			
		}
		
		private function onWindowMove(event:MouseEvent):void
		{
			if(!_dragging)
			{
				_dragging = true;
				// clear styles (future versions may allow enforcing constraints on drag)
				this.clearStyle("top");
				this.clearStyle("right");
				this.clearStyle("bottom");
				this.clearStyle("left");
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_START, this));
			}
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG, this));
		}
		
		private function onTitleBarRelease(event:Event):void
		{
			this.stopDrag();
			if(_dragging)
			{
				_dragging = false;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_END, this));
			}
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onWindowMove);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
			
		}
		
		/**
		 * Mouse down on any resize handle.
		 */
		private function onResizeButtonPress(event:MouseEvent):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				currentResizeHandle = event.target as Button;
				setCursor(currentResizeHandle);
				dragStartMouseX = parent.mouseX;
				dragStartMouseY = parent.mouseY;
				savePanel();
				
				dragMaxX = savedWindowRect.x + (savedWindowRect.width - minWidth);
				dragMaxY = savedWindowRect.y + (savedWindowRect.height - minHeight);
				
				systemManager.addEventListener(Event.ENTER_FRAME, updateWindowSize, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease, false, 0, true);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage, false, 0, true);
			}
		}
		
		private function onResizeButtonDrag(event:MouseEvent):void
		{
			if(!_resizing)
			{
				_resizing = true;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_START, this));
			}			
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE, this));
		}
		
		/**
		 * Mouse move while mouse is down on a resize handle
		 */
		private function updateWindowSize(event:Event):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				dragAmountX = parent.mouseX - dragStartMouseX;
				dragAmountY = parent.mouseY - dragStartMouseY;
				
				if(currentResizeHandle == resizeHandleTop && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleRight && parent.mouseX < parent.width)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleBottom && parent.mouseY < parent.height)
				{
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleLeft && parent.mouseX > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleTL && parent.mouseX > 0 && parent.mouseY > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);				
				}
				else if(currentResizeHandle == resizeHandleTR && parent.mouseX < parent.width && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBR && parent.mouseX < parent.width && parent.mouseY < parent.height)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBL && parent.mouseX > 0 && parent.mouseY < parent.height)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
			}
		}
		
		private function onResizeButtonRelease(event:MouseEvent = null):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				if(_resizing)
				{
					_resizing = false;
					dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_END, this));
				}
				currentResizeHandle = null;
				systemManager.removeEventListener(Event.ENTER_FRAME, updateWindowSize);
				systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag);
				systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease);
				systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		private function onMouseLeaveStage(event:Event):void
		{
			onResizeButtonRelease();
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
		}
		
		/**
		 * Restore window to state it was in prior to being minimized.
		 */
		public function unMinimize(event:MouseEvent = null):void
		{
			if(minimized)
			{
				showControls = true;
				if (this.menuBtn){
					this.menuBtn.enableShow();	
				}
				
				if(_prevWindowState == MDIWindowState.NORMAL)
				{
					restore();
				}
				else
				{
					maximize();
				}
			}
		}
		
		private function setCursor(target:Button):void
		{
			var styleStub:String;			
			
			switch(target)
			{
				case resizeHandleRight:
				case resizeHandleLeft:
					styleStub = "resizeCursorHorizontal";
				break;
				
				case resizeHandleTop:
				case resizeHandleBottom:
					styleStub = "resizeCursorVertical";
				break;
				
				case resizeHandleTL:
				case resizeHandleBR:
					styleStub = "resizeCursorTopLeftBottomRight";
				break;
				
				case resizeHandleTR:
				case resizeHandleBL:
					styleStub = "resizeCursorTopRightBottomLeft";
				break;
			}
			
			var selectorList:Array = getSelectorList();
			
			CursorManager.removeCursor(CursorManager.currentCursorID);
			CursorManager.setCursor(Class(getStyleByPriority(selectorList, styleStub + "Skin")), 
									2, 
									Number(getStyleByPriority(selectorList, styleStub + "XOffset")), 
									Number(getStyleByPriority(selectorList, styleStub + "YOffset")));
		}
		
		private function onResizeButtonRollOver(event:MouseEvent):void
		{
			// only floating windows can be resized
			// event.buttonDown is to detect being dragged over
			if(windowState == MDIWindowState.NORMAL && resizable && !event.buttonDown)
			{
				setCursor(event.target as Button);
			}
		}
		
		private function onResizeButtonRollOut(event:MouseEvent):void
		{
			if(!event.buttonDown)
			{
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		/**
		 * Show the controls for the window. 
		 * @param value
		 * 
		 */
		public function set showControls(value:Boolean):void
		{
			Container(windowControls).visible = value;
		}
		
		private function get windowState():int
		{
			return _windowState;
		}
		
		private function set windowState(newState:int):void
		{
			_prevWindowState = _windowState;
			_windowState = newState;
			this.publicState = newState;
			updateContextMenu();
		}
		
		/**
		 * Returns true the state for the windows if minimized. 
		 * @return 
		 * 
		 */
		public function get minimized():Boolean
		{
			return _windowState == MDIWindowState.MINIMIZED;
		}

		/**
		 * Returns true the state for the windows if Maximized. 
		 * @return 
		 * 
		 */	
		public function get maximized():Boolean
		{
			return _windowState == MDIWindowState.MAXIMIZED;
		}
		
		/**
		 * Returns the heigth of the minimized windows. 
		 * @return 
		 * 
		 */
		public function get minimizeHeight():Number
		{
			return titleBar.height;
		}

		/**
		 * Sets the xml that configures the menu window. 
		 * @param value
		 * 
		 */
		public function set dataProvider(value:Object):void{
			this._dataProvider = value;
			if (!menuBtn)
			{	
				menuBtn = new MDIWindowMenuButton(this._dataProvider);
				this.menuBtn.window = this;
				menuBtn.width=22;
				menuBtn.height=22;
				rawChildren.addChild(menuBtn);
				menuBtn.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarPress, false, 0, true);
				menuBtn.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease, false, 0, true);
				menuBtn.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
				menuBtn.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);
			}
			this.menuBtn.dataProvider = value;
			updateStyles();
		}
		
		/**
		 * Returns the xml that configures the menu window.
		 * @return 
		 * 
		 */
		public function get dataProvider():Object{
			if (this.menuBtn!=null){
				return this.menuBtn.dataProvider;
			}
			else{
				return this._dataProvider;
			}
		}
		
		public function lisentMenuItemClick(event:MenuEvent):void{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MENU_ITEM_CLICK,this,false,event.item));
		}

		public function lisentMenuShow(event:MenuEvent):void{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.SHOW_MENU,this,false,event.item));
		}	
		
		private function showImage(event:MouseEvent):void{
			
			if (this.isMinimized && !this.windowManager.mdiApplication.isBarCollapsing){
				this.minWindow.endEffectsStarted();
				PopUpManager.addPopUp(this.minWindow,this.windowManager.mdiApplication as DisplayObject);
				this.minWindow.x=this.localToGlobal(new Point(0,0)).x + (Math.floor((this.width-this.minWindow.width)+1)/2);
				if (this.windowManager.mdiApplication.barPossition == MDIApplication.BOTTON_POSITON){
					this.minWindow.y=this.windowManager.mdiApplication.height-this.windowManager.mdiApplication._appBarHeight-this.minWindow.height;	
				}
				else if (this.windowManager.mdiApplication.barPossition == MDIApplication.TOP_POSITON){
					this.minWindow.y=this.windowManager.mdiApplication._appBarHeight;
				}
				this.addEventListener(MouseEvent.MOUSE_OUT,hideImage);
			}
		}
		
		private function hideImage(event:MouseEvent):void{
			this.minWindow.endEffectsStarted();
			PopUpManager.removePopUp(this.minWindow);
		}
		
		private function takeImage():void{
			var winImage:Image = new Image(); 
			var bitmapData:BitmapData;
			var bitmapAsset:BitmapAsset;
			var bitmap:Bitmap;
			var ratio:Number;
			this.minWindow = new Panel();
			
			this.minWindow.horizontalScrollPolicy="off";
			this.minWindow.verticalScrollPolicy="off";
			this.minWindow.setStyle("addedEffect",this.windowManager.effects.getMinWindowShowEffect(this.minWindow));
			this.minWindow.setStyle("removedEffect",this.windowManager.effects.getMinWindowHideEffect(this.minWindow));
			this.updateStyles();
			this.validateNow();

			bitmapData = ImageSnapshot.captureBitmapData(this);
			bitmapDataBefore =bitmapData.clone();
			bitmapAsset = new BitmapAsset(bitmapData);
			bitmapAsset.smoothing = true;
			winImage.source = bitmapAsset;

			if(this.savedWindowRect.width > MDIApplication.windowImageSize*1.20
				|| this.savedWindowRect.height > MDIApplication.windowImageSize*1.20) {
            	if(this.savedWindowRect.width > this.savedWindowRect.height) {
                	ratio = MDIApplication.windowImageSize*1.20/this.savedWindowRect.width;
                	winImage.percentWidth=100;
                } else {
                	ratio = MDIApplication.windowImageSize*1.20/this.savedWindowRect.height;
                	winImage.percentHeight=100;
                }
            } else {
              ratio = 1;
            }	

			this.minWindow.height=this.savedWindowRect.height*ratio;
			this.minWindow.width=this.savedWindowRect.width*ratio;
			this.minWindow.addChild(winImage);
            this.updateStyles();
		}
		

		/**
		 * 设置模式窗口.不允许最大化.不允许改变大小
		 */
		public function set modelDialog(item:Boolean):void{
			if(item){
				maxEnabled = false;//不允许最大化
				resizable = false;//不允许改变窗口大小
				maximizeRestoreBtn.visible = false;//不显示最大化按钮
			}
		}
		
		/**
		 * 默认开启支持最大化
		 */
		public var maxEnabled:Boolean = true;
		/**
		 * 是否使用右键
		 */
		public var isShowRightMenu:Boolean = true;
		/**
		 * 显示右键
		 */
		
		public function updateContextMenu():void
		{		
			var defaultContextMenu:ContextMenu = new ContextMenu();
			defaultContextMenu.hideBuiltInItems();
			if (MDIApplication.WINDOW_CTX_MENU){
				var minimizeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.minimizeText);
				minimizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				minimizeItem.enabled = windowState != MDIWindowState.MINIMIZED;
				defaultContextMenu.customItems.push(minimizeItem);	
				
				
				if(maxEnabled){
					var maximizeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.maximizeText);
					maximizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
					maximizeItem.enabled = windowState != MDIWindowState.MAXIMIZED;
					defaultContextMenu.customItems.push(maximizeItem);	
					
				}
				
				var restoreItem:ContextMenuItem = new ContextMenuItem(MDIApplication.restoreText);
				restoreItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				restoreItem.enabled = windowState != MDIWindowState.NORMAL;
				defaultContextMenu.customItems.push(restoreItem);	
				
				var closeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.closeText);
				closeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(closeItem);    
				
				var arrangeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.titleText);
				arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
				arrangeItem.separatorBefore=true;
				defaultContextMenu.customItems.push(arrangeItem);
				
				var arrangeFillItem:ContextMenuItem = new ContextMenuItem(MDIApplication.titleFillText);
				arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
				defaultContextMenu.customItems.push(arrangeFillItem);
				
				var cascadeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.cascadeText);
				cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(cascadeItem);
				
				var restoreAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.restoreAllText);
				restoreAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(restoreAllItem);
				
				var minimizeAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.minimizeAllText);
				minimizeAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(minimizeAllItem);	
				
				var closeAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.closeAllText);
				closeAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(closeAllItem);					
			}
			this.contextMenu = defaultContextMenu;
		}
		
		
//		public function showRightMenu():void
//		{		
//			RightMenuModellocator.getInstance().removeMenu();
//			if(!isShowRightMenu){//如果不嗲用默认的系统右键菜单
//				return;
//			}
//			if (MDIApplication.WINDOW_CTX_MENU){
//				
//				var menuDataProvider:ArrayCollection = new ArrayCollection();
//				menuDataProvider.addItem({"label":MDIApplication.minimizeText,"enabled":windowState != MDIWindowState.MINIMIZED});
//				if(maxEnabled){
//					menuDataProvider.addItem({"label":MDIApplication.maximizeText,"enabled":windowState != MDIWindowState.MAXIMIZED});
//				}
//				menuDataProvider.addItem({"label":MDIApplication.restoreText,"enabled":windowState != MDIWindowState.NORMAL});
//				menuDataProvider.addItem({"label":MDIApplication.closeText});
//				menuDataProvider.addItem({"label":"separator","type":"separator"});
//				menuDataProvider.addItem({"label":MDIApplication.titleText});
//				menuDataProvider.addItem({"label":MDIApplication.titleFillText});
//				menuDataProvider.addItem({"label":MDIApplication.cascadeText});
//				menuDataProvider.addItem({"label":MDIApplication.restoreAllText});
//				menuDataProvider.addItem({"label":MDIApplication.minimizeAllText});
//				menuDataProvider.addItem({"label":MDIApplication.closeAllText});
//				
//				RightMenuModellocator.getInstance().menu = Menu.createMenu(this, menuDataProvider, false);  
//				
//				RightMenuModellocator.getInstance().menu.labelField="label";
//				//				index.menu.iconFunction = rightMenuIcon;
//				RightMenuModellocator.getInstance().menu.variableRowHeight = true;     
//				RightMenuModellocator.getInstance().menu.addEventListener(MenuEvent.ITEM_CLICK, function (ev:MenuEvent):void{
//					menuItemSelectHandler(ev.label);
//				});       
//				
//				//				var point:Point = new Point(mouseX,mouseY);  
//				//				point = localToGlobal(point);   
//				RightMenuModellocator.getInstance().menu.show(); 
//				
//				var screenRight:int = screen.right;
//				var screenBottom:int = screen.bottom;
//				var screenLeft:int = screen.left;
//				var _showX:int = stage.mouseX;
//				var _showY:int = stage.mouseY;
//				if(screenRight-stage.mouseX<RightMenuModellocator.getInstance().menu.width){
//					_showX = stage.mouseX-(RightMenuModellocator.getInstance().menu.width-(screenRight-stage.mouseX));
//					//					trace("stage.mouseX :"+stage.mouseX+" \t screenRight"+screenRight+" 差 "+(screenRight-stage.mouseX)+" 到右边");
//				}
//				if(screenBottom-stage.mouseY<RightMenuModellocator.getInstance().menu.height){
//					_showY = stage.mouseY-(RightMenuModellocator.getInstance().menu.height-(screenBottom-stage.mouseY));
//					//					trace("stage.mouseY :"+stage.mouseY+" \t screenBottom"+screenBottom+" 差 "+(screenBottom-stage.mouseY)+" 到底边");
//				}
//				RightMenuModellocator.getInstance().menu.move(_showX,_showY);
//				//				trace(menu.width);
//				//				trace(menu.height);
//				
//			}
//		}
		
		private function menuItemSelectHandler(event:ContextMenuEvent):void
		{
			this.windowManager.hideAllMenus();
			switch(event.target.caption)
			{
				case(MDIApplication.minimizeText):
					minimize();
				break;
				
				case(MDIApplication.maximizeText):
					maximize();
				break;
				
				case(MDIApplication.restoreText):
					if(this.windowState == MDIWindowState.MINIMIZED)
					{
						unMinimize();
					}
					else if(this.windowState == MDIWindowState.MAXIMIZED)
					{
						maximizeRestore();
					}	
				break;
				
				case(MDIApplication.closeText):
					close();
				break;
				
				case(MDIApplication.titleText):
					this.windowManager.tile(false, this.windowManager.tilePadding);
				break;
				
				case(MDIApplication.titleFillText):
					this.windowManager.tile(true, this.windowManager.tilePadding);
				break;
				
				case(MDIApplication.cascadeText):
					this.windowManager.cascade();
				break;
				
				case(MDIApplication.showAllText):
					this.windowManager.showAllWindows();
				break;
				
				case(MDIApplication.minimizeAllText):
					this.windowManager.minimizeAll();
				break;			

				case(MDIApplication.closeAllText):
					this.windowManager.closeAll();
				break;

				case(MDIApplication.restoreAllText):
					this.windowManager.showAllWindows();
				break;	

			}
		}
		
	}
}