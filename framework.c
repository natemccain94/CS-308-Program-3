#include <windows.h>
#include <stdio.h>

static char buf[255];
static char inputLabel[255];

// disables warning for strcpy use.
#pragma warning(disable : 4996)

void getInput(char* inputPrompt, char* bounds, char* result, int maxChars)
{
    puts(inputPrompt);
	puts(bounds);
    gets(buf);
    buf[maxChars - 1] = '\0';
    strcpy(result,buf);
    return;
}


void showOutput(char* outputLabel, const char* outputString)
{
    puts(outputLabel);
	//puts("\n");
	puts(outputString);
	return;
}

//void sourcecaller(void);
void strcopyx(char* a, const char* b, int a_len);
void strncopyx(char* a, const char* b, int b_len, int a_len);
void strcatx(char* a, const char* b, int a_len);
void binToHexStr(unsigned char* binbuf, int binbuf_len, char* strbuf, int strbuf_len);
void hexStrToBin(char* hexStr, unsigned char* binbuf, int binbuf_len);

int main(void)
{
	// Declarations for variables used in tests.
	// Req. 1 Variables
	char testOneA[255] = {"You"};
	const char testOneB[] = {"My Hello World"};
	int a_len_one = 255;

	// Req. 2 Variables
	char testTwoA[255] = {"This is longer."};
	const char testTwoB[] = {"Shorter."};
	int a_len_two = 255;
	int b_len_two = strlen(testTwoB);

	// Req. 3 Variables
	char testThreeA[255] = {"My Name Is: "};
	const char testThreeB[] = {"Nate!"};
	int a_len_three = 255;

	// Req. 4 Variables
	unsigned char binbuf_four[] = {"11111010111110011"};
	char strbuf_four[255];
	int binbuf_four_len = strlen(binbuf_four);
	int strbuf_four_len = 255;
	
	// Req. 5 Variables
	char hexStr_five[] = "0f9";
	unsigned char binbuf_five[255];
	int binbuf_five_len = 255;

	
	// Test for Requirement 1.
	showOutput("Test for Requirement 1", " ");
	showOutput("char* a: ", testOneA);
	showOutput("const char* b: ", testOneB);	
	strcopyx(testOneA, testOneB, a_len_one);
	showOutput("char* a: ", testOneA);
	showOutput("const char* b: ", testOneB);
	showOutput("\nEnd of Test for Requirement 1", "\n");
	// End of test for Requirement 1.

	// Test for Requirement 2.
	showOutput("Test for Requirement 2", " ");
	showOutput("char* a: ", testTwoA);
	showOutput("const char* b: ", testTwoB);
	strncopyx(testTwoA, testTwoB, b_len_two, a_len_two);
	showOutput("char* a: ", testTwoA);
	showOutput("const char* b: ", testTwoB);
	showOutput("\nEnd of Test for Requirement 2", "\n");
	// End of test for Requirement 2.

	// Test for Requirement 3.
	showOutput("Test for Requirement 3", " ");
	showOutput("char* a: ", testThreeA);
	showOutput("const char* b: ", testThreeB);
	strcatx(testThreeA, testThreeB, a_len_three);
	showOutput("char* a: ", testThreeA);
	showOutput("\nEnd of Test for Requirement 3", "\n");
	// End of test for Requirement 3.
	

	// Test for Requirement 4.
	showOutput("Test for Requirement 4", " ");
	showOutput("17 binary digits, should output 5 hex digits.", " ");
	showOutput("The binary string is: ", binbuf_four);
	binToHexStr(binbuf_four, binbuf_four_len, strbuf_four, strbuf_four_len);
	showOutput("The hex string is: ", strbuf_four);
	showOutput("\nEnd of Test for Requirement 4", "\n");
	// End of test for Requirement 4.

	// Test for Requirement 5.
	showOutput("Test for Requirement 5", " ");
	showOutput("The hex string is: ", hexStr_five);
	showOutput("The binary result should have 12 digits.", " ");
	hexStrToBin(hexStr_five, binbuf_five, binbuf_five_len);
	showOutput("The binary result is: ", binbuf_five);
	showOutput("\nEnd of Test for Requirement 5", "\n");
	// End of test for Requirement 5.

	return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
    AllocConsole();
    freopen("CONIN$" , "rb", stdin);
    freopen("CONOUT$", "wb", stdout);

    //return sourcecaller();
	//sourcecaller();
	return main();
}