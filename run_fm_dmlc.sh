#!/bin/bash

[ ! -f data ] || mkdir data
function run_fm()
{
    trap "log error 'run_fm failed'" ERR 
    log checkpoint "[date $dt] run_fm start "

    weight_output=/team/ad_wajue/chenlongzhen/dmlcweight

    hadoop fs -mkdir -p ${weight_output} | echo "mkdir ${weight_output}"
    hadoop fs -rm -r -f ${weight_output}/* | echo "rmr ${weight_output}"

    ./dmlc-core/tracker/dmlc_yarn.py  \
        -n 3 \
        -q q_ad.q_adalg \
        --jobname FM_clz_test \
        --vcores 3 \
        -mem 20000 \
        --ship-libcxx /data/guanggao/gcc-4.8.2/lib64 \
        ./src/lbfgs-fm/fm.dmlc \
        nthread=3 \
        data=viewfs:///team/ad_wajue/chenlongzhen/data/agaricus.txt.train \
        val_data=viewfs:///team/ad_wajue/chenlongzhen/data/agaricus.txt.test \
        task=train \
        nfactor=20 \
        size_memory=8000 \
        objective=logistic \
        reg_L1=1 \
        reg_L2=1 \
        fm_random=0.01 \
        early_stop=5 \
        name_dump=viewfs:///team/ad_wajue/chenlongzhen/data/dump.txt \
        lbfgs_stop_tol=1e-7 \
        max_lbfgs_iter=20 \
        model_out=viewfs:///team/ad_wajue/chenlongzhen/data/dmlcfm

    log checkpoint "[date $dt] run_fm done "
	#hadoop fs -cp -r $weight_output ${weight_output}_old
        #model.weight=viewfs:///team/ad_wajue/chenlongzhen/dmlcweight/dmlcfm_V20 
}

##===================================Start Run Scripts Here================================
run_fm
