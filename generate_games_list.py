#!/usr/bin/python3
# -*- coding: utf-8 -*-

# built-in modules
from json import loads, dump
from os import listdir
from urllib.request import urlopen

# pip modules
try:
    from rich import print
    from rich.traceback import install
    install()
except ImportError:
    pass


def http_get_dict(url: str) -> dict:
    return loads(urlopen(url, timeout=10).read())


class RobloxAPI:
    @staticmethod
    def getUniverseInfo(universeId: str):
        return http_get_dict(f"https://games.roblox.com/v1/games?universeIds={universeId}")

    @staticmethod
    def getUniversesIcon(universeIds: str, size: str = "512x512", imageFormat: str = "Png", isCircular: bool = False):
        return http_get_dict(f"https://thumbnails.roblox.com/v1/games/icons?universeIds={universeIds}&size={size}&format={imageFormat}&isCircular={isCircular}")

    @staticmethod
    def Get_Game_Details(placeId: str):
        return http_get_dict(f"https://www.roblox.com/places/api-get-details?assetId={placeId}")

    @staticmethod
    def Get_Game_Icons(placeIds: str, size: str = "512x512", imageFormat: str = "Png", isCircular: bool = False):
        return http_get_dict(f"https://thumbnails.roblox.com/v1/places/gameicons?placeIds={placeIds}&size={size}&format={imageFormat}&isCircular={isCircular}")


def main():
    out = []

    for file in listdir("games"):
        universeId = file.split(".")[0]
        print(str(universeId), end=" ", flush=True)

        UniverseInfo = RobloxAPI.getUniverseInfo(universeId)["data"][0]
        print('"'+UniverseInfo["name"]+'" ' +
              str(UniverseInfo["rootPlaceId"]), end=" ", flush=True)

        UniversesIcon = RobloxAPI.getUniversesIcon(universeId, "128x128")
        print(UniversesIcon["data"][0]["imageUrl"])

        out.append({
            "UniverseId": int(universeId),
            "Name": UniverseInfo["name"],
            "Icon": UniversesIcon["data"][0]["imageUrl"],
            "RootPlace": UniverseInfo["rootPlaceId"]
        })

    dump(out, open("games.json", "w"), indent=3)
    print()
    print("Final json:")
    print(out)


if __name__ == '__main__':
    main()
