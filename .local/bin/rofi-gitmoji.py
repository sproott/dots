#!/usr/bin/env python3

import json
import os
import requests
import subprocess

def get_data_file() -> str:
    data_file_name = os.environ.get('XDG_DATA_HOME', os.environ['HOME'] + '/.local/share') + '/gitmojis.json'
    if not os.path.exists(data_file_name):
        r = requests.get('https://gitmoji.dev/api/gitmojis')
        file = open(data_file_name, 'wb')
        file.write(r.content)
        file.close()
    return open(data_file_name, 'r').read()


def main():
    if os.environ.get('ROFI_INFO'):
        subprocess.run(['xclip', '-selection', 'clipboard'], input = os.environ['ROFI_INFO'].encode(), stdout = subprocess.DEVNULL)
        return
    data_file = get_data_file()
    gitmojis = json.loads(data_file)['gitmojis']
    for gitmoji in gitmojis:
        print(gitmoji['emoji'] + ' ' + gitmoji['description'] + '\0info\x1f' + gitmoji['emoji'])


if __name__ == '__main__':
    main()
