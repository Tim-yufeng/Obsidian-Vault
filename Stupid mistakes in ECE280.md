## I/O 

- Without `using namespace std;`,  yet forget to write `std::` before `ifstream` and `stringstream` ?
- Who wrote this `std::ifstream iFile_s.open(speciesFile);` ???
		should be `std::ifstream iFile_s; iFile_s.open(speciesFile);` 
- 