/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.effects
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.containers.ApplicationControlBar;
	import mx.effects.Effect;
	import mx.effects.IEffect;
	
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.managers.MDIManager;
	
	/**
	 * Interface expected by MDIManager. All effects classes must implement this interface.
	 */
	public interface IMDIEffectsDescriptor
	{
		// window effects
		
		function getWindowAddEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null):Effect;
	
		function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect;
		
		function getWindowRestoreMinimizedEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect;
		
		function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0):Effect;
	
		function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowFocusStartEffect(window:MDIWindow, manager:MDIManager):Effect;
	
		function getWindowFocusEndEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowDragStartEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowDragEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowDragEndEffect(window:MDIWindow, manager:MDIManager):Effect;
	
		function getWindowResizeStartEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowResizeEffect(window:MDIWindow, manager:MDIManager):Effect;
		
		function getWindowResizeEndEffect(window:MDIWindow, manager:MDIManager):Effect;
	
		// group effects
		
		function getTileEffect(items:Array, manager:MDIManager):Effect;
		
		function getCascadeEffect(items:Array, manager:MDIManager):Effect;
		
		function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point):Effect;
		
		function getTitledContainerDownEffect(object:DisplayObject):Effect;
		
		function getTitledContainerUpEffect(object:DisplayObject):Effect;
		
		function getMinWindowShowEffect(minWin:DisplayObject):Effect;
		
		function getMinWindowHideEffect(minWin:DisplayObject):Effect;
		
	}
}