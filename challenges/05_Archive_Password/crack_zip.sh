#!/bin/bash

clear
echo "🔓 ZIP Password Cracking"
echo "==========================="
echo
echo "📁 Target archive: secret.zip"
echo "📜 Wordlist: wordlist.txt"
echo
echo "🔧 Quick Note:"
echo "   We're going to test each password in wordlist.txt to see which one unlocks the ZIP file."
echo "   Behind the scenes, the script runs: unzip -P [password] -t secret.zip"
echo "   → '-P' supplies the password"
echo "   → '-t' tests if the ZIP is valid (without fully extracting it)"
echo
read -p "Press ENTER to begin password testing..." junk
echo

found=0
correct_pass=""

# Try each password and display it
while read -r pw; do
    # Clear line properly by padding with spaces
    printf "\r[🔐] Trying password: %-20s" "$pw"
    sleep 0.05
    if unzip -P "$pw" -t secret.zip 2>/dev/null | grep -q "OK"; then
        echo -e "\n\n✅ Password found: $pw"
        correct_pass="$pw"
        found=1
        break
    fi
done < wordlist.txt

if [[ "$found" -eq 0 ]]; then
    echo -e "\n❌ Password not found in the list."
    exit 1
fi

# Ask to proceed
echo
read -p "Proceed to extract the ZIP archive? [Y/n] " go
while [[ ! "$go" =~ ^[YyNn]?$ ]]; do
    read -p "Please enter Y or N: " go
done
[[ "$go" =~ ^[Nn]$ ]] && exit 0

# Extract the ZIP archive using the found password
unzip -P "$correct_pass" secret.zip >/dev/null 2>&1

if [[ ! -f message_encoded.txt ]]; then
    echo "❌ Extraction failed."
    exit 1
fi

# Show base64 content first
echo
echo "📦 Extracted Base64 Data:"
echo "-----------------------------"
cat message_encoded.txt
echo "-----------------------------"

# Prompt before decoding
echo
read -p "Would you like to decode the Base64 message now? [Y/n] " decode
while [[ ! "$decode" =~ ^[YyNn]?$ ]]; do
    read -p "Please enter Y or N: " decode
done

if [[ "$decode" =~ ^[Nn]$ ]]; then
    echo "❌ Skipping Base64 decoding. You can decode it manually later using: base64 --decode message_encoded.txt"
    exit 0
fi

echo
echo "🧪 Base64 Detected:"
echo "   The file we extracted (message_encoded.txt) contains Base64 — a way of encoding binary data as text."
echo "   We'll now decode it using the 'base64' command to reveal the original message."
echo
read -p "Press ENTER to decode the Base64 content..." junk

# Decoding animation
echo
echo "🔽 Decoding Base64:"
for i in {1..20}; do
    sleep 0.05
    echo -n "█"
done
echo -e "\n"

# Decode the base64 message
echo "🛠️ Running: base64 --decode message_encoded.txt"
echo "   → This converts the encoded content back into readable text"
echo

decoded=$(base64 --decode message_encoded.txt 2>/dev/null)

echo
echo "🧾 Decoded Message:"
echo "-----------------------------"
echo "$decoded"
echo "-----------------------------"

# Save decoded output
echo "$decoded" > decoded_output.txt
echo "💾 Decoded message saved to: decoded_output.txt"

echo
echo "🧠 Pick the valid flag from the list (format: CCRI-AAAA-1111) and enter it into the scoreboard."
read -p "Press ENTER to close this terminal..." done
