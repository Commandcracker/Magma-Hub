$.getJSON("games.json", function (data) {
    for (v in data) {
        $('#games').append(
            '<div class="game">\
                <img src="'+ data[v]["Icon"] + '">\
                <a href="https://www.roblox.com/games/'+ data[v]["RootPlace"] + '" target="_blank" rel="noopener noreferrer"><b>' + data[v]["Name"] + '</b></a>\
            </div>'
        );
    }
});
