#!/usr/bin/env bash

# Registry 이미지 리스트 출력 스크립트

set -euo pipefail

REGISTRY="registry.prup.xyz"
REGISTRY_USER="admin"
REGISTRY_PASSWORD="admin66^^"

echo "=== Registry 이미지 리스트 ==="
echo "Registry: ${REGISTRY}"
echo ""

# 리포지토리 목록 가져오기 (기본 인증 사용)
echo "리포지토리 목록 가져오는 중..."
REPOS=$(curl -s -u "${REGISTRY_USER}:${REGISTRY_PASSWORD}" \
    "https://${REGISTRY}/v2/_catalog")

# JSON 파싱 (jq가 있으면 사용, 없으면 기본 파싱)
if command -v jq &> /dev/null; then
    echo "$REPOS" | jq -r '.repositories[]' | while read repo; do
        echo ""
        echo "📦 Repository: ${repo}"
        echo "   Tags:"
        
        TAGS=$(curl -s -u "${REGISTRY_USER}:${REGISTRY_PASSWORD}" \
            "https://${REGISTRY}/v2/${repo}/tags/list")
        
        echo "$TAGS" | jq -r '.tags[]?' | while read tag; do
            echo "     - ${tag}"
        done
    done
else
    # jq가 없을 때 기본 파싱
    echo "$REPOS" | grep -o '"[^"]*"' | tr -d '"' | while read repo; do
        echo ""
        echo "📦 Repository: ${repo}"
        echo "   Tags:"
        
        TAGS=$(curl -s -u "${REGISTRY_USER}:${REGISTRY_PASSWORD}" \
            "https://${REGISTRY}/v2/${repo}/tags/list")
        
        echo "$TAGS" | grep -o '"[^"]*"' | tr -d '"' | grep -v '^name$' | grep -v '^tags$' | while read tag; do
            echo "     - ${tag}"
        done
    done
fi

echo ""
echo "=== 완료 ==="

