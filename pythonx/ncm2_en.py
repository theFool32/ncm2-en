# -*- coding: utf-8 -*-

import vim
import json
from ncm2 import Ncm2Source, getLogger
import re
from copy import deepcopy

logger = getLogger(__name__)


class Source(Ncm2Source):

    def on_warmup(self):
        path = '/'.join(__file__.split('/')[:-1])
        with open(path + '/en-cn-dict.json', 'r') as f:
            self.dict = json.load(f)
        self.words = self.dict.keys()

    def on_complete(self, ctx):
        c_str = ctx['base']
        prefix = c_str.lower()
        length = len(c_str)
        words = filter(lambda w: w.startswith(prefix), self.words)
        matches = [{
            'word': c_str + w[length:],
            'menu': self.dict[w]['description']
        } for w in words]
        self.complete(ctx, ctx['startccol'], matches)



source = Source(vim)

on_complete = source.on_complete
on_warmup = source.on_warmup
