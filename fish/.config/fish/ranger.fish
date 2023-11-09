function ranger --description 'alias ranger ranger --choosedir=$HOME/.rangerdir; set RANGERDIR (cat $HOME/.rangerdir); cd $RANGERDIR'
 command ranger --choosedir=$HOME/.rangerdir; set RANGERDIR (cat $HOME/.rangerdir); cd $RANGERDIR $argv
        
end
