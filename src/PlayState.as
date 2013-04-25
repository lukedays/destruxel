package {
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		[Embed(source = "assets/tileset.png")] protected var Tileset:Class;
		[Embed(source = "assets/map.csv", mimeType = "application/octet-stream")] protected var Map:Class;
		
		public var _blocks:FlxGroup;
		
		override public function create():void {
			FlxG.flash(0xFF000000);
			
			addBlocks();
			spawnPlayer();
		}
		
		override public function update():void {
			super.update();
			
			// Collision logic
			FlxG.collide(Registry.player, _blocks);
		}
		
		protected function addBlocks():void {
			// Background
			add(new Background(0, 0, 0));
			
			// Boundaries
			var left:FlxTileblock = new FlxTileblock(0, 0, 1, 600);
			var right:FlxTileblock = new FlxTileblock(799, 0, 1, 600);
			var top:FlxTileblock = new FlxTileblock(0, 0, 799, 1);
			var bottom:FlxTileblock = new FlxTileblock(0, 599, 800, 1);
			
			// Map
			Registry.map = new FlxTilemap;
			Registry.map.loadMap(new Map, Tileset, 25, 25);
			
			// Add to collision group
			_blocks = new FlxGroup();
			_blocks.add(left);
			_blocks.add(right);
			_blocks.add(top);
			_blocks.add(bottom);
			_blocks.add(Registry.map);
			add(_blocks);
		}
		
		protected function spawnPlayer():void {
			Registry.player = new Player(400, 250);
			add(Registry.player);
		}
	}
}