#!/bin/bash
hadoop fs -rm -r -f /user/pengfei/tmp/dmlc/mushroom.fm.model

hadoop fs -put ../data/agaricus.txt.train /user/pengfei/tmp/dmlc/data
hadoop fs -put ../data/agaricus.txt.test /user/pengfei/tmp/dmlc/data

# submit to hadoop
../../dmlc-core/tracker/dmlc_yarn.py -n 5 --vcores 1 -q q_guanggao.q_adalg --ship-libcxx /usr/local/lib64 ./fm.dmlc data=hdfs:///user/pengfei/tmp/dmlc/data/agaricus.txt.train val_data=hdfs:///user/pengfei/tmp/dmlc/data/agaricus.txt.test model_out=hdfs:///user/pengfei/tmp/dmlc/mushroom.fm.model max_lbfgs_iter=50 nfactor=8 early_stop=10 "${*:3}"


# get the final model file
hadoop fs -get /user/pengfei/tmp/dmlc/mushroom.fm.model ./fm.model

../../dmlc-core/yarn/run_hdfs_prog.py ./fm.dmlc data=../data/agaricus.txt.test task=pred model_in=fm.model
../../dmlc-core/yarn/run_hdfs_prog.py ./fm.dmlc task=dump model_in=fm.model name_dump=weight.txt
