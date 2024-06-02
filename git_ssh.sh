#!/bin/bash

prompt_for_input() {
    while true; do
        read -p "Enter your name: " name
        read -p "Enter your email: " email
        confirm_input
        if [ $? -eq 0 ]; then
            break
        fi
    done
}

confirm_input() {
    echo "You entered: "
    echo "Name: $name"
    echo "Email: $email"
    
    read -p "Is this correct? (y/n): " confirm

    if [[ $confirm != [yY] ]]; then
        return 1
    else
        return 0
    fi
}

generate_ssh_key() {
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$HOME/.ssh/id_rsa_$name" -N ""
    if [ $? -eq 0 ]; then
        echo "SSH Key generated"
        echo "Public key is located at: $HOME/.ssh/id_rsa_$name.pub"
    else
        echo "Failed to generate SSH key."
        exit 1
    fi
}

add_ssh_key_to_agent() {
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_rsa_$name"
    if [ $? -eq 0 ]; then
        echo "SSH key added to agent"
    else
        echo "Failed to add SSH key to agent"
        exit 1
    fi
}

entrypoint() {
    prompt_for_input
    generate_ssh_key
    add_ssh_key_to_agent

    echo "SSH Key setup is complete"
    echo "Name: $name"
    echo "Email: $email"
    echo "Filepath: $HOME/.ssh/id_rsa_$name"
}

entrypoint
