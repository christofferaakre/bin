function partition_space
    # Show available space on all partitions
    df -Th | grep -v fs
end
