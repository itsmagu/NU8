# Not UTF-8
A library that reads binary files according to my "encoding".
## But why
I trust computer but not software engineers and thus I had a religious moment in the shower where a seal told me to create this.
## The real why
I was really in the shower, but I had just played around with Valve's source engine VMF format and realized how many bits of files are never used, this along with the fact that zig can on a language level store arbitrary bit ranges. Like a unsigned 7 bit number or a 56 bit number (They are still read like a 32 or 64 bit number thanks to hardware limitation as I understand it, but they are stored in ram with only 7 or 56 bits). And I think this will be a excellent way to learn zig with. It also might be usable to have a encoding that can only represent the exact symbols I will be using to save space per byte.
### Requirements
First the name with a hyperlink - install command via windows app installer "winget" - description
- [Zig](https://ziglang.org/) - ```winget install zig.zig``` - The zig language compiler and toolchain
### Optional Requirements
Layout: name with a hyperlink - install command via windows app installer - description
- [Obsidian](https://obsidian.md/) - ```winget install Obsidian.Obsidian``` - The documentation tool I use to write