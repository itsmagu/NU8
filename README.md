# Not UTF-8
A library that reads binary files according to my "encoding".
# Also Not Done yet
Work in progress...
## But why
I trust computer but not software engineers and thus I had a religious moment in the shower where a magic seal told me to create this.
## The real why
I was really in the shower, but I had just played around with Valve's source engine VMF format and realized how many bits of files are never used, this along with the fact that zig can on a language level store arbitrary bit ranges. Like a unsigned 7 bit number or a 56 bit number (They are still read like a 32 or 64 bit number thanks to hardware limitation as I understand it, but they are stored in ram with only 7 or 56 bits (Correction! Nothing is ever smaller then 8 bits without extensive witchcraft)). And I think this will be a excellent way to learn zig with. It also might be usable to have a encoding that can only represent the exact symbols I will be using to save space per byte.
But also because it's fun!
## The Plan
The resulting design should not necessarily be compressed but if it is that is a plus. The main goal is to be quick to read and space efficient while still being able to represent everything I need to store. Write speed is fine if it's slow but considering how simple this might turn out to be I don't think I will even have to do anything fancy to make it fast.

The lib will consist of a way to translate my (later to be decided) format represented in binary into normal c strings. The lib will have a way to bit translate directly and/or serve produced data and stored data from/to a file. The "format" will internally most likely only be a enum with 2 related functions. One to read and one to write, then the rest of the lib will wrap these 2 functions.
### Requirements
Layout: name with a hyperlink - install command via windows app installer "winget" - description
- [Zig](https://ziglang.org/) - ```winget install zig.zig``` - The zig language compiler and toolchain
### Optional Requirements
Layout: name with a hyperlink - install command via windows app installer "winget" - description
- [Obsidian](https://obsidian.md/) - ```winget install Obsidian.Obsidian``` - The documentation tool I use to write
