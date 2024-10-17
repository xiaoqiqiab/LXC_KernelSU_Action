#!/bin/bash

RUNC_ADD_FILE=$1

# 读取整个文件内容
content=$(cat "$RUNC_ADD_FILE")

# 查找 'cfile->kn = kn;' 这一行的位置
cfile_kn_line=$(grep -n 'cfile->kn = kn;' "$RUNC_ADD_FILE" | cut -d ':' -f 1)

# 计算插入位置，跳过两行
insert_line=$(($cfile_kn_line + 2))

# 将文件内容分割成两部分：插入点之前和之后
head_content=$(echo "$content" | head -n $insert_line)
tail_content=$(echo "$content" | tail -n +$(($insert_line + 1)))

# 定义要插入的补丁内容
patch_content=$(cat <<EOF
        if (cft->ss && (cgrp->root->flags & CGRP_ROOT_NOPREFIX) && !(cft->flags & CFTYPE_NO_PREFIX)) {
                snprintf(name, CGROUP_FILE_NAME_MAX, "%s.%s", cft->ss->name, cft->name);
                kernfs_create_link(cgrp->kn, name, kn);
        }
EOF
)

# 将文件内容重新组合，并插入补丁
new_content="$head_content
$patch_content
$tail_content"

# 将新的内容写回到文件
echo "$new_content" > "$RUNC_ADD_FILE"

echo "补丁已成功应用到 $RUNC_ADD_FILE"