#!/bin/python


import time

import whois


def cleanRegistar(registrar):

    MM_alias=[
        "Markmonitor Inc. [Tag = MARKMONITOR]".capitalize(),
        "MarkMonitor Inc.".capitalize(),
        "MarkMonitor, Inc.".capitalize(),
        "MarkMonitor International Limited".capitalize()
    ]

    CSC_alias=[
        "CSC CORPORATE DOMAINS INC.".capitalize(),
        "CSC Corporate Domains, Inc.".capitalize(),
        "CSC Corporate Domains Inc".capitalize(),
        "Ascio Technologies, Inc.".capitalize(),
        "Ascio Technologies, Inc".capitalize(),
        "CSC Corporate Domains, Inc. ( https://nic.at/registrar/533 )".capitalize(),
        "NetNames".capitalize(),
        "Communigal Communication Ltd".capitalize(),
        "Gabia, Inc.(http://www.gabia.co.kr)".capitalize(),
        "CSC Corporate Domains, Inc [Tag = CSC-CORP-DOMAINS]".capitalize(),
        "NIC Chile".capitalize()
    ]





    if registrar == None:
        return "UNKNOWN"

    if "registrar" in registrar.keys() and registrar["registrar"] == None:
        return "UNKNOWN"

    if "registrar" not in registrar.keys() and "CSC".capitalize() in registrar["name"].capitalize():
        return "CSC"
    
    if registrar["registrar"].capitalize() in MM_alias:
        return "Markmonitor"

    if registrar["registrar"].capitalize() in CSC_alias:
        return "CSC"
    print(registrar)
    return "WAT"




def clean(data):
    try:
        if data == None:
            return "None"
        if "registrar" not in data.keys():
            print(">>>NO registrar listed")
            print(data)
            return "UNKNOWN"
        
        if data["registrar"] == None:
            print(">>>EMPTY registrar listed")
            return "EMPTY"
        
        if "CSC".capitalize() in data["registrar"].capitalize():
            return "CSC"
        if "ASCIO".capitalize() in data["registrar"].capitalize():
            return "CSC"
        if "NETNAMES".capitalize() in data["registrar"].capitalize():
            return "CSC"
        if "Corporation Service Company".capitalize() in data["registrar"].capitalize():
            return "CSC"
        

        if "Markmonitor".capitalize() in data["registrar"].capitalize():
            return "Markmonitor"

        #look at nameservers if netmanes its CSC
        if  "netnames".capitalize() in "-".join(data["name_servers"]).capitalize():
            return "CSC"

        print(">>> unknown " + str(data))
        return data["registrar"]
    except:
        return "ERROR"

file = open('alldomains.txt')

fout= open("registars.csv","w")
for line in file:
    try:
        w = whois.whois(line.strip())

        outline=line.strip()+" : "+clean(w)

        fout.write(outline +"\n")
        fout.flush()
        print(outline )
        time.sleep(4)
    except:
        print("############################### "+line.strip()+" NEEDS RETRYED")
        outline=line.strip()+" : RETRY!"
        fout.write(outline +"\n")
        fout.flush()
        print(outline )
        time.sleep(60)

# w = whois.whois('cimpress.be')
# print(w)
# time.sleep(1)
# print(w["registrar"])
# print(w["name_servers"])
