# Matser Node

export NUPLAN_DATA_ROOT="/home/user001/data/data_nuplan/data/cache"
# export NUPLAN_DATA_ROOT="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset"
export NUPLAN_MAPS_ROOT="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset/maps"
export NUPLAN_EXP_ROOT="/home/user002/code/nuplan-devkit-v1.1-ours/nuplan/exp"
export NUPLAN_DB_FILES="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset/nuplan-v1.1/mini"
export NUPLAN_MAP_VERSION="nuplan-maps-v1.0"

# for ray distributed claster

# export ip_head="114.214.170.120"
# export redis_password=""
# export num_nodes="2"

export MASTER_ADDR="114.214.170.120"
export MASTER_PORT="1234"
export NODE_RANK="0"
export NUM_NODES="2"
export CUDA_VISIBLE_DEVICES="0,1"
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=enp
export NCCL_IB_DISABLE=1

# Slave Node

export NUPLAN_DATA_ROOT="/home/user001/data/data_nuplan/data/cache"
# export NUPLAN_DATA_ROOT="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset"
export NUPLAN_MAPS_ROOT="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset/maps"
export NUPLAN_EXP_ROOT="/home/user002/code/nuplan-devkit-nuplan-devkit-v1.1/nuplan/exp"
export NUPLAN_DB_FILES="/home/user001/Code/nuplan-devkit-v1.1-ours/nuplan/dataset/nuplan-v1.1/mini"
export NUPLAN_MAP_VERSION="nuplan-maps-v1.0"
export MASTER_ADDR="114.214.170.120"
export MASTER_PORT="1234"
export NODE_RANK="1"

