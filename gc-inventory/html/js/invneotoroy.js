$.each(items, function (index, item) {
    count = setCount(item);
    $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
        '<a style="font-size:70%">'+item.weight/1000+ '/KG</a>'  +'<div class="item-count">' + count+ '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
    $('#item-' + index).data('item', item);
    $('#item-' + index).data('inventory', "main");
    numberitem = numberitem +1;
});

$("#playerInventory").html("");
    var numberitem = 0;
    var itemInventory = $(this).data("inventory");
    $.each(items, function (index, item) {
        count = setCount(item);
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
        '<p style="font-size:70%;color:white;">' + count +'('+item.weight/1000+ ')'+ '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
        numberitem = numberitem +1;
    });




    $.each(items, function (index, item) {
        count = setCount(item);
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
        '<p style="font-size:70%;color:white;">' + count +'('+item.weight/1000+ ')'+ '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
        numberitem = numberitem +1;
    });