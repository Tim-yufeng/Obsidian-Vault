## I/O 

- Without `using namespace std;`,  yet forget to write `std::` before `ifstream` and `stringstream` ?
- Who wrote this `std::ifstream iFile_s.open(speciesFile);` ???
		should be `std::ifstream iFile_s; iFile_s.open(speciesFile);` 


## Basic Cpp
- ```cpp
  case opcode_t::CALLPLUGIN:

            std::string plg_nm = creature.species->pluginNames[inst.pluginSlot];
            ...
            break;
  ```
  where's `{}` for `case` ?
  