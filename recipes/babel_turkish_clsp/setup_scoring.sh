
LIBDIR=${PWD}/../../scoring/
SMMLIB=${PWD}/../../scoring/smm_lib_py3/
PYLIBS=${PWD}/../../scoring/pylibs/ 

root=$(pwd -P) 

# -----------------
# :: SGE options ::
# -----------------

tmp_d="/export/a06/${USER}/tmp/"  # PLEASE SET THIS BY YOURSELF, THANKS
path_env=${root}/path.sh
# @CSLP
default="-q all.q -l ram_free=8G -sync yes"
temp="-q all.q -l ram_free=16G -sync yes"
long="-q all.q -l ram_free=24G -l 'arch=*64' -sync yes"

# @BUT
#default="-q all.q@@blade -l ram_free=8G -sync yes"
#temp="-q all.q@@blade -l ram_free=12G -sync yes"
#long="-q long.q@@blade -l ram_free=16G -sync yes"

# ------------------
# ::  Directories ::
# ------------------

corpus="babel_turkish_clsp"

eval_dir=${PWD}"/../../../../../EVAL"

exp_dir=${eval_dir}"/topics/${corpus}/exp/"

sge_cfg_f=${exp_dir}"sge_config.cfg"

data_dir=${PWD}"/data"

train_keys=${data_dir}"/train_docid.keys"
test_keys=${data_dir}"/test_docid.keys"

doc_dir=${eval_dir}"/topics/${corpus}/"

# --------------------------------------------------------------
# :: Vocabulary settings for generating 'Word x Doc' matrices ::
# --------------------------------------------------------------

# First entry should be words, because its the reference
sub_dirs=("words/" "phonemes/" "asr_phonemes/" "ali_phonemes/")  # add the sub dirs here
ngrams=(1 3 3 3)  # n-gram seq for the above sub_dirs
topNs=(a a a a)   # top N tokens as vocab, 'a' for all or int (ex: 5000)
refs=(0 1)        # which ones should be used as references for clustering

# -----------------------
# :: SMM configuration ::
# -----------------------

ubm_init=est  # init UBM with ML estimates or constants 'const'
reg_w=l2      # only L2 reg. for ivecs
lw=0.0001     # 0.0001 is probably good
reg_T=l1      # L1 reg. for bases is better than L2
lT=10.0       # vary it depending on the size of the vocab
ivec_dim=100  # ivec dimension 50 to 400, depending on vocab size and no. of docs
trn_iter=10   # no. of training iters 10 to 15
xtr_iter=3    # no. of extracting iters 3 to 5
w_chunks=50   # no. of chunks for parallel estimation on SGE

# ------------------------------
# :: Clustering configuration ::
# ------------------------------

K=10  # no. of clusters
