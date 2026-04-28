# Instalação limpa do NixOS com este flake

> **Importante:** no live ISO, **não use** `nixos-rebuild switch` para instalar.
> Use `nixos-install --flake ...` após montar em `/mnt`.

## Comandos exatos (UEFI + disco único + root em ext4)

> **Atenção:** os comandos abaixo apagam o disco selecionado.
> Exemplo usa `DISK=/dev/nvme0n1`. Troque se necessário (`/dev/sda`, etc).

```bash
# 1) virar root no live ISO
sudo -i

# 2) (opcional) teclado ABNT2
loadkeys br-abnt2

# 3) internet (Wi-Fi; com cabo geralmente já funciona)
nmtui

# 4) confirmar nome do disco
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS

# 5) definir disco alvo
DISK=/dev/nvme0n1

# 6) recriar tabela GPT e partições (EFI + ROOT)
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart ESP fat32 1MiB 513MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart ROOT ext4 513MiB 100%

# 7) resolver nome das partições (nvme vs sata)
if [[ "$DISK" == *"nvme"* ]]; then
  EFI_PART="${DISK}p1"
  ROOT_PART="${DISK}p2"
else
  EFI_PART="${DISK}1"
  ROOT_PART="${DISK}2"
fi

# 8) formatar partições
mkfs.fat -F 32 "$EFI_PART"
mkfs.ext4 -L nixos "$ROOT_PART"

# 9) montar sistema destino em /mnt
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$EFI_PART" /mnt/boot

# 10) clonar seu repo para o destino
git clone <URL_DO_REPO> /mnt/etc/nixos
# ou SSH:
# git clone git@github.com:<owner>/<repo>.git /mnt/etc/nixos

# 11) gerar hardware config para o sistema em /mnt
nixos-generate-config --root /mnt

# 12) garantir que o arquivo está no repo e rastreado pelo git
cd /mnt/etc/nixos
git add hardware-configuration.nix

# 13) instalar via flake output "nixos"
nixos-install --flake /mnt/etc/nixos#nixos

# 14) reboot
reboot
```

---

## Troubleshooting

### `hardware-configuration.nix does not exist`
- Causa comum: arquivo não existe no caminho esperado pelo `configuration.nix`.
- Neste repo, ele é importado como `./hardware-configuration.nix`, então o arquivo deve existir na raiz do repo.
- Gere novamente com:
  - `sudo nixos-generate-config --root /mnt`
- Depois copie para o arquivo do repo e rode `git add hardware-configuration.nix`.

### Flake não enxerga arquivo não rastreado (`git`)
- Flakes usam snapshot do git e podem ignorar arquivo novo não rastreado.
- Solução:
  - `git add hardware-configuration.nix`
- Você não precisa commitar no ISO para instalar localmente, mas precisa ao menos rastrear o arquivo no índice.

### `No space left on device` no live ISO
- Causa comum: rodar `nixos-rebuild switch` no ambiente live, enchendo o `/nix/store` temporário da RAM.
- Solução:
  - Monte o disco de destino em `/mnt` e use **somente**:
    - `sudo nixos-install --flake /mnt/etc/nixos#nixos`
- Se já encheu:
  - Reinicie o live ISO e refaça o fluxo correto acima.

### Problemas de DNS / clone do GitHub (HTTPS/SSH)
- Teste conectividade:
  - `ping -c 1 github.com`
- Se DNS falhar, configure nameserver temporário no live ISO:
  - `echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf`
- HTTPS pede credenciais/token quando necessário.
- SSH exige chave cadastrada no GitHub (`ssh -T git@github.com`).
