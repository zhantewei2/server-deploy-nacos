function logInfo(){
    echo -e "\033[36m$1 \033[0m: $2"
}

function console(){
    echo -e "\033[33m$@ \033[0m"
}
function print(){
    echo -e "\033[35m$@ \033[0m"
}
