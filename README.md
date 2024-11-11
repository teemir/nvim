# Neovim Config

Мой конфиг для Neovim

## Установка

```bash
rm -rf ~/.config/nvim && mkdir -p ~/.config/nvim && curl -L https://github.com/teemir/nvim/archive/refs/heads/main.tar.gz | tar -xz -C ~/.config/nvim --strip-components=1
```

## Открываем Neovim и пишем команду
```vi
:PackerInstall --Устанвливаем плагины
```
Если пишет что такой команды нет то фиксим:
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
## Далее все должно заработать =)
Если нет, правим ручками конфиги, например тут **~/.config/nvim/lua/plugins.lua** 
```
:PackerSync --Обновление плагинов
```
