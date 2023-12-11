import random
import string
import sys

max_val = 0
min_val = 0

def randomize_text(file_path):
    # Function to generate a string of random characters excluding newlines and spaces
    def random_chars(length, is_digit_permitted=True):
        if(is_digit_permitted): 
            allowed_chars = string.ascii_letters + string.digits + string.punctuation.replace(" ", "").replace("\n", "")
        else:
            allowed_chars = string.ascii_letters + string.punctuation.replace(" ", "").replace("\n", "")
        return ''.join(random.choices(allowed_chars, k=length))

    # Read the input file
    with open(file_path, 'r') as file:
        content = file.read()
    variable_x = random_chars(7, False) + 'X' + random_chars(random.randint(min_val, max_val), False);
    new_content = ""
    current_number = ""  # To accumulate digits of a number
    for char in content:
        if char == 'X':
            # If the current number is not empty, append it first
            if current_number:
                new_content += random_chars(7, False) + current_number + random_chars(random.randint(min_val, max_val), False)
                current_number = ""
            # Keep 'X' unchanged
            new_content += variable_x
        elif char.isdigit():
            # Accumulate digits to form the complete number
            current_number += char
        else:
            # If the current number is not empty, append it first
            if current_number:
                new_content += random_chars(7, False) + current_number + random_chars(random.randint(min_val, max_val), False)
                current_number = ""
            if char.isalpha() or char in string.punctuation:
                # Add 7 random characters before and a random number of characters after
                new_content += random_chars(7) + char + random_chars(random.randint(min_val, max_val))
            else:
                # Preserve other characters like newlines and spaces
                new_content += char

    # Append any remaining number at the end of the content
    if current_number:
        new_content += random_chars(7, False) + current_number + random_chars(random.randint(min_val, max_val), False)

    return new_content

# Using command-line argument for file path
if len(sys.argv) < 2:
    print("Usage: python script.py <path_to_file>")
else:
    file_path = sys.argv[1]
    result = randomize_text(file_path)
    print(result)
