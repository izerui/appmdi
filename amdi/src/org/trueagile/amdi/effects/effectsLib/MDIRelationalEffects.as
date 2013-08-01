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
	import flash.geom.Point;
	
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.effects.MDIEffectsDescriptorBase;
	import org.trueagile.amdi.managers.MDIManager;
	
	import mx.effects.Effect;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	
	import mx.events.EffectEvent;
	import mx.effects.Move;
	import flash.geom.Rectangle;
	
	public class MDIRelationalEffects extends MDIVistaEffects
	{
		override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point=null):Effect
		{
			
			var parallel:Parallel = super.getWindowMinimizeEffect(window,manager,moveTo) as Parallel;
			
			parallel.addEventListener(EffectEvent.EFFECT_END, function():void {manager.tile(true, 10); } );
			
			
			return parallel;
		}
		
		override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var parallel:Parallel = super.getWindowRestoreEffect(window, manager, restoreTo) as Parallel;
			
			parallel.addEventListener(EffectEvent.EFFECT_START, function():void {manager.tile(true, 10); } );
			
			return parallel;
		}
		
		override public function getWindowRestoreMinimizedEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var parallel:Parallel = super.getWindowRestoreMinimizedEffect(window, manager, restoreTo) as Parallel;
			
			parallel.addEventListener(EffectEvent.EFFECT_START, function():void {manager.tile(true, 10); } );
			
			return parallel;
		}		
		
		override public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point):Effect
		{
			var move:Move = super.reTileMinWindowsEffect(window, manager, moveTo) as Move;
			manager.bringToFront(window);
			return move;
		}
		
		
		
	}
}