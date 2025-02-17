#!/bin/bash

# JSON 파일 경로 (Terraform의 outputs.json)
OUTPUTS_JSON="../Terraform/output.json"

# SSH 키 경로 (사용자 환경에 맞게 수정)
SSH_KEY_PATH="~/Downloads/test.pem"

# Inventory 파일명
INVENTORY_FILE="inventory.ini"

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

# Server 그룹 (be, fe)
echo "[server]" >> "$INVENTORY_FILE"
jq -r '.ec2_mapped_by_name | to_entries[] | select((.key == "testnet-be" or .key == "testnet-fe") and .value.public_ip != null) | "\(.key) ansible_host=\(.value.public_ip) ansible_user=ubuntu ansible_ssh_private_key_file='"$SSH_KEY_PATH"'"' "$OUTPUTS_JSON" >> "$INVENTORY_FILE"

# Inventory 생성 완료 메시지
echo "✅ inventory.ini 생성 완료"
cat "$INVENTORY_FILE"

# Ansible Ping 테스트 실행
echo "🔍 Ansible Ping 테스트 실행 중..."
ansible -i "$INVENTORY_FILE" all -m ping

# 결과 출력 완료
echo "✅ Ansible Ping 테스트 완료"