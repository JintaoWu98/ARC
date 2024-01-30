#!/bin/bash

# Function to initialize Micromamba
initialize_micromamba() {
    eval "$(micromamba shell hook --shell bash)"
}


# Function to check and adjust permissions for mounted directories
check_and_adjust_permissions() {
    # Loop through all mounted directories
    for dir in /home/rmguser/*; do
        # Check if it's a directory
        if [ -d "$dir" ]; then
            # Adjust permissions for the directory
            chown -R rmguser:rmguser "$dir"
        fi
    done
}

# Function to run for interactive mode
run_interactive() {
    check_and_adjust_permissions
    echo "Container started in interactive mode"
    
    /home/rmguser/alias_print.sh
    
    /bin/bash
}

# Function to run for non-interactive mode
run_non_interactive() {
    check_and_adjust_permissions
    echo "Container started in non-interactive mode"
    initialize_micromamba

    case "$1" in
        rmg)
            # Activate rmg_env and run RMG with python-jl
            echo "Running with RMG environment..."
            micromamba activate rmg_env
            python-jl /home/rmguser/Code/RMG-Py/rmg.py "$2"
            ;;
        arc)
            # Activate arc_env and run ARC
            echo "Running with ARC environment..."
            micromamba activate arc_env
            python /home/rmguser/Code/ARC/ARC.py "$2"
            ;;
        *)
            echo "Invalid option. Please specify 'rmg' or 'arc' as the first argument."
            exit 1
            ;;
    esac
}

# Check if the container is run in interactive mode
if [ -t 0 ] && [ -t 1 ]; then
    run_interactive
else
    run_non_interactive "$@"
fi
