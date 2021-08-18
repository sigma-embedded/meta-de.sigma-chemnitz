## Does not build with recent C++ standard anymore
##
## | ../../../mklibs-0.1.44/src/mklibs-readelf/elf.hpp:52:56: error: ISO C++17 does not allow dynamic exception specifications
## |    52 |       const section &get_section(unsigned int i) const throw (std::out_of_range) { return *sections.at(i); };

BUILD_CXXFLAGS += "-std=gnu++98"
