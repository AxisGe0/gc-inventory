var type = "normal";
var disabled = false;
var disabledFunction = null;
var ownerHouse = null;
var coisas = [false, false, false, false, false]

function widthHeightSplit(value, ele) {
    let height = 25.5;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("height", eleHeight + "px");
    ele.css("top", leftOverHeight + "px");
};

window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        type = event.data.type
        disabled = false;

        if (type === "normal") {
            $(".weight-div").show();
            $(".info-div").hide();
			$("#noSecondInventoryMessage").hide();
            $("#otherInventory").hide();
            $("#boxSetHealth").css("width", event.data.health + "%");
            $("#boxSetArmour").css("width", event.data.armour + "%");
            $("#boxSetWeight").css("width", event.data.weight + "%");
            widthHeightSplit(event.data.hunger, $("#boxSetHunger"));
            widthHeightSplit(event.data.thirst, $("#boxSetThirst"));
            widthHeightSplit(event.data.oxygen, $("#boxSetOxygen"));
            widthHeightSplit(event.data.stress, $("#boxSetStress"));
        } else if (type === "trunk") {
            $(".info-div").show();
			$("#otherInventory").show();
            $(".weight-div").show();
        } else if (type === "property") {
            $(".info-div").hide();
			$("#otherInventory").show();
            $(".weight-div").hide();
			ownerHouse = event.data.owner;
        } else if (type === "player") {
            $(".info-div").show();
            $(".weight-div").show();
			$("#otherInventory").show();}
        else if (type === "shop") {
            $(".info-div").show();
            $(".weight-div").show();
            $("#otherInventory").show();
        } else if (type === "motels") {
            $(".info-div").show();
            $(".weight-div").show();
            $("#otherInventory").show();
        } else if (type === "motelsbed") {
            $(".info-div").show();
            $(".weight-div").show();
            $("#otherInventory").show();
        } else if (type === "glovebox") {
            $(".info-div").show();
            $(".weight-div").show();
            $("#otherInventory").show();
        } else if (type === "dumpster") {
            $(".info-div").show();
            $(".weight-div").show();
            $("#otherInventory").show();
        }

    $(".ui").fadeIn();
    }else if (event.data.action == "hide") {
        $("#dialog").dialog("close");
        $(".ui").fadeOut();
        $(".item").remove();
     //   $("#otherInventory").html("<div id=\"noSecondInventoryMessage\"></div>");
    //    $("#noSecondInventoryMessage").html(invLocale.secondInventoryNotAvailable);
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList,event.data.fastItems);
        $("#boxSetWeight").css("width", event.data.weight + "%");
        $('.item').draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
            start: function (event, ui) {
                if (disabled) {
                    return false;
                }
                $(this).css('background-image', 'none');
                itemData = $(this).data("item");
                itemInventory = $(this).data("inventory");
                if (itemInventory == "second") {
                    $("#drop").addClass("disabled");
                    $("#give").addClass("disabled");
                }
                if (itemInventory == "second" ) {
                    $("#use").addClass("disabled");
                }
            },
            stop: function () {
                itemData = $(this).data("item");

                if (itemData !== undefined && itemData.name !== undefined) {
                    $(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
                    $("#drop").removeClass("disabled");
                    $("#use").removeClass("disabled");
                    $("#give").removeClass("disabled");
                }
            }
        });

    } else if (event.data.action == "setSecondInventoryItems") {
        secondInventorySetup(event.data.itemList);
    }else if (event.data.action == "setShopInventoryItems") {
        shopInventorySetup(event.data.itemList)
    } else if (event.data.action == "setInfoText") {
        $(".info-div").html(event.data.text);
    } else if (event.data.action == "setWeightText") {
        $(".weight-div").html(event.data.text);
    }else if (event.data.action == "nearPlayers") {
        $("#dialog").dialog("close");
        //   player = $(this).data("player");
        $.post("http://gc-inventory/GiveItem", JSON.stringify({
            player: player,
            item: event.data.item,
            number: parseInt($("#count").val())
            }));
    }else if (event.data.action =="notification"){
        sendNotification(event.data.itemname, event.data.itemlabel , event.data.itemcount , event.data.itemremove)
    }else if (event.data.action == "showhotbar"){
        showHotbar(event.data.itemList, event.data.fastItems, event.data)
    };
});

function showHotbar(items, fastItems, data) {
    $("#playerInventoryHotbar").html("");
    $.each(items, function (index, item) {
        count = setCount(item);
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });

    $("#playerInventoryHotbar").fadeIn();
    setTimeout(function(){
        $("#playerInventoryHotbar").fadeOut();
    }, 6000);
    setTimeout(function(){
        $("#playerInventoryHotbar").html("");
    }, 8000);

    var i;
    for (i = 1; i < 6; i++) {
        $("#playerInventoryHotbar").append('<div class="slotFast"><div id="itemFast-' + i + '" class="item" >' +
            '<div class="keybind">' + i + '</div><div class="item-count"></div> <div class="item-name"></div> </div ><div class="item-name-bg"></div></div>');
    }

    $.each(fastItems, function (index, item) {
        count = setCount(item);
        $('#itemFast-' + item.slot).css("background-image", 'url(\'img/items/' + item.name + '.png\')');
        $('#itemFast-' + item.slot).html('<div class="keybind">' + item.slot + '</div><div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> <div class="item-name-bg"></div>');
        $('#itemFast-' + item.slot).data('item', item);
        $('#itemFast-' + item.slot).data('inventory', "fast");
    });
}

function sendNotification(item, itemlabel, count, remove){
    $("#notificacao").html("");
    $("#notificacao").fadeIn();
    if (remove){
        $("#notificacao").append('<div class="slot" style="background-color: rgba(255, 166, 0, 0)" id="noti"><div class="item2" style = "background-image: url(\'img/items/' + item + '.png\')">' +
        '<div class="item-count">-' + count + '</div> <div class="item-name">' + itemlabel + '</div> </div ><div class="item-name-bg"></div></div>');
     //   $("#notificacao").stop(true,true).fadeIn(500).delay(1500).fadeOut(500);
        setTimeout(function(){
            $("#notificacao").fadeOut();
        }, 1500);
    }
    else{
        $("#notificacao").append('<div class="slot" style="background-color: rgba(255, 166, 0, 0)" id="noti"><div class="item2" style = "background-image: url(\'img/items/' + item + '.png\')">' +
            '<div class="item-count">+' + count + '</div> <div class="item-name">' + itemlabel + '</div> </div ><div class="item-name-bg"></div></div>');
    //    $("#notificacao").stop(true,true).fadeIn(500).delay(1500).fadeOut(500);
        setTimeout(function(){
            $("#notificacao").fadeOut();
        }, 1500);
    }
}

function closeInventory() {
    $(".ui").fadeOut();
    $.post("http://gc-inventory/NUIFocusOff", JSON.stringify({}));
  
}

function inventorySetup(items, fastItems) {
    
    $("#playerInventory").html("");
    var numberitem = 0;
    var itemInventory = $(this).data("inventory");
    
    $.each(items, function (index, item) {
        count = setCount(item);
        Test = "item-name2";
        if (item.dura == 20) {
            Test = "item-health-10"
            Kutta = "item-name"
        }
        else if (item.dura == 19) {
            Test = "item-health-10"
            Kutta = "item-name"
        }
        else if (item.dura == 18) {
            Test = "item-health-9"
            Kutta = "item-name"
        }
        else if (item.dura == 17) {
            Test = "item-health-9"
            Kutta = "item-name"
        }
        else if (item.dura == 16) {
            Test = "item-health-8"
            Kutta = "item-name"
        }
        else if (item.dura == 15) {
            Test = "item-health-8"
            Kutta = "item-name"
        }
        else if (item.dura == 14) {
            Test = "item-health-7"
            Kutta = "item-name"
        }
        else if (item.dura == 13) {
            Test = "item-health-7"
            Kutta = "item-name"
        }
        else if (item.dura == 12) {
            Test = "item-health-6"
            Kutta = "item-name"
        }
        else if (item.dura == 11) {
            Test = "item-health-6"
            Kutta = "item-name"
        }
        else if (item.dura == 10) {
            Test = "item-health-5"
            Kutta = "item-name"
        }
        else if (item.dura == 9) {
            Test = "item-health-5"
            Kutta = "item-name"
        }
        else if (item.dura == 8) {
            Test = "item-health-4"
            Kutta = "item-name"
        }
        else if (item.dura == 7) {
            Test = "item-health-4"
            Kutta = "item-name"
        }
        else if (item.dura == 6) {
            Test = "item-health-3"
            Kutta = "item-name"
        }
        else if (item.dura == 5) {
            Test = "item-health-3"
            Kutta = "item-name"
        }
        else if (item.dura == 4) {
            Test = "item-health-2"
            Kutta = "item-name"
        }
        else if (item.dura == 3) {
            Test = "item-health-2"
            Kutta = "item-name"
        }
        else if (item.dura == 2) {
            Test = "item-health-1"
            Kutta = "item-name"
        }
        else if (item.dura == 1) {
            Test = "item-health-1"
            Kutta = "item-name"
        }
        else if (item.dura == 0) {
            Test = "item-destroyed"
            Kutta = "item-name"
        }
        if (item.dura == '') {
            Test = ""
        }
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
        '<p style="font-size:70%;color:white;">' + count +'('+item.weight/1000+ ')'+ '</div> <div class="item-dura">'+item.label+'</div> <div class="'+Test+'">'+ '<p>'+item.dura+'</p>' + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
        numberitem = numberitem +1;
    });

    var i
    for (i = 1; i < (51 - numberitem); i++) {
        $("#playerInventory").append('<div class="slot"><div id="item-' + i + '" class="item" style = "background-image: url(\'img/items/' + "blank" + '.png\')">' +
            '<div class="item-count"></div> <div class="item-name"> </div> </div ><div class="item-name-bg"></div></div>');
    }
    $("#playerInventoryFastItems").html("");

	for (i = 1; i < 6 ; i++) {
	  $("#playerInventoryFastItems").append('<div class="slotFast"><div id="itemFast-' + i + '" class="item" >' +
            '<div class="keybind">' + i + '</div><div class="item-count"></div> <div class="item-name"></div> </div ><div class="item-name-bg"></div></div>');
    }

    coisas = [false, false, false, false, false]

	$.each(fastItems, function (index, item) {
        count = setCount(item);
        Test = "item-name2";
        if (item.dura == 20) {
            Test = "item-health-10"
            Kutta = "item-name"
        }
        else if (item.dura == 19) {
            Test = "item-health-10"
            Kutta = "item-name"
        }
        else if (item.dura == 18) {
            Test = "item-health-9"
            Kutta = "item-name"
        }
        else if (item.dura == 17) {
            Test = "item-health-9"
            Kutta = "item-name"
        }
        else if (item.dura == 16) {
            Test = "item-health-8"
            Kutta = "item-name"
        }
        else if (item.dura == 15) {
            Test = "item-health-8"
            Kutta = "item-name"
        }
        else if (item.dura == 14) {
            Test = "item-health-7"
            Kutta = "item-name"
        }
        else if (item.dura == 13) {
            Test = "item-health-7"
            Kutta = "item-name"
        }
        else if (item.dura == 12) {
            Test = "item-health-6"
            Kutta = "item-name"
        }
        else if (item.dura == 11) {
            Test = "item-health-6"
            Kutta = "item-name"
        }
        else if (item.dura == 10) {
            Test = "item-health-5"
            Kutta = "item-name"
        }
        else if (item.dura == 9) {
            Test = "item-health-5"
            Kutta = "item-name"
        }
        else if (item.dura == 8) {
            Test = "item-health-4"
            Kutta = "item-name"
        }
        else if (item.dura == 7) {
            Test = "item-health-4"
            Kutta = "item-name"
        }
        else if (item.dura == 6) {
            Test = "item-health-3"
            Kutta = "item-name"
        }
        else if (item.dura == 5) {
            Test = "item-health-3"
            Kutta = "item-name"
        }
        else if (item.dura == 4) {
            Test = "item-health-2"
            Kutta = "item-name"
        }
        else if (item.dura == 3) {
            Test = "item-health-2"
            Kutta = "item-name"
        }
        else if (item.dura == 2) {
            Test = "item-health-1"
            Kutta = "item-name"
        }
        else if (item.dura == 1) {
            Test = "item-health-1"
            Kutta = "item-name"
        }
        else if (item.dura == 0) {
            Test = "item-destroyed"
            Kutta = "item-name"
        }
        if (item.dura == '') {
            Test = ""
        }
        coisas[index] = true
		$('#itemFast-' + item.slot).css("background-image",'url(\'img/items/' + item.name + '.png\')');
		$('#itemFast-' + item.slot).html('<div class="keybind">' + item.slot + '</div><div class="item-count">' + count +''+ '</div> <div class="item-dura">'+item.label+'</div> <div class="'+Test+'">'+ '<p>'+item.dura+'</p>'+'</div> <div class="item-name-bg"></div>');
        $('#itemFast-' + item.slot).data('item', item);
        $('#itemFast-' + item.slot).data('inventory', "fast");
    });

    makeDraggables()

    if(type === "normal" && itemInventory === "second"){
        $("#otherInventory").html("");
        for (i = 1; i < 151; i++) {
            $("#otherInventory").append('<div class="slot"><div id="item-' + i + '" class="item" style = "background-image: url(\'img/items/' + "blank" + '.png\')">' +
                '<div class="item-count"></div> <div class="item-name"> </div> </div ><div class="item-name-bg"></div></div>');
        }
    }
}

function makeDraggables(){
	$('#itemFast-1').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");
            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot : 1,
                }));
            }
        }
    });
	$('#itemFast-2').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                $.post("http://gc-inventory/PutIntoFast", JSON.stringify({

                    item: itemData,
                    slot : 2
                }));
            }
        }
    });
	$('#itemFast-3').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
               $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot : 3
                }));
            }
        }
    });
    $('#itemFast-4').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot : 4
                }));
            }
        }
    });
    $('#itemFast-5').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot : 5
                }));
            }
        }
    });
}

function secondInventorySetup(items) {
    $("#otherInventory").html("");
    var i;
    var numberitem = 0;
    $.each(items, function (index, item) {
        count = setCount(item);
        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
        numberitem = numberitem + 1;
    });
    for (i = 1; i < (151 - numberitem); i++) {
        $("#otherInventory").append('<div class="slot"><div id="item-' + i + '" class="item" style = "background-image: url(\'img/items/' + "blank" + '.png\')">' +
            '<div class="item-count"></div> <div class="item-name"> </div> </div ><div class="item-name-bg"></div></div>');
    }
}

function shopInventorySetup(items) {
    $("#otherInventory").html("");
    $.each(items, function (index, item) {
        //count = setCount(item)
        cost = setCost(item);
        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + cost + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function setCount(item) {
    count = item.count


    if (item.type === "item_weapon") {
        if (count == 0) {
            count = "";
        } else {
            count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.count;
        }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count)+'$';
    }

    return count;
}

function setCost(item) {
    cost = item.price
    if (item.price == 0){
        cost = item.price + "$"
    }
    if (item.price > 0) {
        cost = item.price + "$"
    }
    return cost;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });

    $(document).on('dblclick', '.item', function () {

        itemData = $(this).data("item");

        if (itemData == undefined || itemData.usable == undefined) {
            return;
        }

        itemInventory = $(this).data("inventory");

        if (itemInventory == undefined || itemInventory == "second") {
            return;
        }

        if (type === "normal" && itemInventory === "main" && itemData.usable) {
            if (itemData.name.includes(".")) {
                if (itemInventory === "fast") 
                {
                    for (i = 0; i < 5; i++) {
                        if (coisas[i] == false) {
                            $('#itemFast-' + itemData.slot).slideUp("slow", function() {});
                            coisas[i] = true
                            $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                                item: itemData,
                                slot : i+1
                            }));
                            break;
                        }
                    }
                } else {
                    coisas[itemData.slot-1] = false;
                    $.post("http://gc-inventory/TakeFromFast", JSON.stringify({
                        item: itemData
                    }));
                }
                
            } else {
                $.post("http://gc-inventory/UseItem", JSON.stringify({
                    item: itemData
                }));
                closeInventory();
            }
            
        }else {
            $(this).effect( "bounce", "slow");
        }

    });

    $(document).on('contextmenu', '.item', function (e) {
        itemData = $(this).data("item");

        itemInventory = $(this).data("inventory");
        if(e.shiftKey) {
            if (itemInventory === "second") {
                if (type === "trunk") {
                    $.post("http://gc-inventory/TakeFromTrunk", JSON.stringify({
    
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "property") {
                    $.post("http://gc-inventory/TakeFromProperty", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val()),
                        owner : ownerHouse
                    }));
                } else if (type === "dumpster") {
                    $.post("http://gc-inventory/TakeFromdumpster", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "player") {
                    $.post("http://gc-inventory/TakeFromPlayer", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "normal" && itemInventory === "fast") {
                    coisas[itemData.slot-1] = false;
                    $.post("http://gc-inventory/TakeFromFast", JSON.stringify({
                        item: itemData
                    }));
                } else if (type === "shop") {
                    $.post("http://gc-inventory/TakeFromShop", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
    
                } else if (type === "motels") {
                    $.post("http://gc-inventory/TakeFromMotel", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
    
                } else if (type === "motelsbed") {
                    $.post("http://gc-inventory/TakeFromMotelBed", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "glovebox") {
                    $.post("http://gc-inventory/TakeFromGlovebox", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                }
            } else if (itemInventory === "main") {
                if (type === "trunk") {
                    $.post("http://gc-inventory/PutIntoTrunk", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "property") {
                    $.post("http://gc-inventory/PutIntoProperty", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val()),
                        owner : ownerHouse
                    }));
                } else if (type === "dumpster") {
                    $.post("http://gc-inventory/PutIntodumpster", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "player") {
                    $.post("http://gc-inventory/PutIntoPlayer", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "motels") {
                    $.post("http://gc-inventory/PutIntoMotel", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }))
                } else if (type === "motelsbed") {
                    $.post("http://gc-inventory/PutIntoMotelBed", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                } else if (type === "glovebox") {
                    $.post("http://gc-inventory/PutIntoGlovebox", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                }
            } else {
                $(this).effect( "bounce", "slow");
            }
        } else {
            if (type === "normal" && itemInventory === "fast") {
                coisas[itemData.slot-1] = false;
                $.post("http://gc-inventory/TakeFromFast", JSON.stringify({
                    item: itemData
                }));
            }else if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
    
                for (i = 0; i < 5; i++) {
                    if (coisas[i] == false) {
                        $('#itemFast-' + itemData.slot).fadeOut();
                        coisas[i] = true
                        $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                            item: itemData,
                            slot : i+1
                        }));
                        break;
                    }
                }
            } else if (itemData.name !== undefined) {
                $(this).effect( "bounce", "slow");
            }
        }

    });

    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined || itemData.usable == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (type === "normal" && itemInventory === "main" && itemData.usable) {
                if (itemData.name.includes(".")) {
                    if (itemInventory === "fast") 
                    {
                        for (i = 0; i < 5; i++) {
                            if (coisas[i] == false) {
                                $('#itemFast-' + itemData.slot).slideUp("slow", function() {});
                                coisas[i] = true
                                $.post("http://gc-inventory/PutIntoFast", JSON.stringify({
                                    item: itemData,
                                    slot : i+1
                                }));
                                break;
                            }
                        }
                    } else {
                        coisas[itemData.slot-1] = false;
                        $.post("http://gc-inventory/TakeFromFast", JSON.stringify({
                            item: itemData
                        }));
                    }
                    
                } else {
                    $.post("http://gc-inventory/UseItem", JSON.stringify({
                        item: itemData
                    }));
                    closeInventory();
                }
                
            }else {
                $(this).effect( "bounce", "slow");
            }
        }
    });
    
    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {itemData = ui.draggable.data("item");

            itemInventory = ui.draggable.data("inventory");
             if (itemInventory == undefined || itemInventory == "second") {
                return;
            }
            if (itemInventory === "fast") {
                return;
            }
            $.post("http://gc-inventory/GiveItem", JSON.stringify({
                number: parseInt($("#count").val()),
                item: itemData
            }));
        //    };
        }
    });

    $('#drop').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            //       if (itemData == undefined || itemData.canRemove == undefined) {
            //           return;
            //       }

            itemInventory = ui.draggable.data("inventory");

            //       if (itemInventory == undefined || itemInventory == "second") {
            //            return;
            //      }
            if (itemInventory === "fast") {
                return;}
            // if (itemData.canRemove) {
            $.post("http://gc-inventory/DropItem", JSON.stringify({

                item: itemData,
                number: parseInt($("#count").val())
            }));
                //}
            }

    });

    $('#playerInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromTrunk", JSON.stringify({

                    item: itemData,
                    number: parseInt($("#count").val())
                }));

            } else if (type === "property" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromProperty", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val()),
					owner : ownerHouse
                }));

            } else if (type === "dumpster" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromdumpster", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }else if (type === "normal" && itemInventory === "fast") {
                coisas[itemData.slot-1] = false;
                $.post("http://gc-inventory/TakeFromFast", JSON.stringify({
                    item: itemData
                }));
            } else if (type === "shop" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromShop", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));

            } else if (type === "motels" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromMotel", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));

            } else if (type === "motelsbed" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromMotelBed", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "second") {
                $.post("http://gc-inventory/TakeFromGlovebox", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }

        }
    });

    $('#otherInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoTrunk", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "property" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoProperty", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val()),
					owner : ownerHouse
                }));
            } else if (type === "dumpster" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntodumpster", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "motels" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoMotel", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }))
            } else if (type === "motelsbed" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoMotelBed", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "main") {
                $.post("http://gc-inventory/PutIntoGlovebox", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $("#count").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function () {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});
