# Rife
## LSL preprocessor extension library

### Introduction

Rife is ~~preprocessor abuse~~ a library for the Linden Scripting Language (LSL), which relies on the LSL preprocessor functionality included in the third-party [Firestorm viewer](http://www.firestormviewer.org/).

The LSL preprocessor adds C-style preprocessor macros to the editor, allowing scripters to use familiar macros to improve their LSL script build process, including the ability to `#include` other LSL files from disk.

The name *Rife* was chosen to allude to *Rife's Raft*, from the book *Snow Crash* by Neal Stephenson. The book is often referenced in relation to SL given the nature of the 'Metaverse' within the book, and I felt this name is appropriate given the haphazard nature of the library. The function prefix `rr` was selected to reference this name.

***Please note*** *I will not be offering support for the use of this library. It's primarily a collection of tools I personally use for projects, that I've exposed to help people I'm developing things with maintain their own copies of projects. I'm happy if people can find use with the library, but I don't wish to spend my time helping people use it :) Thank you.*

### Installation

#### Into new on-disk LSL library

First, create a folder on your local computer where you would like to store LSL scripts. I recommend something easy to access, like `C:\LSL` (Windows), `~/lsl` (Linux/Mac).

Next you should configure Firestorm's LSL preprocessor. Open Firestorm, and access its Preferences window (`Ctrl + P`). Select the `Firestorm` tab, followed by the `Build 1` sub-tab. Near the bottom, you will see a collection of checkboxes that control the LSL preprocessor function. Enable, at minimum, the LSL preprocessor, the script optimizer, and includes from local disk. Set the preprocessor include path to match the folder you created just a few moments ago.

Next, follow the instructions for 'into existing on-disk LSL library'!

#### Into existing on-disk LSL library

If you have an existing on-disk LSL library include location configured for Firestorm's LSL preprocessor, simply clone this repository into a subdirectory of it:

`git clone https://github.com/arbitar/rife-lsl`

It can then be used in a new LSL script by prepending the include to the top of the script:

`#include "rife-lsl/main.lsl"`

The author's preference is to additionally create and place a 'loader script' in the root of the LSL library directory, typically named `rife.lsl`, with only the rife include command above. Then, the library can be included by using a shorter form:

`#include "rife.lsl"`

#### Syntax Highlighting for Rife Functionality

The `scriptlibrary_preproc.xml` file can be dropped over the one present in your Firestorm installation directory's `app_settings` subdirectory. This will add some of Rife's constants to the editor's highlighting & tooltips for convenience. I will be increasing the scope of this over time to include the provided functions, but it is not currently complete.

### Features

Rife includes several new constants, macros, functions, and even some events to help you get common script tasks done with minimal overhead. Many additions are simply helper functions that implement commonly-desired functionality, like fetching the first result from a raycast, or easily getting the value of a key-value strided list, given a key.

Rife also includes a full debug system with multiple levels of output that can be limited by changing a single constant. This makes compiling debug information in to or out of a script very easy.

File | Functionality
--- | ---
debug.lsl | Debug output helpers with support for multiple output levels
env.lsl | Environmental detection & information; raycasting, pathfinding, time & date, etc.
http.lsl | HTTP & communication helpers, simple packet encoder/decoder/bundlers.
kfm.lsl | Keyframed Motion helpers; supporting specifying global coordinates instead of relative coordinates for KFM commands.
listargs.lsl | Support for handling llSetPrimitiveParam-style key-multivalue strided configuration lists, including the ability to merge user-provided configuration lists with defaults.
lists.lsl | List management helpers, including quick functions to get key-value 'associative' list pair data by key.
logic.lsl | Some flow-control and general logic helpers, including `foreach` functionality and global event handling.
macros.lsl | Mostly Rife-internal utility macro definitions.
main.lsl | Includes all other Rife files. This is what you end up wanting to include in your scripts to use Rife.
math.lsl | Math helpers & additional functionality
strings.lsl | String manipulation helpers, including common string operations that the standard Linden library is suspiciously devoid of.

A full overview of the new functionality provided may be found on the [project wiki](https://github.com/arbitar/rife-lsl/wiki).