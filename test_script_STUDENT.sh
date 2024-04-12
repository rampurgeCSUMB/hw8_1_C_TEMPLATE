#!/bin/bash

# Check if compilation was successful
if [ ! -f "./main.exe" ]; then
    echo "Compilation failed, main.exe not found."
    exit 1
fi

# Initialize a counter for passed tests
passed_tests=0
total_tests=0

# Loop through all input files in the input directory
for input_file in input/*.txt; do
    # Increment total tests counter
    ((total_tests++))
    
    # Extract the base name of the file and replace 'input' with 'output' in the name
    base_name=$(basename "$input_file" .txt | sed 's/^input/output/')
    
    # Construct the output file path with the corrected base name
    output_file="output/${base_name}.txt"
    
    # Run the program with the current input file and save the output to a temporary file
    ./main.exe < "$input_file" > temp_output.txt
    
    # Compare the output with the corresponding output file
    if diff -qwB temp_output.txt "$output_file" >/dev/null; then
        echo "Test Passed: Output matches expected output for $base_name"
        ((passed_tests++))
    else
        echo -e "Test Failed: Output does not match expected output for $base_name\n"
        echo -e "\tActual output:\n"
        while IFS= read -r line; do
            echo -e "\t\t$line"
        done < temp_output.txt
        echo -e "\n\tExpected output:\n"
        while IFS= read -r line; do
            echo -e "\t\t$line"
        done < "$output_file"
        echo ""
    fi
done

# tell the number of passed tests
echo "$passed_tests out of $total_tests test cases passed."

# Clean up compiled program and temporary output file
rm temp_output.txt
