package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import entities.inventory.InventoryGrid;
import entities.inventory.Hardpoint;
import entities.inventory.ShipTemplate;
import entities.inventory.StatsView;

import model.dto.ItemDTO;

import model.consts.ItemTypeConsts;
import model.events.InventoryEvent;
import model.events.MenuEvent;
import model.proxy.PlayerProxy;

import nme.events.MouseEvent;
//import nme.filters.GlowFilter;

import org.events.EventManager;
import org.ui.Button;
import org.ui.TooltipButton;

class InventoryScene extends Scene
{
	private var backB:Button;
	private var em:EventManager;
	private var grid:InventoryGrid;
	private var template:ShipTemplate;

	override public function begin()
	{
		init();

		drawTemplate();

		drawInventory(PlayerProxy.cloneInstance().playerData.items); // direct reference
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);

		em.removeEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.removeEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);

		this.removeAll();
	}

	private function init()
	{
		backB = new Button(10, 10, {defaultImage: "gfx/menu/back.png", downImage: "gfx/menu/back_down.png", overImage: "gfx/menu/back_over.png"});

		//backB.filters = [new GlowFilter(0xFF0000)];

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		em = EventManager.cloneInstance();

		em.addEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
		em.addEventListener(InventoryEvent.UNEQUIP_ITEM, onUnequip);
	}

	private function drawTemplate()
	{
		template = new ShipTemplate(0, 25, PlayerProxy.cloneInstance().playerData.shipTemplate);

		add(template);

		addGraphic(new StatsView(), 0, 300, 110);
	}

	private function drawInventory(items:Array<ItemDTO>)
	{
		grid = new InventoryGrid(0, 450, items, 6, 10, 50, 50);

		add(grid);
	}

	private function onBack(e:MouseEvent)
	{
		// save player info to player proxy
		template.saveTemplate();

		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function onEquip(e:InventoryEvent)
	{
		if(template.hasAvailableHardpoint(e.data.type))
		{
			template.equipItem(e.data);
			grid.unequip(e.data);
		}
	}

	private function onUnequip(e:InventoryEvent)
	{
		grid.equip(e.data);
		template.unequipItem(e.data);
	}
}