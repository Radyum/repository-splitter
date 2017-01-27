#!/usr/bin/env bash

echo
echo "*---------------------------------*"
echo "| Interactive Repository Splitter |"
echo "*---------------------------------*"
echo
echo "Provide the original git repository address :"
read repo_address
mkdir splitter_cache
cd splitter_cache
git clone "$repo_address"
echo
cd ..
repo_name="$(basename "$repo_address")"
repo_name="${repo_name::-4}"
cp -r splitter_cache/$repo_name .
cd "$repo_name"
while true
do
	echo "Which folder would you like to split as a new repository ? ('none' to quit)"
	read folder
	if [ $folder == 'none' ]; then
		break
	fi
	git filter-branch --prune-empty --subdirectory-filter $folder  'master'
	echo
	echo "Provide the new git repository address (Repository must be previously created manually)" 
	read new_repo_address
	git remote set-url origin "$new_repo_address"
	git push --force -u origin master
	echo
	echo "New repository created!"
	echo
	echo "Rebuilding original repository"
	cd ..
	rm -rf "$repo_name"
	cp -r splitter_cache/$repo_name .
	cd "$repo_name"
done
echo "Cleaning"
cd ..
rm -rf "$repo_name"
rm -rf splitter_cache
echo "Bye!"
