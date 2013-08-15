package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import entities.inventory.InventoryGrid;
import entities.inventory.Hardpoint;

import model.dto.ItemDTO;

import model.consts.ItemTypeConsts;
import model.events.InventoryEvent;
import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.Button;
import org.ui.TooltipButton;

class InventoryScene extends Scene
{
	private var backB:Button;
	private var em:EventManager;
	private var hardpoints:Array<Hardpoint>;
	private var grid:InventoryGrid;

	override public function begin()
	{
		init();

		drawShipTemplate();
		drawInventory([
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 1", type: ItemTypeConsts.ITEM_WEAPON}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 2", type: ItemTypeConsts.ITEM_WEAPON}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 3", type: ItemTypeConsts.ITEM_WEAPON}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Engine 1", type: ItemTypeConsts.ITEM_ENGINE}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Engine 2", type: ItemTypeConsts.ITEM_ENGINE}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Utility 1", type: ItemTypeConsts.ITEM_UTILITY})
		]);
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);

		em.removeEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.removeEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);
	}

	private function init()
	{
		backB = new Button(10, 10, {defaultImage: "gfx/menu/back.png", downImage: "gfx/menu/back_down.png", overImage: "gfx/menu/back_over.png"});

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		em = EventManager.cloneInstance();

		em.addEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.addEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);
	}

	private function drawShipTemplate() // receive template data
	{
		var ship:Image = new Image("gfx/ship.png");
		var entity:Entity = new Entity(100, 150);

		ship.scaleX = ship.scaleY = 3;
		entity.graphic = ship;

		add(entity);

		drawHardpoints([
			{name:"Hardpoint 1", assetPath: "gfx/hardpoint.png", type: ItemTypeConsts.ITEM_WEAPON},
			{name:"Hardpoint 2", assetPath: "gfx/hardpoint.png", type: ItemTypeConsts.ITEM_ENGINE}
		]);
	}

	private function drawHardpoints(hardpointsData:Array<Dynamic>)
	{
		hardpoints = [];

		for(i in 0...hardpointsData.length)
			drawHardpoint(100 + i * 100, 100 + i * 100, hardpointsData[i]);
	}

	private function drawHardpoint(x:Float, y:Float, data:Dynamic)
	{
		var hp:Hardpoint = new Hardpoint(x, y, data);

		hardpoints.push(hp);

		add(hp);
	}

	private function getAvailableHardpoint(type:String):Hardpoint
	{
		for(i in 0...hardpoints.length)
			if(hardpoints[i].isAvailable() && hardpoints[i].supports(type))
				return hardpoints[i];

		return null;
	}

	private function drawInventory(items:Array<ItemDTO>)
	{
		grid = new InventoryGrid(0, 450, items, 3, 5, 100, 100);

		add(grid);
	}

	private function onBack(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function onEquip(e:InventoryEvent)
	{
		var hardpoint:Hardpoint = getAvailableHardpoint(e.data.type);

		if(hardpoint == null)
			return;

		hardpoint.mountItem(e.data);
		grid.unequip(e.data);
	}

	private function onUnequip(e:InventoryEvent)
	{
		grid.equip(e.data);
	}
}