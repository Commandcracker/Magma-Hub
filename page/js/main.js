$.getJSON("games.json", function(data) {
    for (v in data) {
        $('#games').append(
            '<div class="game">\
                <img src="'+data[v][2]+'">\
                <a href="https://www.roblox.com/games/'+data[v][0]+'" target="_blank" rel="noopener noreferrer"><b>'+data[v][1]+'</b></a>\
            </div>'
        );
    }
});
