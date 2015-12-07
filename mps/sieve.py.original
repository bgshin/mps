import json
import logging
import logging.config
import os
import sys
import types


from collections import defaultdict

import conll
import coreference
import coref_resolver
import coref_rules
import dictionaries
import mention_detector
import post_processing
import logging_config

def load_data(config):
    data = conll.load_data(config['general']['data_dir'],
                                config['general']['suffix'])
    print len(data)


class CoreferenceSystem:
    def __init__(self, config):
        self.config=config

    def write_docs(self):
        print conll.write(self.data, self.config['general']['output'])

    def evaluate_coref(self):
        print coref_resolver.evaluate(self.data,
                                self.config['evaluation'],
                                self.config['tracking'])

    def evaluate_extracted_mentions(self):
        print mention_detector.evaluate(self.data,
                                      self.config['evaluation'],
                                      self.config['tracking'])

    def do_post_processing(self):
        print post_processing.do(self.data,
                               self.config['post_processing'])

    def try_coref(self):
        print coref_resolver.try_coref(
                self.data, self.config['passes'], self.config['params'])

    def check_ordered_mentions(self):
        # Check all mentions are in tree-traversal order
        data = self.data
        for doc in data:
            for part in data[doc]:
                sents = data[doc][part]['text']
                trees = data[doc][part]['parses']
                heads = data[doc][part]['heads']
                for i in xrange(len(sents)):
                    sent_ments = data[doc][part]['doc_mentions'][i]
                    idx = 0
                    tree_order = {}
                    for node in trees[i]:
                        tree_order[node.span] = idx
                        idx += 1
                    prev_idx = -1
                    for ment in sent_ments:
                        print True if (ment[0] == i) else False
                        span = (ment[1], ment[2])
                        idx = -1
                        if span in tree_order:
                            idx = tree_order[span]
                        else:
                            head_span, head_word, head_pos = \
                                coreference.mention_head(
                                    ment, sents, trees, heads)
                            idx = tree_order[head_span]
                        print True if (idx >= prev_idx) else False
                        prev_idx = idx

    def extract_all_mentions(self):
        mention_detector.extract_all_mentions(self.data, self.config['params'])
        mention_detector.count_non_constituent_names(self.data)

    def check_data(self):
        data = self.data
        for doc in data:
            for part in data[doc]:
                sents = data[doc][part]['text']
                trees = data[doc][part]['parses']
                heads = data[doc][part]['heads']
                for s_i in xrange(len(sents)):
                    print True if isinstance(type(sents[s_i]), types.ListType) else False
                    print True if isinstance(type(trees[s_i]), types.InstanceType) else False
                    print True if isinstance(type(heads[s_i]), types.DictType) else False

                names = data[doc][part]['ner']
                mentions = data[doc][part]['mentions']
                clusters = data[doc][part]['clusters']
                speakers = data[doc][part]['speakers']
                print True if isinstance(type(names), types.DictType) else False
                print True if isinstance(type(mentions), types.DictType) else False
                print True if isinstance(type(clusters), defaultdict) else False
                print True if isinstance(type(speakers), defaultdict) else False

    def load_data(self):
        self.data = conll.load_data(self.config['general']['data_dir'],
                                    self.config['general']['suffix'])
        print True if 0 == len(self.data) else False

    def load_dict(self):
        print dictionaries.init(self.config['dict_files'])

    def verify_passes(self):
        print  coref_rules.verify_passes(self.config['passes'])

    def runTest(self):
        self.verify_passes()
        self.load_dict()
        self.load_data()
        self.check_data()
        self.extract_all_mentions()
        self.check_ordered_mentions()
        self.try_coref()
        self.do_post_processing()
        self.evaluate_extracted_mentions()
        self.evaluate_coref()
        self.write_docs()


if __name__ == '__main__':
    print('hello')


    logging.config.dictConfig(logging_config.LOGGING)
    MY_ARGS = sys.argv[1:]
    del sys.argv[1:]
    print MY_ARGS[0]
    config = json.load(open(MY_ARGS[0]))
    print config
    print coref_rules.verify_passes(config['passes'])
    # load_data(config)

    coref = CoreferenceSystem(config)

    coref.runTest()
    # unittest.main()
