#!/bin/bash

# JSON 파일 경로 (Terraform의 outputs.json)
OUTPUTS_JSON="../Terraform/output.json"

# SSH 키 경로 (사용자 환경에 맞게 수정)
SSH_KEY_PATH="~/Downloads/test.pem"

# Inventory 파일명
INVENTORY_FILE="inventory.ini"

# vars.yml 파일명
VARS_YML_FILE="./group_vars/all.yml"

# Ansible이 설치되어 있는지 확인
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible이 설치되지 않았습니다. 설치 후 다시 시도하세요."
    exit 1
fi

# jq가 설치되어 있는지 확인
if ! command -v jq &> /dev/null; then
    echo "❌ jq가 설치되지 않았습니다. 설치 후 다시 시도하세요."
    exit 1
fi

# .json이 존재하는지 확인
if [ ! -f "$OUTPUTS_JSON" ]; then
    echo "❌ $OUTPUTS_JSON 파일이 존재하지 않습니다. Terraform을 실행한 후 다시 시도하세요."
    exit 1
fi

# Infra 그룹
echo "[infra]" > "$INVENTORY_FILE"
jq -r '.ec2_mapped_by_name | to_entries[] | select(.key == "testnet-Infra" and .value.public_ip != null) | "\(.key) ansible_host=\(.value.public_ip) ansible_user=ubuntu ansible_ssh_private_key_file='"$SSH_KEY_PATH"'"' "$OUTPUTS_JSON" >> "$INVENTORY_FILE"
echo "" >> "$INVENTORY_FILE"  # 그룹 간 개행 추가

# Server 그룹 (BE, FE)
echo "[server]" >> "$INVENTORY_FILE"
jq -r '.ec2_mapped_by_name | to_entries[] | select((.key == "testnet-BE" or .key == "testnet-FE") and .value.public_ip != null) | "\(.key) ansible_host=\(.value.public_ip) ansible_user=ubuntu ansible_ssh_private_key_file='"$SSH_KEY_PATH"'"' "$OUTPUTS_JSON" >> "$INVENTORY_FILE"

# Inventory 생성 완료 메시지
echo "✅ inventory.ini 생성 완료"
cat "$INVENTORY_FILE"

# Ansible Ping 테스트 실행
echo "🔍 Ansible Ping 테스트 실행 중..."
ansible -i "$INVENTORY_FILE" all -m ping --ssh-extra-args="-o StrictHostKeyChecking=no"

# ✅ vars.yml 파일 업데이트 (IP 정보 반영)
echo "🔄 vars.yml 업데이트 중..."

# JSON에서 필요한 IP 정보 추출
INFRA_PUBLIC_IP=$(jq -r '.ec2_mapped_by_name."testnet-Infra".public_ip' "$OUTPUTS_JSON")
INFRA_PRIVATE_IP=$(jq -r '.ec2_mapped_by_name."testnet-Infra".private_ip' "$OUTPUTS_JSON")
BE_PUBLIC_IP=$(jq -r '.ec2_mapped_by_name."testnet-BE".public_ip' "$OUTPUTS_JSON")
BE_PRIVATE_IP=$(jq -r '.ec2_mapped_by_name."testnet-BE".private_ip' "$OUTPUTS_JSON")
FE_PUBLIC_IP=$(jq -r '.ec2_mapped_by_name."testnet-FE".public_ip' "$OUTPUTS_JSON")
FE_PRIVATE_IP=$(jq -r '.ec2_mapped_by_name."testnet-FE".private_ip' "$OUTPUTS_JSON")

# `vars.yml`이 없으면 새로 생성
if [ ! -f "$VARS_YML_FILE" ]; then
    touch "$VARS_YML_FILE"
fi

# 기존 키가 있으면 업데이트, 없으면 추가
update_or_add_key() {
    local key="$1"
    local value="$2"
    local file="$VARS_YML_FILE"

    # 키가 존재하면 값을 업데이트하고, 존재하지 않으면 추가
    if grep -q "^$key:" "$file"; then
        sed -i "s|^$key: .*|$key: \"$value\"|" "$file"
    else
        echo "$key: \"$value\"" >> "$file"
    fi
}

# vars.yml 업데이트
update_or_add_key "infra_public" "$INFRA_PUBLIC_IP"
update_or_add_key "infra_private" "$INFRA_PRIVATE_IP"
update_or_add_key "be_public" "$BE_PUBLIC_IP"
update_or_add_key "be_private" "$BE_PRIVATE_IP"
update_or_add_key "fe_public" "$FE_PUBLIC_IP"
update_or_add_key "fe_private" "$FE_PRIVATE_IP"

echo "✅ vars.yml 업데이트 완료"
cat "$VARS_YML_FILE"

# 결과 출력 완료
echo "✅ Ansible Ping 테스트 및 vars.yml 업데이트 완료"