rm -rf ~/.zprofile ~/.zshrc ~/.gitignore_global ~/.gitconfig ~/.vimrc ~/.doom.d
ln -v ./.zprofile ~
ln -v ./.zshrc ~
ln -v ./.gitconfig ~
ln -v ./.gitignore_global ~
ln -v ./.vimrc ~
rsync -r ./.doom.d ~

