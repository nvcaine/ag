package entities.inventory;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Text;

import model.consts.ItemTypeConsts;
import model.dto.HardpointDTO;
import model.dto.WeaponDTO;
import model.proxy.PlayerProxy;

class StatsView extends Entity
{
	private var playerProxy:PlayerProxy;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		playerProxy = PlayerProxy.cloneInstance();

		init();
	}

	public function updateStats()
	{
		init();
	}

	private function init()
	{
		var g:Graphiclist = new Graphiclist();

		g.add(new Text("The template - " + "level " + playerProxy.level, 0, 0));
		g.add(new Text("Damage: " + getDPS(playerProxy.playerData.shipTemplate.hardpoints), 0, 20));
		g.add(new Text("Speed: 0", 0, 60));
		g.add(new Text("Armor: 0", 0, 80));

		graphic = g;
	}

	private function getDPS(hardpoints:Array<HardpointDTO>):Float
	{
		var result:Float = 0;

		for(hardpoint in hardpoints)
			if(hardpoint.item != null && hardpoint.item.type == ItemTypeConsts.ITEM_WEAPON)
				result += Math.round(cast(hardpoint.item, WeaponDTO).damage / cast(hardpoint.item, WeaponDTO).fireDelay);

		return result;
	}
}