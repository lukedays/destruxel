package {
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		[Embed(source = "assets/tileset.png")] protected var Tileset:Class;
		[Embed(source = "assets/map.csv", mimeType = "application/octet-stream")] protected var Map:Class;
		
		protected var _blocks:FlxGroup;
		
		override public function create():void {
			FlxG.flash(0xff000000);
			FlxG.mouse.show();
			
			//
			addEnvironment();
			spawnPlayer();
		}
		
		override public function update():void {
			// Collision logic
			FlxG.collide(R.player, _blocks);
			
			//
			if (FlxG.mouse.justPressed()) {
				var type:int;
				if (FlxG.keys.SHIFT) type = 1;
				else type = 0;
				R.bullets.fire(FlxG.mouse.x, FlxG.mouse.y, type);
			}
			
			super.update();
		}
		
		protected function addEnvironment():void {
			// Background
			add(new Background(0, 0, 0));
			
			// Boundaries
			var left:FlxTileblock = new FlxTileblock(0, 0, 1, FlxG.height);
			var right:FlxTileblock = new FlxTileblock(FlxG.width - 1, 0, 1, FlxG.height);
			var top:FlxTileblock = new FlxTileblock(0, 0, FlxG.width, 1);
			var bottom:FlxTileblock = new FlxTileblock(0, FlxG.height - 1, FlxG.width, 1);
			
			// Map
			R.map = new FlxTilemap;
			R.map.loadMap(new Map, Tileset, R.size, R.size);
			
			// Other features
			R.darkness = new FlxSprite(0, 0);
			R.darkness.makeGraphic(FlxG.width, FlxG.height, 0xff222222);
			R.darkness.scrollFactor.x = R.darkness.scrollFactor.y = 0;
			R.darkness.blend = "multiply";
			
			R.light = new Light(FlxG.width / 2, 0);
			
			R.bullets = new BulletManager();
			
			R.emitter = new FlxEmitter(0, 0, 20);
			R.emitter.bounce = 0.5;
			R.emitter.gravity = 800;
			
			for (var i:int = 0; i < 20; i++) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xff72651e);
				particle.exists = false;
				R.emitter.add(particle);
			}
			
			// Add to collision group
			_blocks = new FlxGroup();
			_blocks.add(left);
			_blocks.add(right);
			_blocks.add(top);
			_blocks.add(bottom);
			_blocks.add(R.map);
			
			add(_blocks);
			add(R.light);
			add(R.darkness);
			add(R.bullets);
			add(R.emitter);
		}
		
		override public function draw():void {
			R.darkness.fill(0xff222222);
			super.draw();
		}
		
		protected function spawnPlayer():void {
			R.player = new Player(FlxG.width / 2, FlxG.height / 3);
			add(R.player);
		}
	}
}