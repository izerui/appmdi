package org.trueagile.amdi.containers.appmenus
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import mx.controls.Menu;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.menuClasses.IMenuItemRenderer;
	import mx.core.Application;
	import mx.core.mx_internal;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
		
	use namespace mx_internal;
	
	/**
	 * This class represents a flex Menu that can have diferent styles for menu and submenues.
	 * @author mmarmol
	 * 
	 */
	public class SubStyleMenu extends Menu
	{
		/**
		 *The sub menu style name. 
		 */
		public var subMenuStyleName:String;
		
		private var isDirectionLeft:Boolean = false;
		
		private var subMenu:SubStyleMenu = null;
			
		private var anchorRow:IListItemRenderer;
		
		public function SubStyleMenu()
		{
			super();
		}

	    public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean = true):SubStyleMenu
	    {
	        var menu:SubStyleMenu = new SubStyleMenu();
	        menu.tabEnabled = false;
	        menu.owner = DisplayObjectContainer(Application.application);
	        menu.showRoot = showRoot;
	        popUpMenu(menu, parent, mdp);
	        return menu;
	    }
		
		override mx_internal function openSubMenu(row:IListItemRenderer):void
	    {
	        supposedToLoseFocus = true;
	        
	        var r:Menu = getRootMenu();
	        var menu:SubStyleMenu;
	        
	        // check to see if the menu exists, if not create it
	        if (!IMenuItemRenderer(row).menu)
	        {
	            menu = new SubStyleMenu();
	            menu.parentMenu = this;
	            menu.owner = this;
	            menu.showRoot = showRoot;
	            menu.dataDescriptor = r.dataDescriptor;
	            menu.styleName = SubStyleMenu(r).subMenuStyleName;
	            menu.labelField = r.labelField;
	            menu.labelFunction = r.labelFunction;
	            menu.iconField = r.iconField;
	            menu.iconFunction = r.iconFunction;
	            menu.itemRenderer = r.itemRenderer;
	            menu.rowHeight = r.rowHeight;
	            menu.scaleY = r.scaleY;
	            menu.scaleX = r.scaleX;
	            // if there's data and it has children then add the items
	            if (row.data && 
	                _dataDescriptor.isBranch(row.data) &&
	                _dataDescriptor.hasChildren(row.data))
	            {
	                menu.dataProvider = _dataDescriptor.getChildren(row.data);
	            }
	            menu.sourceMenuBar = sourceMenuBar;
	            menu.sourceMenuBarItem = sourceMenuBarItem;
	            
	            IMenuItemRenderer(row).menu = menu;
	            PopUpManager.addPopUp(menu, r, false);
	        }
	        else
	        {
	            menu = SubStyleMenu(IMenuItemRenderer(row).menu);
	            menu.styleName=SubStyleMenu(r).subMenuStyleName;
	        }
	        
	        var _do:DisplayObject = DisplayObject(row);
	        var sandBoxRootPoint:Point = new Point(0,0);
	        sandBoxRootPoint = _do.localToGlobal(sandBoxRootPoint);
	        // when loadMovied, you may not be in global coordinates
	        if (_do.root)   //verify this is sufficient
	            sandBoxRootPoint = _do.root.globalToLocal(sandBoxRootPoint);
	        
	        // showX, showY are in sandbox root coordinates
	        var showY:Number = sandBoxRootPoint.y;
	        var showX:Number;
	        if (!isDirectionLeft)
	            showX = sandBoxRootPoint.x + row.width;
	        else
	            showX = sandBoxRootPoint.x - menu.getExplicitOrMeasuredWidth();
	        
	        // convert to global coordinates to compare with getVisibleApplicationRect().
	        // the screen is the visible coordinates of our sandbox (written in global coordinates)
	        var screen:Rectangle = systemManager.getVisibleApplicationRect();
	        var sbRoot:DisplayObject = systemManager.getSandboxRoot();
	        
	        var screenPoint:Point = sbRoot.localToGlobal(new Point(showX, showY));
	        
	        // do x
	        var shift:Number = screenPoint.x + menu.getExplicitOrMeasuredWidth() - screen.right;
	        if (shift > 0 || screenPoint.x < screen.x)
	        {
	            // if we want to ensure our parent's visible, let's 
	            // modify the shift so that we're not just on-screen
	            // but we're also shifted away from our parent.
	            var shiftForParent:Number = getExplicitOrMeasuredWidth() + menu.getExplicitOrMeasuredWidth();
	            
	            // if was going left, shift to right.  otherwise, shift to left
	            if (isDirectionLeft)
	                shiftForParent *= -1;
	            
	            showX = Math.max(showX - shiftForParent, 0);
	            
	            // now make sure we're still on-screen again
	            screenPoint = new Point(showX, showY);
	            screenPoint = sbRoot.localToGlobal(screenPoint);
	            
	            // only shift if greater our position + width > width of screen
	            shift = Math.max(0, screenPoint.x + width - screen.right);
	            
	            showX = Math.max(showX - shift, 0);
	        }
	        
	        menu.isDirectionLeft = this.x > showX;
	        
	        // now do y
	        shift = screenPoint.y + menu.getExplicitOrMeasuredHeight() - screen.bottom;
	        if (shift > 0 || screenPoint.y < screen.y)
	            showY = Math.max(showY - shift, 0);
	        
	        menu.show(showX, showY);

	        subMenu = menu;
	        clearInterval(openSubMenuTimer);
	        openSubMenuTimer = 0;
	    }

    override protected function mouseOverHandler(event:MouseEvent):void
    {
        if (!enabled || !selectable || !visible) 
            return;
            
        systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true, 0, true);

        var row:IListItemRenderer = mouseEventToItemRenderer(event);

        if (!row)
            return;

        var item:Object;
        if (row && row.data)
            item = row.data;

        isPressed = event.buttonDown;
        
        if (row && row != anchorRow)
        {
            if (anchorRow)
                // no longer on anchor so close its submenu
                drawItem(anchorRow, false, false);
            if (subMenu)
            {
                subMenu.supposedToLoseFocus = true;
                subMenu.closeTimer = setTimeout(closeSubMenu, 250, subMenu);
            }
            subMenu = null;
            anchorRow = null;
        }
        else if (subMenu && subMenu.subMenu)
        {
            // Close grandchild submenus - only children are allowed to be open
            subMenu.subMenu.hide();
        }
        
        // Update the view
        if (_dataDescriptor.isBranch(item) && _dataDescriptor.isEnabled(item))
        {
            anchorRow = row;

            // If there's a timer waiting to close this menu, cancel the
            // timer so that the menu doesn't close
            if (subMenu && subMenu.closeTimer)
            {
                clearInterval(subMenu.closeTimer);
                subMenu.closeTimer = 0;
            }

            // If the menu is not visible, pop it up after a short delay
            if (!subMenu || !subMenu.visible)
            {
                if (openSubMenuTimer)
                    clearInterval(openSubMenuTimer);
 
                openSubMenuTimer = setTimeout(
                    function(row:IListItemRenderer):void
                    {
                        openSubMenu(row);
                    },
                    250,
                    row);
            }
        }
            
            // Send event and update view
        if (item && _dataDescriptor.isEnabled(item))
        {
            // we're rolling onto different subpieces of ourself or our highlight indicator
            if (event.relatedObject)
            {
                if (itemRendererContains(row, event.relatedObject) ||
                    row == lastHighlightItemRenderer ||
                    event.relatedObject == highlightIndicator)
                        return;
            }
        }

        if (row)
        {
            drawItem(row, false, Boolean(item && _dataDescriptor.isEnabled(item)));
            
            if (isPressed)
            {
                if (item && _dataDescriptor.isEnabled(item))
                {
                    if (!_dataDescriptor.isBranch(item))
                        selectItem(row, event.shiftKey, event.ctrlKey);
                    else
                        clearSelected();
                }
            }
            
            if (item && _dataDescriptor.isEnabled(item))
            {
                // Fire the appropriate rollover event
                var menuEvent:MenuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
                menuEvent.menu = this;
                menuEvent.index = getRowIndex(row);
                menuEvent.menuBar = sourceMenuBar;
                menuEvent.label = itemToLabel(item);
                menuEvent.item = item;
                menuEvent.itemRenderer = row;
                getRootMenu().dispatchEvent(menuEvent);
            }
        }
    }

    private function closeSubMenu(menu:Menu):void
    {
        menu.hide();
        clearInterval(menu.closeTimer);
        menu.closeTimer = 0;
    }

    /**
     * Given a row, find the row's index in the Menu. 
     */
     private function getRowIndex(row:IListItemRenderer):int
     {
        for (var i:int = 0; i < listItems.length; i++)
        {
            var item:IListItemRenderer = listItems[i][0];
            if (item && item.data && !(_dataDescriptor.getType(item.data) == "separator"))
                if (item == row)
                    return i;
        }
        return -1;
     }

	}
}