git remote add new-origin git@server:user/repository.git
git push --all new-origin
git push --tags new-origin
git remote rm origin
git remote rename new-origin origin
