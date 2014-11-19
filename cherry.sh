git rev-list --reverse --topo-order e936eecb21e041ad98c31d039feba2a60c03bead^..98821f8b0d4200d96f6460310eaf8c12e9122954 | while read rev 
do 
  git cherry-pick $rev || break 
done 
