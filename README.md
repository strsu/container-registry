# Docker Registry 설정

## 인증 설정

### 1. 환경 변수 설정

환경 변수를 통해 username과 password를 설정할 수 있습니다:

**방법 1: .env 파일 사용 (권장)**

`registry` 디렉토리에 `.env` 파일을 생성하세요:

```bash
cd registry
cat > .env << EOF
REGISTRY_USERNAME=admin
REGISTRY_PASSWORD=your-secure-password
EOF
```

**방법 2: 환경 변수 직접 설정**

```bash
export REGISTRY_USERNAME=admin
export REGISTRY_PASSWORD=your-secure-password
```

**기본값:**
- `REGISTRY_USERNAME`: admin (설정하지 않으면 기본값)
- `REGISTRY_PASSWORD`: changeme (설정하지 않으면 기본값)

### 2. Registry 시작

```bash
docker-compose up -d
```

인증 파일은 자동으로 생성됩니다. `registry-auth-init` 컨테이너가 환경 변수로부터 username과 password를 읽어서 htpasswd 파일을 생성합니다.

### 3. Registry 사용

인증이 필요한 경우:

```bash
docker login <registry-url> -u <username> -p <password>
```

이미지 푸시:
```bash
docker tag <image> <registry-url>/<image>
docker push <registry-url>/<image>
```

이미지 풀:
```bash
docker pull <registry-url>/<image>
```

## 주의사항

- `auth/` 디렉토리는 `.gitignore`에 포함되어 있으므로 Git에 커밋되지 않습니다.
- 프로덕션 환경에서는 강력한 비밀번호를 사용하세요.
- 필요시 여러 사용자를 추가할 수 있습니다 (htpasswd 파일에 추가).

