package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import entities.inventory.EntityGrid;
import entities.inventory.Hardpoint;

import model.dto.ItemDTO;

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
	private var items:Array<ItemDTO>;
	private var grid:EntityGrid;

	override public function begin()
	{
		backB = new Button(10, 10, {defaultImage: "gfx/menu/back.png", downImage: "gfx/menu/back_down.png", overImage: "gfx/menu/back_over.png"});

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		em = EventManager.cloneInstance();

		em.addEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.addEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);

		items = [
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 1"}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 2"}),
			new ItemDTO({assetPath: "gfx/arma.png", name:"Weapon 3"})
		];

		drawShipTemplate();
		drawInventory();
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);

		em.removeEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.removeEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);
	}

	private function drawShipTemplate() // receive template data
	{
		var ship:Image = new Image("gfx/ship.png");
		var entity:Entity = new Entity(100, 150);

		ship.scaleX = ship.scaleY = 3;
		entity.graphic = ship;

		add(entity);

		drawHardpoints([{name:"Hardpoint 1", assetPath: "gfx/hardpoint.png"}, {name:"Hardpoint 2", assetPath: "gfx/hardpoint.png"}]);
	}

	private function drawInventory()
	{
		drawInventoryHeader();
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

	private function drawInventoryHeader()
	{
		var weaponsButton:Button = new Button(5, 425, {defaultImage: "gfx/inventory/weapons.png", overImage: "gfx/inventory/weapons_hover.png", downImage: "gfx/inventory/weapons_down.png"});
		var enginesButton:Button = new Button(170, 425, {defaultImage: "gfx/inventory/engines.png", overImage: "gfx/inventory/engines_hover.png", downImage: "gfx/inventory/engines_down.png"});
		var utilityButton:Button = new Button(335, 425, {defaultImage: "gfx/inventory/utility.png", overImage: "gfx/inventory/utility_hover.png", downImage: "gfx/inventory/utility_down.png"});

		add(weaponsButton);
		add(enginesButton);
		add(utilityButton);

		grid = new EntityGrid(this, 3, 5, 100, 100);

		for(i in 0...items.length)
			grid.addItem(items[i]);

		weaponsButton.addListener(MouseEvent.CLICK, onWeaponsClick);
		enginesButton.addListener(MouseEvent.CLICK, onEnginesClick);
		utilityButton.addListener(MouseEvent.CLICK, onUtilityClick);
	}

	private function onBack(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function onEquip(e:InventoryEvent)
	{
		for(i in 0...hardpoints.length)
		{
			var h:Hardpoint = hardpoints[i];

			if(h.isAvailable())
			{
				h.mountItem(e.data);
				//grid.removeItem(e.data);
		
				grid.clearItems();
		
				items.remove(e.data);

				for(i in 0...items.length)
					grid.addItem(items[i]);

				return;
			}
		}
	}

	private function onUnequip(e:InventoryEvent)
	{
		items.push(e.data);

		grid.clearItems();

		for(i in 0...items.length)
			grid.addItem(items[i]);
	}

	private function onWeaponsClick(e:MouseEvent)
	{
		trace("weapons");
	}

	private function onEnginesClick(e:MouseEvent)
	{
		trace("engines");
	}

	private function onUtilityClick(e:MouseEvent)
	{
		trace("utility");
	}
}