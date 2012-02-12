/* Author : Yann Sionneau <yann [at] minet dot net>
 * License : GNU GPLv2
 */

#include <stdio.h>

int main(int argc, char **argv) {
	FILE *fp;
	unsigned char c;
	unsigned char i = 0;

	if (argc < 2) {
		printf("usage : %s file\n", argv[0]);
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
		printf("%02X", c);
		if (i == 3)
			puts("");
		i++;
		i %= 4;
	}

	fclose(fp);

	return 0;
}
