/*
 * Copyright (C) 1996-2020 D-Type Solutions
 * Web Site: http://www.d-type.com
 * E-mail: info@d-type.com
 */


DT_ID_ULONG GetFilteredChar(DT_ID_ULONG char_code, DT_ULONG flags)
{
	if (((flags &  1) == 0) && (char_code == 9)) return 0; /* Don't accept TAB as a character (because it's more useful as a control key -- especially with SHIFT) */
	if (((flags &  2) == 0) && (char_code == 25)) return 0; /* Don't accept SHIFT+TAB as a character */
	if (((flags &  4) == 0) && (char_code == 27)) return 0; /* Don't accept ESCAPE as a character */
	if (((flags &  8) == 0) && (char_code == 8 || char_code == 127)) return 0; /* BAKSPACE and DELETE are not characters (but delete instructions) */
	if (((flags & 16) == 0) && (char_code >= 57344 && char_code <= 63743)) return 0; /* also exclude PUA characters */
	return char_code;
}
