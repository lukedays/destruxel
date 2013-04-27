package {
	import org.flixel.*;
	import flash.display.*;
	
	public class Shadows extends FlxSprite {				
		public function Shadows():void {
			super(0, 0);
			makeGraphic(FlxG.width, FlxG.height, 0x00000000);
			scrollFactor.x = scrollFactor.y = 1;
			blend = "normal";
			dirty = true;
		}

		override public function draw():void {
			fill(0x00000000);
			
			for (var i:int; i < R.vertices.length; ++i) {
				renderShadows(new FlxPoint(R.player.x, R.player.y), R.vertices[i]);
			}
			
			super.draw();
		}
		
		public function renderShadows(source:FlxPoint, v:Array):void {
			var gfx:Graphics = FlxG.flashGfx;
			var found:int = -1;
    		gfx.clear();
			// Shadow fill
			gfx.lineStyle(1, 0xbbbb88, 1);
			gfx.beginFill(0xbbbb88, 1);
			
			for (var i:int = 0; i < v.length; ++i) {
				if (i == 0) found = -1;
				
				var iprev:int = (i - 1 >= 0) ? (i - 1) : (i - 1 + v.length);
				var inext:int = (i + 1 < v.length) ? (i + 1) : (i + 1 - v.length);
				
				// Arrays linking the source to the current, previous and next vertices
				var current:FlxPoint = new FlxPoint(v[i].x + 20 * (v[i].x - source.x), v[i].y + 20 * (v[i].y - source.y));
				var prev:FlxPoint = new FlxPoint(v[iprev].x + 20 * (v[iprev].x - source.x), v[iprev].y + 20 * (v[iprev].y - source.y));
				var next:FlxPoint = new FlxPoint(v[inext].x + 20 * (v[inext].x - source.x), v[inext].y + 20 * (v[inext].y - source.y));
				
				// Cross product to know if shadows should be cast on current vertex
				if (found == -1) {
					// First casting point
					if ((current.x * next.y - current.y * next.x) * (current.x * prev.y - current.y * prev.x) >= 0) {
						found = i;
						gfx.moveTo(v[i].x, v[i].y);
						gfx.lineTo(current.x, current.y);
					}
				}
				else {
					// Second casting point
					if ((current.x * next.y - current.y * next.x) * (current.x * prev.y - current.y * prev.x) >= 0) {
						gfx.lineTo(current.x, current.y);
						gfx.lineTo(v[i].x, v[i].y);
						gfx.lineTo(v[found].x, v[found].y);
					}
				}
			}
			
			pixels.draw(FlxG.flashGfxSprite);
			gfx.endFill();
		}
		
		public function updateVertices():void {
			R.vertices = new Array();
			
			for (var j:int = 0; j < FlxG.height / R.size; ++j) {
				for (var i:int = 0; i < FlxG.width / R.size; ++i) {
					var count:int = 0;
					
					// Count solid neighbors
					if (R.map.getTileByIndex(j * FlxG.width / R.size + i + 1)) count++;
					if (R.map.getTileByIndex(j * FlxG.width / R.size + i - 1)) count++;
					if (R.map.getTileByIndex((j + 1) * FlxG.width / R.size + i)) count++;
					if (R.map.getTileByIndex((j - 1) * FlxG.width / R.size + i)) count++;
					
					// Add vertex to shadow casting
					if (R.map.getTileByIndex(j * FlxG.width / R.size + i) == 1 && count < 3) {
						var v:Array = new Array(new FlxPoint(i * R.size + R.size, j * R.size),
									new FlxPoint(i * R.size + R.size, j * R.size + R.size),
									new FlxPoint(i * R.size, j * R.size + R.size),
									new FlxPoint(i * R.size, j * R.size));
									
						R.vertices.push(v);
					}
				}
			}
		}
	}
}