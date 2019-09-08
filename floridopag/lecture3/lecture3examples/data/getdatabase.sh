#!/bin/bash

# This script fetches info from the API of www.thegamesdb.org
# Please read documentation at:
# http://wiki.thegamesdb.net/index.php/API_Introduction

curl 'http://thegamesdb.net/api/GetGamesList.php?platform=Nintendo+WII' > nintendowiigames.xml
