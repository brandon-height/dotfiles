# -*- mode: python -*-

import os
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
from enum import Enum

config = config  # type: ConfigAPI # noqa: F821
c = c  # type: ConfigContainer # noqa: F821

initial_start = c.tabs.background == False

if initial_start:
    # ui
    c.completion.scrollbar.width = 10
    c.tabs.position = 'top'
    c.tabs.show = 'multiple'
    c.tabs.favicons.show = "always"
    #c.tabs.width.indicator = 0
    c.tabs.title.format = '{title}'
    c.tabs.title.alignment = 'center'
    c.downloads.position = 'bottom'

    # behavior
    c.downloads.location.prompt = False
    c.hints.scatter = False
    c.hints.mode = "number"
    c.url.searchengines = {'DEFAULT': 'https://google.com/search?q={}' }
    c.input.insert_mode.auto_load = True
    c.input.insert_mode.auto_leave = False
    c.tabs.background = True
    c.auto_save.session = True
    c.auto_save.interval = 15000

    # binds
    config.bind('<Shift-i>', 'config-source')


c.url.start_pages = 'https://start.duckduckgo.com'
c.aliases = {
    'w': 'session-save',
    'q': 'quit',
    'wq': 'quit --save'
}



# mustache templated from current theme
theme = {
    'panel': {
        'height': 25,
    },

    'fonts': {
        'main': 'Roboto Mono Medium',
        'tab_bold': False,
        'tab_size': 12,
    },

    'colors': {
        'bg': {
            'normal': '#E3E3E3',
            'active': '#B9B9B9',
            'inactive': '#F7F7F7',
        },

        'fg': {
            'normal': '#464646',
            'active': '#525252',
            'inactive': '#464646',

            # completion and hints
            'match': '#0A0A0A',
        },
    }
}

# colors
colors = theme['colors']

def setToBG(colortype, target):
    config.set('colors.' + target, colors['bg'][colortype])

def setToFG(colortype, target):
    config.set('colors.' + target, colors['fg'][colortype])

def colorSync(colortype, setting):
    if setting.endswith('.fg'):
        setToFG(colortype, setting)
    elif setting.endswith('.bg'):
        setToBG(colortype, setting)
    elif setting.endswith('.top') or setting.endswith('.bottom'):
        setToFG(colortype, setting)
    else:
        setToFG(colortype, setting + '.fg')
        setToBG(colortype, setting + '.bg')

targets = {
    'normal' : [
        'statusbar.normal',
        'statusbar.command',
        'tabs.even',
        'tabs.odd',
        'hints',
        'downloads.bar.bg',
        ],

    'active' : [
        'tabs.selected.even',
        'tabs.selected.odd',
        'statusbar.insert',
        'downloads.stop',
        'prompts',
        'messages.warning',
        'messages.error',

        'completion.item.selected',

        'statusbar.url.success.http.fg',
        'statusbar.url.success.https.fg',

        'completion.category',
    ],

    'inactive' : [
        'completion.scrollbar',
        'downloads.start',
        'messages.info',
        'completion.fg',
        'completion.odd.bg',
        'completion.even.bg',

        'completion.category.border.top',
        'completion.category.border.bottom',
        'completion.item.selected.border.top',
        'completion.item.selected.border.bottom',
    ],

    'match' : [
        'completion.match.fg',
        'hints.match.fg',
    ]
}

for colortype in targets:
    for target in targets[colortype]:
        colorSync(colortype, target)

setToFG('active', 'statusbar.progress.bg')

config.set('hints.border', '1px solid ' + colors['fg']['normal'])

# tabbar
def makePadding(top, bottom, left, right):
    return { 'top': top, 'bottom': bottom, 'left': left , 'right': right }

# TODO improve this logic
# assume height of font is ~10px, pad top by half match panel height
surround = round((theme['panel']['height'] - 10) / 2)
c.tabs.padding = makePadding(surround,surround,8,8)
#c.tabs.indicator_padding = makePadding(0,0,0,0)

# fonts
c.fonts.monospace = theme['fonts']['main']

tabFont = str(theme['fonts']['tab_size']) + 'pt ' + theme['fonts']['main']
if theme['fonts']['tab_bold']:
    tabFont = 'bold '  + tabFont

c.fonts.tabs = tabFont

