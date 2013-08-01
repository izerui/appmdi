/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.effects.effectsLib
{
	import org.trueagile.amdi.containers.MDIApplication;
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.effects.IMDIEffectsDescriptor;
	import org.trueagile.amdi.effects.MDIEffectsDescriptorBase;
	import org.trueagile.amdi.managers.MDIManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.Resize;
	import mx.effects.Sequence;
	
	/**
	 * Collection of effects that limit movement to one dimension (horizontal/vertical) at a time.
	 */
	public class MDILinearEffects extends MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
	{
		override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point=null):Effect
		{
			var seq:Sequence = new Sequence();
			
			var resizeW:Resize = new Resize(window);
			resizeW.widthTo = window.minWidth;
			resizeW.duration = 100;
			seq.addChild(resizeW);
			
			var resizeH:Resize = new Resize(window);
			resizeH.heightTo = window.minimizeHeight;
			resizeH.duration = 100;
			seq.addChild(resizeH);
			
			var moveX:Move = new Move(window);
			moveX.xTo = moveTo.x;
			moveX.duration = 100;
			seq.addChild(moveX);
			
			var moveY:Move = new Move(window);
			moveY.yTo = moveTo.y;
			moveY.duration = 100;
			seq.addChild(moveY);
			
			seq.end();
			return seq;
		}
		
		override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var seq:Sequence = new Sequence();	
			
			var moveY:Move = new Move(window);
			moveY.yTo = restoreTo.y;
			moveY.duration = 100;
			seq.addChild(moveY);
			
			var moveX:Move = new Move(window);
			moveX.xTo = restoreTo.x;
			moveX.duration = 100;
			seq.addChild(moveX);
			
			var resizeW:Resize = new Resize(window);
			resizeW.widthTo = restoreTo.width;
			resizeW.duration = 100;
			seq.addChild(resizeW);
			
			var resizeH:Resize = new Resize(window);
			resizeH.heightTo = restoreTo.height;
			resizeH.duration = 100;
			seq.addChild(resizeH);
			
			seq.end();
			return seq;
		}
		
		override public function getWindowRestoreMinimizedEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var seq:Sequence = new Sequence();	
			
			var moveY:Move = new Move(window);
			moveY.yTo = restoreTo.y;
			if (manager.mdiApplication.barPossition == MDIApplication.TOP_POSITON){
				moveY.yFrom=0;
			}else if (manager.mdiApplication.barPossition == MDIApplication.BOTTON_POSITON){
				moveY.yFrom=manager.mdiApplication._appBarHeight+manager.mdiApplication.container.height;
			}
			moveY.duration = 100;
			seq.addChild(moveY);
			
			var moveX:Move = new Move(window);
			moveX.xTo = restoreTo.x;
			moveX.duration = 100;
			seq.addChild(moveX);
			
			var resizeW:Resize = new Resize(window);
			resizeW.widthTo = restoreTo.width;
			resizeW.duration = 100;
			seq.addChild(resizeW);
			
			var resizeH:Resize = new Resize(window);
			resizeH.heightTo = restoreTo.height;
			resizeH.duration = 100;
			seq.addChild(resizeH);
			
			seq.end();
			return seq;
		}		
		
		override public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0):Effect
		{
			var seq:Sequence = new Sequence(window);
			
			var moveX:Move = new Move(window);
			moveX.xTo = 0;
			moveX.duration = 100;
			seq.addChild(moveX);
			
			var moveY:Move = new Move(window);
			moveY.yTo = 0;
			moveY.duration = 100;
			seq.addChild(moveY);
			
			var resizeW:Resize = new Resize(window);
			resizeW.widthTo = manager.container.width;
			resizeW.duration = 100;
			seq.addChild(resizeW);
			
			var resizeH:Resize = new Resize(window);
			resizeH.heightTo = manager.container.height - bottomOffset;
			resizeH.duration = 100;
			seq.addChild(resizeH);
			
			seq.end();
			return seq;
		}
		
		override public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			window.minWidth = window.minHeight = 1;
			
			var resize:Resize = new Resize(window);
			resize.widthTo = resize.heightTo = 1;
			resize.duration = 100;
			return resize;
		}		
	}
}