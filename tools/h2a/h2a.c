/* Author : Yann Sionneau <yann [at] minet dot net>
 * License : GNU GPLv2
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	FILE *fp;
	int c;
	unsigned char i = 0;
	unsigned int line = 0;

	if (argc < 2) {
		printf("usage : %s file [max_padding_addr]\n", argv[0]);
		return -1;
	}

	fp = fopen(argv[1], "r");

	if (!fp) {
		perror("Error opening file : ");
		return -1;
	}

	while (!feof(fp))
	{
		c = fgetc(fp);
		if (c == -1)
			break;
		printf("%02X", (unsigned char)c);
		if (i == 3) {
			puts("");
			++line;
		}
		i++;
		i %= 4;
	}

	if (argc == 3) {
		unsigned int padding;
		unsigned int j;
		unsigned int max;

		padding = atoi(argv[2]);

		if (padding <= line)
			return 0;

		max = padding - line;

		for (j = 0 ; j < max ; ++j)
			printf("%08X\n", j);
	}

	fclose(fp);

	return 0;
}
