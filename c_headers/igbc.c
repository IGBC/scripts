char[2] igbc_char_hex(char num) {
	char lower = num & 0x0F;
	char upper = (num >> 4) & 0x0F;
	char out[2];
	switch (upper) {
	case 0x00: out[0] = '0'; break;
	case 0x01: out[0] = '1'; break;
	case 0x02: out[0] = '2'; break;
	case 0x03: out[0] = '3'; break;
	case 0x04: out[0] = '4'; break;
	case 0x05: out[0] = '5'; break;
	case 0x06: out[0] = '6'; break;
	case 0x07: out[0] = '7'; break; 
	case 0x08: out[0] = '8'; break;
	case 0x09: out[0] = '9'; break;
	case 0x0A: out[0] = 'A'; break;
	case 0x0B: out[0] = 'B'; break;
	case 0x0C: out[0] = 'C'; break;
	case 0x0D: out[0] = 'D'; break;
	case 0x0E: out[0] = 'E'; break;
	case 0x0F: out[0] = 'F'; break;
	}

	switch (lower) {
	case 0x00: out[1] = '0'; break;
	case 0x01: out[1] = '1'; break;
	case 0x02: out[1] = '2'; break;
	case 0x03: out[1] = '3'; break;
	case 0x04: out[1] = '4'; break;
	case 0x05: out[1] = '5'; break;
	case 0x06: out[1] = '6'; break;
	case 0x07: out[1] = '7'; break; 
	case 0x08: out[1] = '8'; break;
	case 0x09: out[1] = '9'; break;
	case 0x0A: out[1] = 'A'; break;
	case 0x0B: out[1] = 'B'; break;
	case 0x0C: out[1] = 'C'; break;
	case 0x0D: out[1] = 'D'; break;
	case 0x0E: out[1] = 'E'; break;
	case 0x0F: out[1] = 'F'; break;
	}

	return out;
}

char *__hexify(void* data, int size) {
	char *out = malloc(size * 3); // 3 chars per byte.
	int i = 0;
	for (i = 0; i < size; i++) {
		out[i * 3] = igbc_char_hex(data[i]);
		out[(i * 3) + 2] = ' ';
	}
	out[(size * 3) - 1] = '\0'; //add null terminator
	return out;
}

#define hexify(T) __hexify(&T, sizeof(T));