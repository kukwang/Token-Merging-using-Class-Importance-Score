# ====================================
# For token merge
# ====================================

pth_diff=esoc

# vits
# vit_base_patch16_224.orig=None

# datasets
imagenet=/home/esoc/repo/ILSVRC/Data/CLS-LOC
imagenet_sample=/home/esoc/repo/ILSVRC/Data/CLS-LOC/val/n02190166/ILSVRC2012_val_00014356.JPEG

## models
# deits
deit_tiny_patch16_224=/home/${pth_diff}/kwangsoo/paper_codes/my_paper/pretrained/deit_tiny_patch16_224-a1311bcf.pth
deit_small_patch16_224=/home/${pth_diff}/kwangsoo/paper_codes/my_paper/pretrained/deit_small_patch16_224-cd65a155.pth
deit_tiny_distilled_patch16_224=/home/${pth_diff}/kwangsoo/paper_codes/my_paper/pretrained/deit_tiny_distilled_patch16_224-b40b3cf7.pth
deit_small_distilled_patch16_224=/home/${pth_diff}/kwangsoo/paper_codes/my_paper/pretrained/deit_small_distilled_patch16_224-649709d9.pth
deit_base_patch16_224=None
# swins
swin_tiny_patch4_window7_224=None
swin_small_patch4_window7_224=None
swin_base_patch4_window7_224=None
# lvvit
lvvit_tiny_224=None
# regnety
regnety_160=None

# parameters
pretrained_download_pth=/home/${pth_diff}/kwangsoo/paper_codes/pretrained/baseline
batch_size=512
epochs=30

log_dir=./logs/tb_logs/deit_s_mine_r13_30ep
save_path=./save/test/deit_s_mine_r13_30ep

# pretrained_local_pth=${deit_small_patch16_224}
model_name=deit_small_patch16_224

tome_r=13

# ================================================== script ==================================================

# # ============================================================================================================
# # 1gpu tome profiling
# CUDA_VISIBLE_DEVICES=1 python profiling.py --model_name ${model_name} \
# --data_path ${imagenet} --pt_dl ${pretrained_download_pth} --tome_r ${tome_r} \
# | tee profile_tome2_r${tome_r}.txt
# # ============================================================================================================

# # ============================================================================================================
epochs=30
# 1gpu finetuning

CUDA_VISIBLE_DEVICES=1 python main.py --model_name ${model_name} --batch_size ${batch_size} --epochs ${epochs} \
--data_path ${imagenet} --pt_dl ${pretrained_download_pth} --tome_r ${tome_r} \
--lr 2e-5 --min_lr 2e-6 --weight_decay 1e-6 --warmup_epochs 0 \
--save_path ${save_path} --log_dir ${log_dir} \
--use_amp True --dist_eval False \
| tee ${model_name}_mine_r${tome_r}_${epochs}ep.txt

# CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.launch --nproc_per_node=2 --use_env \

mv ${model_name}_mine_r${tome_r}_${epochs}ep.txt ./logs/tb_logs/deit_s_mine_r13_30ep

# | tee ${model_name}_myft_${epochs}_tome_r${tome_r}.txt

# --data_path ${imagenet} --pt_dl ${pretrained_download_pth} --tome_r ${tome_r} \
# --mixup 0 --cutmix 0 --smoothing 0
# --save_path ${save_path} --log_dir ${log_dir} 
# # ============================================================================================================