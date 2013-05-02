package {
	import org.flixel.*;
	import flash.display.*;
	
	public class Shadows extends FlxSprite {				
		public function Shadows():void {
			super(0, 0);
			makeGraphic(R.map.width, R.map.height, 0x00000000);
			scrollFactor.x = scrollFactor.y = 1;
			blend = "overlay";
			dirty = true;
		}

		override public function draw():void {
			fill(0x00000000);
			
			// Render shadows on blocks
			for (var i:int; i < R.vertices.length; ++i) {
				renderShadows(new FlxPoint(R.light.x, R.light.y), R.vertices[i]);
			}
			
			// Render shadows on players
			var v:Array;
			if (R.player1) {
				v = new Array(new FlxPoint(R.player1.x + R.player1.width, R.player1.y),
					new FlxPoint(R.player1.x + R.player1.width, R.player1.y + R.player1.height),
					new FlxPoint(R.player1.x, R.player1.y + R.player1.height),
					new FlxPoint(R.player1.x, R.player1.y));
					
				renderShadows(new FlxPoint(R.light.x, R.light.y), v);
			}
			if (R.player2) {
				v = new Array(new FlxPoint(R.player2.x + R.player2.width, R.player2.y),
					new FlxPoint(R.player2.x + R.player2.width, R.player2.y + R.player2.height),
					new FlxPoint(R.player2.x, R.player2.y + R.player2.height),
					new FlxPoint(R.player2.x, R.player2.y));
					
				renderShadows(new FlxPoint(R.light.x, R.light.y), v);
			}
			
			// Line of sight
			var gfx:Graphics = FlxG.flashGfx;
    		gfx.clear();
			gfx.lineStyle(1, 0xAA0000, 1);			
			var begin:FlxPoint = new FlxPoint(R.player1.x + R.player1.width / 2, R.player1.y + 5);
			var mouse:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var end:FlxPoint = parallel2(begin, mouse);
			gfx.moveTo(begin.x, begin.y);
			gfx.lineTo(end.x, end.y);
			pixels.draw(FlxG.flashGfxSprite);
			
			super.draw();
		}
		
		public function renderShadows(source:FlxPoint, v:Array):void {
			var found:int = -1;
			var gfx:Graphics = FlxG.flashGfx;
    		gfx.clear();
			// Shadow fill
			gfx.lineStyle(1, 0x555555, 1);
			gfx.beginFill(0x555555, 1);
			
			for (var i:int = 0; i < v.length; ++i) {
				if (i == 0) found = -1;

				var iprev:int = (i - 1 >= 0) ? (i - 1) : (i - 1 + v.length);
				var inext:int = (i + 1 < v.length) ? (i + 1) : (i + 1 - v.length);
				
				// Arrays linking the source to the current, previous and next vertices
				var current:FlxPoint = parallel(v[i], source);
				var prev:FlxPoint = parallel(v[iprev], source);
				var next:FlxPoint = parallel(v[inext], source);
				
				// Cross product to know if shadows should be cast on current vertex
				if (found == -1) {
					// Found first casting point
					if (cross(current, next) * cross(current, prev) >= 0) {
						found = i;
						gfx.moveTo(v[i].x, v[i].y);
						gfx.lineTo(current.x, current.y);
					}
				}
				else {
					// Found second casting point
					if (cross(current, next) * cross(current, prev) >= 0) {
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
			
			// Add player			
			for (var j:int = 0; j < R.map.heightInTiles; ++j) {
				for (var i:int = 0; i < R.map.widthInTiles; ++i) {
					var count:int = 0;
					
					// Count solid neighbors
					if (R.map.getTileByIndex(j * R.map.widthInTiles + i + 1)) count++;
					if (R.map.getTileByIndex(j * R.map.widthInTiles + i - 1)) count++;
					if (R.map.getTileByIndex((j + 1) * R.map.widthInTiles + i)) count++;
					if (R.map.getTileByIndex((j - 1) * R.map.widthInTiles + i)) count++;
					
					// Add vertex to shadow casting
					if (R.map.getTileByIndex(j * R.map.widthInTiles + i) == 1 && count < 3) {
						var v:Array = new Array(new FlxPoint(i * R.size + R.size, j * R.size),
									new FlxPoint(i * R.size + R.size, j * R.size + R.size),
									new FlxPoint(i * R.size, j * R.size + R.size),
									new FlxPoint(i * R.size, j * R.size));
									
						R.vertices.push(v);
					}
				}
			}
		}
		
		public function cross(a:FlxPoint, b:FlxPoint):Number {
			return (a.x * b.y - a.y * b.x);
		}
		
		public function parallel(a:FlxPoint, b:FlxPoint):FlxPoint {
			return new FlxPoint(a.x + 100 * (a.x - b.x), a.y + 100 * (a.y - b.y));
		}
		
		public function parallel2(a:FlxPoint, b:FlxPoint):FlxPoint {
			return new FlxPoint(a.x - 100 * (a.x - b.x), a.y - 100 * (a.y - b.y));
		}
	}
}