## I have made my decision
I see some valid use for all the methods listed in the previous doc. A smaller bit width would be useful for raw images that only need to store a long list of colors. While a map file which might resemble a json file we might need a large set of characters.
Thus I have decided to include a small set of formats that will be selectable via the system and then encoded as such. The selection will be:
- 7bit for 128 characters.
- 6bit for 64 characters with a-z, A-Z, 0-9 and 2 special (space and newline).
- 6bitExt for 64 characters with a-z, 0-9, 27 special and a uppercase toggle.
- 5bit for 32 characters with a-z, 5 special and a uppercase toggle.
- 4bit for 16 characters with 0-9 and 6 special characters.
- 4bitExt for 8-28 characters with a-z and 2 special with the 4th bit used to request the next 4 bits.
- 3bit for a non-exhaustive scale of 0-100 represented with numbers from 0 to 8.
This selected might change but I could see a use for them all, even 3bits could be used to store compressed raw textures.
### Store which encoding is used
Of course the reader will be in charge of what encoding is used but it might be a good idea to have the option of storing the encoding type in the file. I am think it might be as simple as the first byte of all encodings will be a normal byte with a set of enum indicating the encoding used and maybe some other information.