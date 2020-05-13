#include <string>
#include "fileRead.h"

enum errors {
    WRONG_FILE = 1
};

bool checkFile(std::string_view &fileName);

void crackFile(std::string_view &fileName);

int main(int argc, char *argv[]) {
    std::string_view fileName = argv[argc - 1];

    if (!checkFile(fileName))
        return WRONG_FILE;

    crackFile(fileName);

    return 0;
}

bool checkFile(std::string_view &fileName) {
    const int checkSum = 26752;
    const int fileSize = 8744;

    if (!fileName.ends_with("out")) {
        printf("Error: wrong file type\n");
        return false;
    }

    size_t bufferSize = 0;
    char *buffer = readTextFromFile(fileName.data(), &bufferSize);

    if (bufferSize != fileSize) {
        printf("Error: wrong file size");
        return false;
    }

    size_t sum = 0;
    for (size_t i = 0; i < bufferSize; ++i) {
        sum += buffer[i];
    }

    if (sum != checkSum) {
        printf("Error: wrong file");
        return false;
    }

    return true;
}

void crackFile(std::string_view &fileName) {
    size_t bufferSize = 0;
    char *buffer = readTextFromFile(fileName.data(), &bufferSize);
    char outFileName[] = "crackedFile.out";

    const int jmp = 4215;
    const int je1 = 4348;
    const int je2 = 4376;

    buffer[jmp] = 235;
    buffer[je1] -= 1;
    buffer[je2] -= 1;

    writeFile(outFileName, buffer, bufferSize);
}
