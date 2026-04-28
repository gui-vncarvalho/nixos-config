# Instalação limpa do NixOS com este flake

> **Importante:** no live ISO, **não use** `nixos-rebuild switch` para instalar.
> Use `nixos-install --flake ...` após montar em `/mnt`.

## Fluxo recomendado (máquina nova)

1. Boot no ISO do NixOS.
2. Conecte na internet:
   - Ethernet: normalmente automático.
   - Wi-Fi: `nmtui` (ou `nmcli`).
3. Particione e formate o disco.
   - Exemplo (ajuste o disco/dispositivos):
     - EFI (FAT32)
     - Root (ext4/btrfs/xfs)
4. Monte o root em `/mnt`.
   - Exemplo: `sudo mount /dev/disk/by-label/nixos /mnt`
5. Crie e monte a EFI em `/mnt/boot`.
   - Exemplo:
     - `sudo mkdir -p /mnt/boot`
     - `sudo mount /dev/disk/by-label/EFI /mnt/boot`
6. Clone este repositório em `/mnt/etc/nixos`.
   - HTTPS: `git clone <repo-url> /mnt/etc/nixos`
   - SSH: `git clone git@github.com:<owner>/<repo>.git /mnt/etc/nixos`
7. Gere a configuração de hardware para o sistema alvo:
   - `sudo nixos-generate-config --root /mnt`
8. Copie/substitua o `hardware-configuration.nix` gerado para dentro do repo (raiz de `/mnt/etc/nixos`):
   - Se o gerado estiver em outro local: `sudo cp <origem>/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix`
   - Se você gerou já em `/mnt` e o arquivo caiu no próprio repo, apenas confirme que ele existe.
9. Entre no repo e adicione o arquivo ao git (obrigatório para flakes):
   - `cd /mnt/etc/nixos`
   - `git add hardware-configuration.nix`
10. Instale com o flake/hostname corretos:
    - `sudo nixos-install --flake /mnt/etc/nixos#nixos`
11. Reinicie:
    - `reboot`

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
