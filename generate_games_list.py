#!/usr/bin/python3
# -*- coding: utf-8 -*-

# built-in modules
from json import loads, dump
from os   import listdir

# pip modules
from rich import print
from rich.traceback import install
from urllib3 import PoolManager


class RobloxAPI(object):
    def __init__(self) -> None:
        self.http = PoolManager()

    def getUniverseId(self, placeId: str):
        requests = self.http.request('GET', "https://api.roblox.com/universes/get-universe-containing-place?placeid="+str(placeId))
        return loads(requests.data)["UniverseId"]

    def getUniverseInfo(self, universeId: str):
        requests = self.http.request('GET', "https://api.roblox.com/universes/get-info?universeId="+str(universeId))
        return loads(requests.data)

    def getUniversesIcon(self, universeIds: str, size: str = "512x512", imageFormat: str = "Png", isCircular: bool = False):
        requests = self.http.request('GET', "https://thumbnails.roblox.com/v1/games/icons?universeIds="+str(universeIds)+"&size="+size+"&format="+imageFormat+"&isCircular="+str(isCircular))
        return loads(requests.data)

    def Get_Game_Details(self, placeId: str):
        requests = self.http.request('GET', "https://www.roblox.com/places/api-get-details?assetId="+str(placeId))
        return loads(requests.data)
    
    def Get_Game_Icons(self, placeIds: str, size: str = "512x512", imageFormat: str = "Png", isCircular: bool = False):
        requests = self.http.request('GET', "https://thumbnails.roblox.com/v1/places/gameicons?placeIds="+placeIds+"&size="+size+"&format="+imageFormat+"&isCircular="+str(isCircular))
        return loads(requests.data)


def main():
    robloxAPI = RobloxAPI()
    out = []

    for file in listdir("games"):
        universeId = file.split(".")[0]
        print(str(universeId), end=" ", flush=True)

        UniverseInfo = robloxAPI.getUniverseInfo(universeId)
        print('"'+UniverseInfo["Name"]+'" '+str(UniverseInfo["RootPlace"]), end=" ", flush=True)

        UniversesIcon = robloxAPI.getUniversesIcon(universeId, "128x128")
        print(UniversesIcon["data"][0]["imageUrl"])

        out.append({
            "UniverseId": int(universeId),
            "Name": UniverseInfo["Name"],
            "Icon": UniversesIcon["data"][0]["imageUrl"],
            "RootPlace": UniverseInfo["RootPlace"]
        })

    dump(out, open("games.json", "w"), indent=3)
    print()
    print("Final json:")
    print(out)


if __name__ == '__main__':
    install()
    main()
