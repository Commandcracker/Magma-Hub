import json
import os
import requests
from rich.pretty import pprint

def Get_Game_Details(placeId: int):
    return requests.get("https://www.roblox.com/places/api-get-details?assetId="+str(placeId)).json()

def Get_Game_Icons(placeIds: str, size: str = "512x512", format: str = "Png", isCircular: bool = False):
    return requests.get("https://thumbnails.roblox.com/v1/places/gameicons?placeIds="+placeIds+"&size="+size+"&format="+format+"&isCircular="+str(isCircular)).json()

out = []

for file in os.listdir("games"):
    placeId     = file.split(".")[0]
    name        = Get_Game_Details(placeId)["Name"]
    imageUrl    = Get_Game_Icons(placeId,"128x128")["data"][0]["imageUrl"]

    out.append([placeId, name, imageUrl])

json.dump(out, open("games.json", "w"), indent=3)
print("Final json")
pprint(out)
