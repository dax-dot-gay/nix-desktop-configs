if [ $# -ne 2 ]; then
    echo "Usage: deploy <hostname> <target_ip>"
    exit 1
fi

HOSTNAME=$1
TARGET_IP=$2
BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE=$(git remote get-url origin)

temp=$(mktemp -d)
mkdir -p "$temp/etc"
git clone --branch $BRANCH $REMOTE $temp/etc/nixos
chmod -R 770 $temp/etc/nixos

cd $(git rev-parse --show-toplevel)
nixos-anywhere \
    --disk-encryption-keys /tmp/disk.key /tmp/$HOSTNAME-enc.key \
    --extra-files "machines/$HOSTNAME/.machine-secrets" \
    --extra-files "$temp" \
    --chown /etc/nixos 0:101 \
    --flake ".#$HOSTNAME" --target-host nixos@$TARGET_IP \
    --generate-hardware-config nixos-generate-config machines/$HOSTNAME/hardware-configuration.nix

rm -rf $temp