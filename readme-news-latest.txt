WHAT'S NEW IN D-TYPE ENGINES

VERSION 8.2.1.3 - DECEMBER 2020

* The HarfBuzz shaping engine (built into D-Type Text Layout Extension) by itself can't process TrueType/OpenType fonts compressed using the WOFF or WOFF2 compression format. As a result, prior to D-Type 8.2.1.3, it was not possible for D-Type Text Layout Extension to utilize OpenType Layout tables in TrueType/OpenType fonts that were saved in WOFF or WOFF2 format. This limitation has been removed. Now, when handling WOFF and WOFF2 fonts, D-Type Font Engine supplies uncompressed (raw) TrueType/OpenType font data to HarfBuzz. This allows HarfBuzz to shape complex scripts using TrueType/OpenType fonts compressed using the WOFF and WOFF2 format, provided they contain OpenType Layout tables.

* Even though variable TrueType/OpenType font support is available in D-Type Font Engine as of release 7.0, the "avar" table in those fonts was not respected due to a bug. This bug is now fixed and "avar" table support works as intended. The bug did not cause any other problems as far as variable font support is concerned.

* D-Type Font Engine now includes a tweak which makes the glyph advance widths work as intended with the latest STIX v2.10 variable fonts. The issue was caused by ambiguous OpenType specifications, which are rather unclear on how to correctly interpret the "HVAR" delta-set index mapping table in variable TrueType/OpenType fonts. See https://github.com/MicrosoftDocs/typography-issues/issues/708 for more details.

* Due to an issue with Apple's LLVM clang 12 compiler (Xcode 12.2), the static version of D-Type Standard Engine (dtypestd.o) built for macOS architectures i386 and x86_64 was not usable on Mac OS X 10.8, 10.9 and 10.10, resulting in a "___darwin_check_fd_set_overflow" undefined symbol link error. This impacted only D-Type releases 8.0.1.3 and 8.2.1.1 which were built using clang 12. To work around this issue, the static version of D-Type Standard Engine for macOS architectures i386 and x86_64 is now being built using LLVM clang 10 (Xcode 10) -- i.e. the same compiler used prior to D-Type 8.0.1.3. If the issue is addressed in future Xcode releases, this workaround will be removed. Note that all other D-Type libraries and tools for macOS are still built using Apple's LLVM clang 12 compiler (Xcode 12.2) as they don't seem to cause any linking issues on older Mac OS X systems.

* D-Type Font Optimizer (font_optimizer.exe, font_optimizer_osx and font_optimizer_linux) upgraded to version 1.7.1.

* A number of small internal enhancements.


VERSION 8.2.1.1 - DECEMBER 2020

* D-Type PowerDoc Engine: Rsvd member (bit 7) of the DT_PD_FRAME_FORMAT1 / DT_PD_FRAME_FORMAT2 structure can be used to determine if a frame was extended.

* D-Type Unicode Text Engine has been renamed to D-Type Unicode Text Module. Technically speaking, D-Type Unicode Text Engine was never an independent D-Type engine but a dependency (or module) of D-Type PowerDoc Engine. The new name reflects this fact more clearly. At the same time, all functions with the txEngine prefix are now unnecessary and officially deprecated. Existing applications can either replace these function calls with equivalent pdEngine... calls at an appropriate point in their development lifecycle (as per the info below) or use updated D-Type C/C++ headers which will automatically redirect deprecated txEngine... function calls to the equivalent pdEngine... function calls. Irrespective of this, D-Type static and shared/dynamic libraries still maintain binary compatibility with earlier D-Type library versions, which means that old txEngine... functions are still available and continue to work as before. These old functions will remain available in all future D-Type 8 static and shared/dynamic libraries, however they are scheduled to be removed in D-Type 9.

* Changes to includes/core/dtypetxt-hi.h as follows:

  - DT_TXENGINE deprecated; use DT_PDENGINE instead.
  - txEngineGetPowerEngInst deprecated; no need to use any other function as DT_TXENGINE is an alias for DT_PDENGINE.
  - txEngineIniViaStream deprecated; use pdEngineIniViaStream instead.
  - txEngineExt deprecated; use pdEngineExt instead.
  - txEngineGetVersion deprecated; use pdEngineGetVersion instead.
  - txEngineGetDTypeEngInst deprecated; use pdEngineGetDTEngineInst instead.
  - txEngineMakeCachedFontmap deprecated; use txMakeCachedFontmap instead.
  - txTextGetTextEngInst deprecated; use txTextGetPDEngineInst instead.

* Changes to includes/core/dtypepwr.h as follows:

  - pdEngineGetDTypeEngInst deprecated; use pdEngineGetDTEngineInst instead.
  - pdDocGetPowerEngInst deprecated; use pdDocGetPDEngineInst instead.

* Changes to includes/core-cpp/dtengine.h and includes/core-cpp/dtengine.cpp:

  - CDTEngineV8::GetDtEngine renamed to CDTEngineV8::GetDTEngine
  - CDTEngineV8::GetPdEngine renamed to CDTEngineV8::GetPDEngine
  - CDTEngineV8::GetTxEngine removed
  - CDTDocV8::GetPdDoc renamed to CDTDocV8::GetPDDoc
  - CDTDocV8::GetTxDoc renamed to CDTDocV8::GetTXDoc

* dtype.inf: New SBIX_SCALE_VIA_BOUND keyword in section E) FONT FACTORIES (CDTFontOpenTypeTtf and CDTFontOpenTypeCff)

* dtype.inf: New parameters in section F) LIST OF ADDITIONAL PARAMETERS

  10. Power Engine's font display mode for color glyph layers: 0=Don't show color layers, 1=Show color layers
  11. Power Engine's font display mode for bitmap glyph images: 0=Don't show bitmaps, 1=Show bitmaps: Low Quality, 2=Show bitmaps: High Quality, 3=Show bitmaps: Very High Quality, 4=Show bitmaps: Very High Quality (More Blur)
  12. Power Engine's font display mode for SVG glyphs: 0=Don't show SVG glyphs, 1=Show SVG glyphs
  13. Power Engine's control flags for Unicode script shaping (makes it possible to choose either the HarfBuzz or Power Engine's vertical layout support)

* fontmap.inf: More compact due to the ;+ operator.

  Example:

    Standard style (26 rows):

    SCRIPTCODE:kana|ATTRIBS:ro=2|FONTNAME:Arial Unicode MS
    SCRIPTCODE:kana|ATTRIBS:ro=2|FONTNAME:Code2000
    SCRIPTCODE:kana|ATTRIBS:ro=2|FONTFUID:F0011_ARPLSH_NS0
    SCRIPTCODE:hang|ATTRIBS:ro=8|FONTNAME:Arial Unicode MS
    SCRIPTCODE:hang|ATTRIBS:ro=8|FONTNAME:Code2000
    SCRIPTCODE:hebr|ATTRIBS:ro=8|FONTFUID:F0010_DEJAVU_NS0
    SCRIPTCODE:hebr|ATTRIBS:ro=8|FONTNAME:Arial
    SCRIPTCODE:hebr|ATTRIBS:ro=8|FONTNAME:Tahoma
    SCRIPTCODE:hebr|ATTRIBS:ro=8|FONTNAME:Times New Roman
    SCRIPTCODE:arab|ATTRIBS:ro=8|FONTNAME:Arial
    SCRIPTCODE:arab|ATTRIBS:ro=8|FONTNAME:Tahoma
    SCRIPTCODE:arab|ATTRIBS:ro=8|FONTNAME:Times New Roman
    SCRIPTCODE:arab|ATTRIBS:ro=8|FONTNAME:KacstBook
    SCRIPTCODE:deva|ATTRIBS:ro=8|FONTNAME:Raghindi
    SCRIPTCODE:deva|ATTRIBS:ro=8|FONTNAME:Thyaka Rabison
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:Tahoma
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:Norasi
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:Loma
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:Thonburi
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:AngsanaDSE
    SCRIPTCODE:0000|ATTRIBS:ro=8|FONTNAME:Arial Unicode MS
    SCRIPTCODE:0000|ATTRIBS:ro=8|FONTNAME:Code2000
    SCRIPTCODE:0000|ATTRIBS:ro=8|FONTFUID:F0010_CMSANS_SS0
    CHARSPAN:00003001-00003002|ATTRIBS:ro=2|FONTNAME:Arial Unicode MS
    CHARSPAN:00003001-00003002|ATTRIBS:ro=2|FASTFUID:F0011_ARPLSH_NS0
    CHARSPAN:00003001-00003002|ATTRIBS:ro=2|FONTNAME:Code2000

    New compact style (8 rows):

    SCRIPTCODE:kana|ATTRIBS:ro=2|FONTNAME:Arial Unicode MS;+FONTNAME:Code2000;+FONTFUID:F0011_ARPLSH_NS0
    SCRIPTCODE:hang|ATTRIBS:ro=8|FONTNAME:Arial Unicode MS;+FONTNAME:Code2000
    SCRIPTCODE:hebr|ATTRIBS:ro=8|FONTFUID:F0010_DEJAVU_NS0;+FONTNAME:Arial;+FONTNAME:Tahoma;+FONTNAME:Times New Roman
    SCRIPTCODE:arab|ATTRIBS:ro=8|FONTNAME:Arial;+FONTNAME:Tahoma;+FONTNAME:Times New Roman;+FONTNAME:KacstBook
    SCRIPTCODE:deva|ATTRIBS:ro=8|FONTNAME:Raghindi;+FONTNAME:Thyaka Rabison
    SCRIPTCODE:thai|ATTRIBS:ro=8|FONTNAME:Tahoma;+FONTNAME:Norasi;+FONTNAME:Loma;+FONTNAME:Thonburi;+FONTNAME:AngsanaDSE
    SCRIPTCODE:0000|ATTRIBS:ro=8|FONTNAME:Arial Unicode MS;+FONTNAME:Code2000;+FONTFUID:F0010_CMSANS_SS0
    CHARSPAN:00003001-00003002|ATTRIBS:ro=2|FONTNAME:Arial Unicode MS;+FASTFUID:F0011_ARPLSH_NS0;+FONTNAME:Code2000

* D-Type Examples: example_text_application - switched to using CDTWindow::Event_CharDown and, consequently, simplified code in keyboard.cpp.

* D-Type Manuals:

  - Font and Attribute Mapping Table (Fontmap) for Unicode Text Output: this section of the manual has been completely rewritten.
  - Documented the Misc and Rsvd members of the DT_PD_FRAME_FORMAT1 / DT_PD_FRAME_FORMAT2 structure.
  - Documented pdEngineGetHyphenatorInst and pdEngineGetLayoutCacheInst.
  - Documented txTextIniViaPowerDocAndStream, txTextIniViaPowerDocAndBuffer, txTextMakeViaPowerDocAndStream, txTextMakeViaPowerDocAndBuffer
  - Documented txTextAddFlowPlus, txTextAddFlow.
  - Documented txTextSaveToFile.
  - Various small updates and improvements.


VERSION 8.0.1.3 - NOVEMBER 2020

* All D-Type engines are now available for macOS arm64 (Apple's new ARM Macs).

* All D-Type examples and manuals now use DV_NULL rather than NULL. In C++ DV_NULL is defined as nullptr and in C it is defined as NULL.

* D-Type Font Engine: dtGlyphGetExtras: SVG documents within an OpenType SVG table may come in either plain text or gzip-compressed format. When SVG data is gzip-compressed, the dtGlyphGetExtras function will now automatically decompress it.

* D-Type Text Layout Extension now includes the latest HarfBuzz 2.7.2 shaping engine.

* D-Type PowerDoc Engine: pdDocSetNumericValue: PD_NVAL_CONTROL_ALGORITHMS: Bit 4: Controls the direction of the line-break character. See pdDocSetNumericValue in the manual for details.

* D-Type PowerDoc Engine: pdDocSetNumericValue: PD_NVAL_SELECT_EXTENSION: Specifies how frames should be modified at the beginning and end of each text line in Text Areas and Rich Text Areas. This has a direct impact on text selection and hit testing behavior at the edges of each text line. The following values are supported:

  - Standard
  - Extend
  - Extend & Clip
  - Fully Extend
  - Fully Extend & Clip

  See pdDocSetNumericValue in the manual for details.

* D-Type PowerDoc Engine: pdDocGetParams and pdDocSetParams are now deprecated; use pdDocGetNumericValue and pdDocSetNumericValue instead.

* D-Type PowerDoc Engine: Experimental support for OpenType color fonts with SVG data (SVG Native only).

* D-Type Unicode Text Module: txTextGetParams and txTextSetParams are now deprecated; use txTextGetNumericValue and txTextSetNumericValue instead.

* D-Type Unicode Text Module: Added two advanced examples: example_textpro_builder1 and example_textpro_builder2.

* D-Type PowerDoc Editor: View Settings -> Document -> Text Selection Color and Algorithm:

  - Standard
  - Extend
  - Extend & Clip
  - Fully Extend
  - Fully Extend & Clip

* D-Type static libraries for iOS no longer include symbol tables, resulting in much smaller file sizes.

* Small changes to the exec folder structure.

* D-Type Manuals:

  - Documented pdDocSetNumericValue, pdDocGetNumericValue, txTextSetNumericValue, txTextGetNumericValue.

  - Documented dcRasterizerMoveTo2, dcRasterizerMoveToFrac2, dcRasterizerLineTo2, dcRasterizerLineToFrac2, dcRasterizerLineTo3, dcRasterizerLineToFrac3, dcRasterizerBSplineTo2, dcRasterizerBSplineToFrac2, dcRasterizerBezierTo2, dcRasterizerBezierToFrac2

  - Updated the Text Flows and Frames page in the Workshop section.

  - Various small fixes and updates.

  - Started working on the C++ version of the manual (most parts are still under construction).


VERSION 8.0.1.2 - AUGUST 2020

* D-Type Font Engine: dtGlyphGetExtras and dtCharGetExtras can now return raw SVG data. See the manual for details.

* D-Type Text Layout Extension now includes the latest HarfBuzz 2.7.1 shaping engine.

* D-Type PowerDoc Engine: Various enhancements:

  - New Background Surface object and pdDrawBackground rendering function. See the manual for details.
  - Rectangle and Row Boundary objects now support pdRoundX and pdRoundY properties; pdRound is now an alias for pdRoundX.
  - Better handling of infinities that may arise during 2D perspective transforms.
  - Documented existing pdDrawSysGuide and pdDrawSysGuideDashed rendering functions.
  - Documented existing System Guide object.

* D-Type PowerDoc Engine: Better precision for affine and 2D perspective matrices:

  - dtype.h: Added DF_READ_FLOAT_LE and DF_WRITE_FLOAT_LE functions for reading and writing IEEE754 floating point values in little-endian format.
  - pdextras.cpp: pdxImgSelGroup now uses DF_WRITE_FLOAT_LE while pdxImgSelUngroup uses DF_READ_FLOAT_LE (the corresponding property size is either 33 or 65 bytes).
  - pdDrawGroup now supports pdTransformMatrix matrices defined as IEEE754 floating point values (the corresponding property size is either 33 or 65 bytes).
  - Transformation matrices in PowerDoc documents are now stored as IEEE754 floating point values (no longer fractional).

* D-Type PowerDoc Editor and D-Type External Format Plugin: Experimental SVG import.


VERSION 8.0.1.1 - JULY 2020

D-Type 8.0.1.1 is a major D-Type release with some exciting new features and capabilities. Below is an overview of what's new in this release. For more information see https://d-type.com/page/release8 or https://d-type.com/page/about#release_8_0

* Ultra-Fast Grayscale Rasterizer and Ultra-Fast RGBA Rasterizer incorporate two important architectural enhancements: 1) support for parallel rasterization (making it possible for many threads to rasterize the same vector description at the same time on multi-core machines); 2) the output quality has also been improved slightly.

* D-Type Font Engine provides two new functions: dtGlyphGetExtras and dtCharGetExtras. See the manual for details.

* D-Type External Format Plugin is a new library that ships with D-Type 8. This library allows clients to read and write common image and/or data compression formats, such as PNG, JPEG or GZIP/ZLIB. See https://d-type.com/page/format_plugin for details.

* Thanks to D-Type External Format Plugin, PowerDoc Engine and Unicode Text Module now support OpenType fonts with color glyph layers. This is a Microsoft extension of the OpenType format which defines a special COLR table and a supplementary CPAL table in OpenType fonts. Microsoft uses this format for their color emoji fonts on Windows.

* Thanks to D-Type External Format Plugin, PowerDoc Engine and Unicode Text Module now support the OpenType sbix table with embedded PNG and/or JPEG images. This is the format that Apple uses for their color emoji fonts on macOS.

* Thanks to the underlying HarfBuzz 2 shaping engine, the Text Layout Extension exposes an API for vertical writing. The existing lxLayoutApply and lxLayoutApplyPlus functions have been enhanced to provide two new text direction options: top-to-bottom (LX_DIRECTION_TTB) and bottom-to-top (LX_DIRECTION_BTT). See manuals/lx/funcs/lxLayoutApplyPlus.htm for details.

* Our existing example_layout_extension example has been upgraded to show how to render both horizontal and vertical text. Instead of the DrawRuns method there is now DrawRuns_Hor and DrawRuns_Ver.

* A number of improvements and small changes:

  - Updates to dtextras.cpp: dtxGlyphsDoOutput, dtxCharsDoOutput, dtxGlyphsGetBound, dtxCharsGetBound -- these functions now support vertical text (DV_SPACING_VERTICAL); glyph_arr_width is now called glyph_arr_advance and its interpretation has changed; now the first member is the offset from 0, the remaining members are advancements (or offsets from previous position), as before; glyph_arr_shift is now called glyph_arr_displacement.

  - Updates to dtextras.cpp: dtxGlyphsGetBound, dtxCharsGetBound -- added the x, y parameter.

  - Updates to dtextras.cpp: DV_SPACING_FRAC bug fix -- base_x and base_y were not added like for other modes.

  - Updates to dtengine.h: CDTEngineV7::GlyphsDoOutput, CDTEngineV7::CharsDoOutput, CDTEngineV7::GlyphsGetBound, CDTEngineV7::CharsGetBound -- these functions now support vertical text (DV_SPACING_VERTICAL); glyph_arr_width is now called glyph_arr_advance and its interpretation has changed; now the first member is the offset from 0, the remaining members are advancements (or offsets from previous position), as before; glyph_arr_shift is now called glyph_arr_displacement.

  - Updates to dtengine.h: CDTEngineV7::GlyphsGetBound, CDTEngineV7::CharsGetBound -- added the x, y parameter.

  - Power Engine: various enhancements; also fixed a bug where in some cases the underline thickness of top-to-bottom or bottom-to-top text runs could be calculated incorrectly.

  - Global updates and enhancements to D-Type manuals, a new section describing the D-Type External Format Plugin API.


VERSION 7.5.1.1 - MAY 2020

D-Type 7.5.1.1 is a major D-Type release with some exciting new features and capabilities. This is probably the most important update since the release of D-Type Engine 7.0 in August 2018. Below is an overview of what's new in this release.

All Platforms

* D-Type Font Engine now supports WOFF 2.0 (.woff2) fonts aka Web fonts. WOFF 2.0 is not a new font format per se but simply a wrapper for existing TrueType and OpenType fonts. WOFF 2.0 does however efficiently package existing fonts due to the Brotli compression algorithm. The resulting fonts typically feature a 30% reduction in file size compared to the original TrueType/OpenType fonts. Existing D-Type clients/programs that already handle TrueType, OpenType or WOFF 1.0 fonts don't need to do anything special to support WOFF 2.0 fonts. These fonts can be opened like any other TrueType/OpenType fonts. Clients only need to ensure that WOFF 1.0 and 2.0 fonts are accepted by D-Type Font Engine, which is accomplished by associating the ACCEPT_WOFF_PACKAGING configuration keyword with the corresponding Font Factory Instance in the dtype.inf initialization file. The default dtype.inf file that ships with D-Type engines already enables support for WOFF 1.0 and WOFF 2.0 fonts.

* D-Type Text Layout Extension now includes the latest HarfBuzz 2.6.6 shaping engine. This by itself is a major upgrade since HarfBuzz 2 supports OpenType fonts with Apple Advanced Typography (AAT) shaping tables. This means that fonts such as Zapfino and similar AAT fonts can be shaped as intended. This eliminates the only remaining reason for using D-Type Text Layout Extension that is based on the legacy and now obsolete ICU LayoutEngine. Starting with D-Type 7.5.1.1, D-Type Text Layout Extension will be built using exclusively the HarfBuzz shaping engine.

* For the very first time, D-Type engines ship with D-Type VIVO Image Vectorizer. See http://d-type.com/page/image_vectorizer for details. Currently the VIVO vectorizer is available as a command line program (powerdoc_pix2vec), which is located in the same folder as D-Type PowerDoc Editor. A GUI based version is planned in the future. Note that this program should be regarded as "a technology preview version" and may not be suitable for production use.

* We are no longer building D-Type evaluation libraries separately from the fully licensed libraries. Starting with D-Type 7.5.1.1 the same set of libraries is provided for both evaluation and production purposes. As a result, the users of fully licensed D-Type libraries will need to disable the evaluation mode by specifying their license credentials during the initialization of D-Type Engine. The license credentials as well as the instructions on how to disable the evaluation mode are available to all licensed users on their D-Type download page. We believe that this change will greatly simplify and streamline the building process on all supported platforms while ensuring that the fully licensed and evaluation libraries can be released simultaneously.

* We have many other improvements and small changes across the board. For example:

  - Standard Engine: UTF-8 filename support
  - Power Engine: New pdPropAddPlus function and related internal changes
  - Power Engine: Support for perspective transforms when exporting to PDF and SVG format
  - Power Engine: The pdRowBoundPtr link can be used at the Text Area level
  - Power Engine: New pdInverterArr property
  - D-Type PowerDoc Editor now supports export to GIF format.
  - Text Layout Extension: New textBuffer3_le and textBuffer3_be text types
  - Unicode Text Module: New TX_BUFFER3_LE and TX_BUFFER3_BE formats
  - Unicode Text Module: Improved hit testing precision
  - Form Engine: Rich List Box
  - Form Engine: Scrolling support for Rich Text Box and Text Box
  - All engines: New sample fonts, reorganized existing fonts
  - All engines: Updated and improved comments in fontmap.inf and dtype.fls files
  - Updated manuals (manuals/tx/manual/fontmap.htm, manuals/dt/manual/inifiles.htm)
  - Documented that UTF-8 encoding is supported when using the File Stream
  - Documented new functions dtFontFindMMInstancePlus, dtFontGetMMInstData
  - Documented DV_MMCONTRIB_TYPE_AXIS_USER1024 and DV_MMCONTRIB_TYPE_AXIS_USER16384 in dtFontAddAsMMInstancePlus
  - Documented DV_SVAL_ASC_MMAXIS_NAME_000, DV_SVAL_UNI_MMAXIS_NAME_000, DV_SVAL_ASC_MMINSTANCE_NAME_000, DV_SVAL_UNI_MMINSTANCE_NAME_000 in dtFontGetStringValue
  - Documented DV_NVAL_MMAXIS_TAG_000, DV_NVAL_MMAXIS_DEF_000, DV_NVAL_MMAXIS_MIN_000, DV_NVAL_MMAXIS_MAX_000 in dtFontGetNumericValue

Windows Specific

* On Windows D-Type libraries are now built using MS Visual Studio 2017. There are two important consequences of this: (1) D-Type dynamic libraries (.dll) will no longer work on outdated and unsupported Windows platforms, such as Windows 95 or 2000; (2) The users of *static* (.lib) D-Type libraries will need MS Visual Studio 2017 or better to link their code with D-Type. This change was necessary due to the fact that the level of C++11 support in earlier versions of MS Visual Studio is inadequate. Staying with older versions of MS Visual Studio would make it impossible to keep developing and improving D-Type on the Windows platform. Note that the users of dynamic (.dll) D-Type libraries can still use older versions of MS Visual Studio if they wish.

* All D-Type libraries are still available in both 32 and 64-bit architecture. All pre-built demo programs, D-Type Font Viewer and Optimizer, D-Type PowerDoc Editor, and D-Type VIVO Image Vectorizer are built as 32-bit binaries.

* We are retiring the Setup Program for D-Type Engines on Windows. Now D-Type engines for Windows ship in a ZIP package just like D-Type for Linux or Mac. In fact, the same ZIP package is used on all three platforms. This, again, should greatly simplify and streamline the building process of D-Type engines on all supported platforms.

Linux Specific

* On Linux D-Type libraries are now built using GCC 8.3. Note that GCC 8 uses the libstdc++.so.6 C++ Standard Library. All D-Type libraries are compiled as Position Independent Code (i.e. the -fPIC switch is enabled).

* All D-Type libraries are still available in both 32 and 64-bit architecture. However, all pre-built demo programs, D-Type Font Viewer and Optimizer, D-Type PowerDoc Editor, and D-Type VIVO Image Vectorizer are built as 64-bit binaries.

Mac Specific

* On macOS D-Type libraries are now built using clang 11 and linked with libc++. The libraries target Mac OS X version 10.8 and higher (i.e. the MACOSX_DEPLOYMENT_TARGET environment variable has been raised from 10.4 to 10.8). This means that D-Type libraries will no longer work on outdated and unsupported Mac platforms, such as Mac OS X 10.4.

* All D-Type libraries are still available in both 32 and 64-bit architecture. However, all pre-built demo programs, D-Type Font Viewer and Optimizer, D-Type PowerDoc Editor, and D-Type VIVO Image Vectorizer are built as 64-bit binaries.


# End of File
