# -*- coding: utf-8 -*-
# Author  : Marcio Katsumi Yamashita
#           marcio.yamashita@fugro.com
# Date    : 2020-02-11 08:38:29
# Goal    : Encode figure in txt file.

import base64

with open("bitmap.png", "rb") as image_file:
    encoded_string = base64.b64encode(image_file.read())

with open("logo.txt","wb") as fout:
    fout.write(encoded_string)
