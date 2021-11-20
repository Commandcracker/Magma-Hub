#!/usr/bin/python3
# -*- coding: utf-8 -*-

# built-in modules
from json import loads, dump
from os   import listdir
from sys  import stdout

# pip modules
from rich import print
from rich.traceback import install
from urllib3 import PoolManager

install()
http = PoolManager()

class RobloxAPI(object):
    @staticmethod
    def getUniverseId(placeId: str):
        requests = http.request('GET', "https://api.roblox.com/universes/get-universe-containing-place?placeid="+str(placeId))
        return loads(requests.data)["UniverseId"]

    @staticmethod
    def getUniverseInfo(universeId: str):
        requests = http.request('GET', "https://api.roblox.com/universes/get-info?universeId="+str(universeId))
        return loads(requests.data)

    @staticmethod
    def getUniversesIcon(universeIds: str, size: str = "512x512", format: str = "Png", isCircular: bool = False):
        requests = http.request('GET', "https://thumbnails.roblox.com/v1/games/icons?universeIds="+str(universeIds)+"&size="+size+"&format="+format+"&isCircular="+str(isCircular))
        return loads(requests.data)

    @staticmethod
    def Get_Game_Details(placeId: str):
        requests = http.request('GET', "https://www.roblox.com/places/api-get-details?assetId="+str(placeId))
        return loads(requests.data)
    
    @staticmethod
    def Get_Game_Icons(placeIds: str, size: str = "512x512", format: str = "Png", isCircular: bool = False):
        requests = http.request('GET', "https://thumbnails.roblox.com/v1/places/gameicons?placeIds="+placeIds+"&size="+size+"&format="+format+"&isCircular="+str(isCircular))
        return loads(requests.data)

if __name__ == '__main__':
    out = []

    for file in listdir("games"):
        universeId = file.split(".")[0]
        print(str(universeId), end=" ")
        stdout.flush()

        UniverseInfo = RobloxAPI.getUniverseInfo(universeId)
        print('"'+UniverseInfo["Name"]+'" '+str(UniverseInfo["RootPlace"]), end=" ")
        stdout.flush()

        UniversesIcon = RobloxAPI.getUniversesIcon(universeId, "128x128")
        print(UniversesIcon["data"][0]["imageUrl"])

        out.append({
            "UniverseId": int(universeId),
            "Name": UniverseInfo["Name"],
            "Icon": UniversesIcon["data"][0]["imageUrl"],
            "RootPlace": UniverseInfo["RootPlace"]
        })

    dump(out, open("games.json", "w"), indent=3)
    print()
    print("Final json")
    print(out)
