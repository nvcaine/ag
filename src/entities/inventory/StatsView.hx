package entities.inventory;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Text;

import model.proxy.PlayerProxy;

class StatsView extends Graphiclist
{
	private var playerProxy:PlayerProxy;

	public function new()
	{
		super();

		init();

	}

	private function init()
	{
		playerProxy = PlayerProxy.cloneInstance();

		add(new Text("The template - " + "level " + playerProxy.level, 0, 0));
		add(new Text("Damage: 0", 0, 20));
		add(new Text("Attack speed: 0", 0, 40));
		add(new Text("Speed: 0", 0, 60));
		add(new Text("Armor: 0", 0, 80));
	}
}