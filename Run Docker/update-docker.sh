
dir=.

if [ -d "$dir" ]; then
    branch=$(git --git-dir "$dir/.git" branch | sed -n -e 's/^\* \(.*\)/\1/p')
    status=$(git --git-dir "$dir/.git" --work-tree=$dir status)
else
    branch='.git dir not found'
    status=''
fi

echo
echo "* Folder: $dir/.git"
echo "* Branch: $branch"
echo "* Status:"
echo
echo "$status"
echo

if [ -z "$branch" ]
then
    git clone https://github.com/cocomdidin/morbis.git
else
     git pull origin $branch
fi

sleep 2
echo ''
echo ''
echo 'Docker Already Updated....'
echo 'Mantap Slur.....'
sleep 2