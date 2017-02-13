package com.smart.common.util;


import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;



/**
 * @ClassName: ByteUtil
 * @Description: 工具类-byte[]相关
 * @author zcl
 * 
 */
public class ByteUtil {
	private static String[] binaryArray =
			{"0000", "0001", "0010", "0011",
					"0100", "0101", "0110", "0111",
					"1000", "1001", "1010", "1011",
					"1100", "1101", "1110", "1111"};
	/**
	 * Convert a String of hexadecimal digits into the corresponding byte array by encoding each two hexadecimal digits as a byte.
	 * 
	 * @param digits
	 *            Hexadecimal digits representation
	 * 
	 * @exception IllegalArgumentException
	 *                if an invalid hexadecimal digit is found, or the input string contains an odd number of hexadecimal digits
	 */
	public static byte[] hexStringToByteArray(String digits) {
		String s = digits.length() % 2 > 0 ? "0" + digits : digits;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		for (int i = 0; i < s.length(); i += 2) {
			char c1 = s.charAt(i);
			if ((i + 1) >= s.length()) {
				throw new IllegalArgumentException("hexUtil.odd");
			}
			char c2 = s.charAt(i + 1);
			byte b = 0;
			if ((c1 >= '0') && (c1 <= '9'))
				b += ((c1 - '0') * 16);
			else if ((c1 >= 'a') && (c1 <= 'f'))
				b += ((c1 - 'a' + 10) * 16);
			else if ((c1 >= 'A') && (c1 <= 'F'))
				b += ((c1 - 'A' + 10) * 16);
			else
				throw new IllegalArgumentException("hexUtil.bad");

			if ((c2 >= '0') && (c2 <= '9'))
				b += (c2 - '0');
			else if ((c2 >= 'a') && (c2 <= 'f'))
				b += (c2 - 'a' + 10);
			else if ((c2 >= 'A') && (c2 <= 'F'))
				b += (c2 - 'A' + 10);
			else
				throw new IllegalArgumentException("hexUtil.bad");
			baos.write(b);
		}
		return (baos.toByteArray());

	}

	public static byte hexStrToByte(String value) {
		String s = StringUtil.fillLeftString(value, '0', 2);
		byte b = 0;
		char c1 = s.charAt(0);
		char c2 = s.charAt(1);
		if ((c1 >= '0') && (c1 <= '9'))
			b += ((c1 - '0') * 16);
		else if ((c1 >= 'a') && (c1 <= 'f'))
			b += ((c1 - 'a' + 10) * 16);
		else if ((c1 >= 'A') && (c1 <= 'F'))
			b += ((c1 - 'A' + 10) * 16);
		else
			throw new IllegalArgumentException("hexUtil.bad");

		if ((c2 >= '0') && (c2 <= '9'))
			b += (c2 - '0');
		else if ((c2 >= 'a') && (c2 <= 'f'))
			b += (c2 - 'a' + 10);
		else if ((c2 >= 'A') && (c2 <= 'F'))
			b += (c2 - 'A' + 10);
		else
			throw new IllegalArgumentException("hexUtil.bad");
		return b;
	}

	/**
	 * Convert a byte array into a printable format containing a String of hexadecimal digit characters (two per byte).
	 * 
	 * @see this method consume too much memory, especailly when large byte array.
	 * 
	 * @param bytes
	 *            Byte array representation
	 */
	public static String byteArrayToHexStr(byte bytes[]) {

		StringBuffer sb = new StringBuffer(bytes.length * 2);
		for (int i = 0; i < bytes.length; i++) {
			sb.append(digitToHexChar((bytes[i] >> 4)));
			sb.append(digitToHexChar((bytes[i] & 0x0f)));
		}
		return (sb.toString());

	}

	/**
	 * convert byte array into hex string, with , as seperator
	 * 
	 * @see this method consume too much memory, especailly when large byte array.
	 * @param bytes
	 * @return
	 */
	public static String byteArrayToHexStr2(byte bytes[]) {

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < bytes.length; i++) {
			sb.append(digitToHexChar((bytes[i] >> 4)));
			sb.append(digitToHexChar((bytes[i] & 0x0f)));
			sb.append(" ");
		}
		return (sb.toString().substring(0, sb.length() - 1));

	}

	/**
	 * Convert the specified value (0 .. 15, i.e. 4bits) to the corresponding hexadecimal digit.
	 * 
	 * @param value
	 *            Value to be converted
	 */
	private static char digitToHexChar(int value) {
		value = value & 0x0f;
		if (value >= 10)
			return ((char) (value - 10 + 'A'));
		else
			return ((char) (value + '0'));

	}

	public static String byteToHexStr(byte value) {
		StringBuffer sb = new StringBuffer();
		sb.append(digitToHexChar((value >> 4)));
		sb.append(digitToHexChar((value & 0x0f)));

		return (sb.toString());

	}

	/**
	 * Convert an int to a byte array
	 * 
	 * @param value
	 *            long
	 * @return byte[]
	 */
	public static byte[] intToByteArray(long value) {
		byte[] b = new byte[8];

		for (int i = 0; i < 8; i++) {
			int offset = (b.length - 1 - i) * 8;
			b[7 - i] = (byte) ((value >> offset) & 0xFF); // 倒序
		}
		return b;
	}

	/**
	 * change byte array into a unsigned byte array
	 * 
	 * @param source
	 * @return
	 */
	public static byte[] toUnsignedByteArray(byte[] source) {
		// ByteUtil.printByteArray(source);
		// to keep value in the 0-255
		int model = 256;
		if (source == null || source.length == 0) {
			return new byte[0];
		}
		byte[] dest = new byte[source.length];
		for (int i = 0; i < source.length; i++) {
			int tmp = ((source[i] + model) % model) & 0xff;
			dest[i] = (byte) tmp;
		}
		return dest;
	}

	/**
	 * Convert the byte array to an int starting from the given offset.
	 * 
	 * @param b
	 *            The byte array
	 * @param offset
	 * 
	 * @return The integer
	 */

	public static long byteArrayToInt(byte[] b) {
		if (b.length > 8) {
			throw new RuntimeException("more than 8 byte");
		}
		long value = 0;
		for (int i = 0; i < b.length; i++) {
			// int shift = (b.length - 1 - i) * 8;
			int shift = i * 8;
			value += (b[i] & 0xFF) << shift;
		}
		return value;
	}

	// by ZJS
	// -----------------------------------------------------------------------
	/**
	 * @Title: copyByteArray
	 * @Description: copy byte array by length
	 * @param b
	 * @param pos
	 * @param len
	 * @return byte[]
	 */
	public static byte[] copyByteArray(byte b[], int pos, int len) {
		if (pos >= b.length || (pos + len) > b.length) {
			throw new RuntimeException("array index outflow");
		}
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		baos.write(b, pos, len);
		return baos.toByteArray();
	}

	/**
	 * @Title: copyByteArrayByBit
	 * @Description: copy byte array by bit
	 * @param b
	 * @param pos
	 * @param len
	 * @return byte[]
	 */
	public static byte[] copyByteArrayByBit(byte b[], int pos, int len) {
		int bitlength = b.length * 8;
		if (pos < 0 || len < 1 || pos >= bitlength || (pos + len) > bitlength) {
			throw new RuntimeException("array bit index outflow");
		}
		byte[] tb = copyByteArray(b, pos / 8, (pos % 8 + len - 1) / 8 + 1);
		int offset = pos % 8;
		byte fb;
		for (int i = 0; i < tb.length; i++) {
			fb = tb[i];
			tb[i] = (byte) ((fb & 0xFF) >>> offset);
			if (i > 0) {
				tb[i - 1] = (byte) (tb[i - 1] | (fb << (8 - offset)));
			}
		}
		tb = copyByteArray(tb, 0, (len - 1) / 8 + 1);
		if ((len % 8) > 0) {
			tb[tb.length - 1] = (byte) (((tb[tb.length - 1] << (8 - (len % 8))) & 0xFF) >>> (8 - (len % 8)));
		}
		return copyByteArray(tb, 0, (len - 1) / 8 + 1);
	}

	/**
	 * @Title: byteArrayEqual
	 * @Description: byte array equal
	 * @param a
	 * @param b
	 * @return boolean
	 */
	public static boolean byteArrayEqual(byte a[], byte b[]) {
		if (a == null || b == null || a.length != b.length) {
			return false;
		}
		for (int i = 0; i < a.length; i++) {
			if (a[i] != b[i]) {
				return false;
			}
		}
		return true;
	}

	/**
	 * @Title: bcdbyteToUnsignedInt
	 * @Description: convert byte array to unsigned bcd int
	 * @param b
	 * @return Integer
	 */
	public static int bcdbyteToUnsignedInt(byte b) {
		return Integer.parseInt(byteToHexStr(b), 10);
	}

	/**
	 * 
	 * 
	 * @Title: bcdByteToInt
	 * @Description: convert byte to unsigned int
	 * @param b
	 * @return Integer
	 */
	public static int bcdByteToInt(byte b) {
		int value = Integer.parseInt(byteToHexStr((byte) (b & 0x7F)), 10);
		if ((b & 0x80) != 0) {
			value = 0 - value;
		}
		return value;
	}

	/**
	 * 
	 * 
	 * @Title: bcdByteArrayToInt
	 * @Description: convert byte array to signed int
	 * @param b
	 * @return Integer
	 */
	public static int bcdByteArrayToInt(byte b[]) {
		if (b.length > 8 || b.length < 1) {
			throw new RuntimeException("more than 8 byte");
		}
		StringBuffer sb = new StringBuffer();
		sb.append(byteToHexStr((byte) (b[b.length - 1] & 0x7F)));
		for (int i = b.length - 2; i > -1; i--) {
			sb.append(byteToHexStr(b[i]));
		}
		int value = Integer.parseInt(sb.toString(), 10);
		if ((b[b.length - 1] & 0x80) != 0) {
			value = 0 - value;
		}
		return value;
	}

	/**
	 * 
	 * 
	 * @Title: bcdByteArrayToUnsignedInt
	 * @Description: convert byte array to unsigned int
	 * @param b
	 * @return long
	 */
	public static long bcdByteArrayToUnsignedInt(byte b[]) {
		if (b.length > 8 || b.length < 1) {
			throw new RuntimeException("more than 8 byte");
		}
		StringBuffer sb = new StringBuffer();
		for (int i = b.length - 1; i > -1; i--) {
			sb.append(byteToHexStr(b[i]));
		}
		return Long.parseLong(sb.toString(), 10);
	}

	public static int byteToUnsignedInt(byte b) {
		return ((b + 256) % 256) & 0xFF;
	}

	/**
	 * @Title: byteToBinaryString
	 * @Description: convert byte to binary string
	 * @param b
	 * @return String
	 */
	public static String byteToBinaryString(byte b) {
		return StringUtil.strSwap(StringUtil.fillLeftString(Integer.toBinaryString(b & 0xFF), '0', 8));

	}

	/**
	 * @Title: byteToBinaryString
	 * @Description: convert byte array to binary string
	 * @param b
	 * @return String
	 */
	public static String byteToBinarryString(byte b[]) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < b.length; i++) {
			sb.append(byteToBinaryString(b[i]));
		}
		return sb.toString();
	}

	/**
	 * 
	 * 
	 * @Title: binarrayStringToByte
	 * @Description: convert binary string to byte array
	 * @param s
	 * @return byte[]
	 */
	public static byte[] binarrayStringToByte(String s) {
		byte[] b = new byte[s.length() / 8 + ((s.length() % 8) == 0 ? 0 : 1)];
		for (int i = 0; i < s.length(); i++) {
			if (s.charAt(i) == '1') {
				b[i / 8] = (byte) (b[i / 8] | (1 << (i % 8)));
			}
		}
		return b;
	}

	/**
	 * @Title: byteSwap
	 * @Description: byte array swap
	 * @param b
	 * @return byte[]
	 */
	public static byte[] byteSwap(byte b[]) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		for (int i = b.length - 1; i >= 0; i--) {
			baos.write(b[i]);
		}
		return baos.toByteArray();
	}

	/**
	 * 
	 * 
	 * @Title: getByteLeftFilter
	 * @Description: get byte filter,left
	 * @param n
	 * @return byte
	 */
	public static byte getByteLeftFilter(int n) {
		byte b = 0;
		for (int i = 0; i < n; i++) {
			b = (byte) (b | (1 << i));
		}
		return b;
	}

	/**
	 * 
	 * 
	 * @Title: getByteRightFilter
	 * @Description: get byte filter,right
	 * @param n
	 * @return byte
	 */
	public static byte getByteRightFilter(int n) {
		return (byte) (~getByteLeftFilter(n));
	}

	/**
	 * @Title: shlByteArray
	 * @Description: byte array <<
	 * @param b
	 * @param len
	 * @return byte[]
	 */
	public static byte[] shlByteArray(byte b[], int len) throws IOException {
		int bytelen = b.length * 8;
		if (len > bytelen) {
			throw new RuntimeException("byte array shift overflow!");
		}
		byte[] tb = copyByteArrayByBit(b, 0, bytelen - len);
		int offset = len % 8;
		for (int i = tb.length - 1; i > -1; i--) {
			if (i < tb.length - 1) {
				tb[i + 1] = (byte) (tb[i + 1] | ((tb[i] & 0xFF) >>> (8 - offset)));
			}
			tb[i] = (byte) (tb[i] << offset);
		}
		if (tb.length == b.length) {
			return tb;
		}
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		for (int i = 0; i < (b.length - tb.length); i++) {
			baos.write(0);
		}
		baos.write(tb);
		return baos.toByteArray();
	}

	/**
	 * @Title: shrByteArray
	 * @Description: byte array >>>
	 * @param b
	 * @param len
	 * @return byte[]
	 */
	public static byte[] shrByteArray(byte b[], int len) throws IOException {
		int bytelen = b.length * 8;
		if (len > bytelen) {
			throw new RuntimeException("byte array shift overflow!");
		}
		byte[] tb = copyByteArrayByBit(b, len, bytelen - len);
		if (tb.length == b.length) {
			return tb;
		}
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		baos.write(tb);
		for (int i = 0; i < (b.length - tb.length); i++) {
			baos.write(0);
		}
		return baos.toByteArray();
	}

	/**
	 * 
	 * 
	 * @Title: filterByte
	 * @Description: filt byte array by startbit and endbit
	 * @param b
	 * @param startbit
	 * @param endbit
	 * @return byte[]
	 */
	public static byte[] filterByte(byte b[], int startbit, int endbit) {
		int bytelen = b.length * 8;
		if (startbit < 0 || endbit < 0 || startbit >= bytelen || endbit >= bytelen || startbit > endbit) {
			throw new RuntimeException("byte array filter overflow!");
		}
		int startbyte = startbit / 8;
		int endbyte = endbit / 8;
		for (int i = 0; i < startbyte; i++) {
			b[i] = 0;
		}
		for (int i = endbyte + 1; i < b.length; i++) {
			b[i] = 0;
		}
		if (startbit % 8 > 0) {
			b[startbyte] = (byte) (b[startbyte] & getByteRightFilter(startbit % 8));
		}
		if ((endbit + 1) % 8 > 0) {
			b[endbyte] = (byte) (b[endbyte] & getByteLeftFilter((endbit + 1) % 8));
		}
		return b;
	}

	/**
	 * 
	 * 
	 * @Title: fillByte
	 * @Description: fill byte array
	 * @param b
	 * @param n
	 * @param len
	 * @return byte[]
	 */
	public static byte[] fillByte(byte b[], int n, int len) throws IOException {
		byte[] tb = b == null ? new byte[0] : b;
		if (tb.length < len) {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			baos.write(tb);
			for (int i = tb.length; i < len; i++) {
				baos.write(n);
			}
			return baos.toByteArray();
		}
		if (b.length == len) {
			return tb;
		}
		return copyByteArray(tb, 0, len);
	}

	/**
	 * 
	 * 
	 * @Title: fillByte
	 * @Description: fill byte array by 0
	 * @param b
	 * @param len
	 * @return byte[]
	 */
	public static byte[] fillByte(byte b[], int len) throws IOException {
		return fillByte(b, 0, len);
	}

	/**
	 * 
	 * 
	 * @Title: byteOr
	 * @Description: byte array |
	 * @param b1
	 * @param b2
	 * @return byte[]
	 */
	public static byte[] byteOr(byte b1[], byte b2[]) throws IOException {
		int len = b1.length >= b2.length ? b1.length : b2.length;
		byte[] tb = null;
		tb = fillByte(tb, len);
		for (int i = 0; i < b1.length; i++) {
			tb[i] = (byte) (tb[i] | b1[i]);
		}
		for (int i = 0; i < b2.length; i++) {
			tb[i] = (byte) (tb[i] | b2[i]);
		}
		return tb;
	}

	/**
	 * 
	 * 
	 * @Title: byteAnd
	 * @Description: byte array &
	 * @param b1
	 * @param b2
	 * @return byte[]
	 */
	public static byte[] byteAnd(byte b1[], byte b2[]) throws IOException {
		int len = b1.length >= b2.length ? b2.length : b1.length;
		byte[] tb = null;
		tb = fillByte(tb, len);
		for (int i = 0; i < len; i++) {
			tb[i] = (byte) (b1[i] & b2[i]);
		}
		return tb;
	}

	/**
	 * @Title: byteToPos
	 * @Description: 计算字节第几位为1
	 * @param b
	 * @return int
	 */
	public static final int byteToPos(int b) {
		for (int i = 0; i < 8; i++) {
			if ((b & (1 << i)) != 0) {
				return i + 1;
			}
		}
		return 0;
	}

	/**
	 * @Title: posToByte
	 * @Description: 按字节第几位是1 生成byte
	 * @param b
	 * @return int
	 */
	public static final int posToByte(int b) {
		return 1 << (b - 1);
	}

	/**
	 * 
	 * @Title: posToByte
	 * @Description: 按字节第几位是1 设置byte，高字节在前
	 * @param b
	 * @param n
	 *            void
	 * 
	 */
	public static final void posToByte(byte b[], int n) {

		int index = b.length - (n - 1) / 8 - 1;
		if (index >= b.length) {
			return;
		}

		int pos = (n - 1) % 8;
		b[index] = (byte) (b[index] | (1 << pos));
	}

	public static final List<Integer> byteToPos(byte b[]) {
		List<Integer> lst = new ArrayList<Integer>();
		for (int i = b.length - 1; i >= 0; i--) {
			for (int j = 0; j < 8; j++) {
				if ((b[i] & (1 << j)) != 0) {
					lst.add((b.length - i - 1) * 8 + j + 1);
				}
			}
		}
		return lst;
	}

	private static final String formatFromTo(int start, int end, char spr_fromto) {
		if (start == end) {
			return String.valueOf(start);
		}
		return String.format("%1$d%2$s%3$d", start, spr_fromto, end);
	}

	public static final String byteToPosStr(byte b[], char spr_item, char spr_formto) {
		List<Integer> lst = byteToPos(b);
		if (lst.size() == 0) {
			return "";
		}
		int start = lst.get(0);
		int end = start;
		StringBuffer sb = new StringBuffer();
		for (int i = 1; i < lst.size(); i++) {
			if (lst.get(i) != (end + 1)) {
				sb.append(formatFromTo(start, end, spr_formto));
				sb.append(spr_item);
				start = lst.get(i);
				end = start;
			} else {
				end++;
			}
		}
		sb.append(formatFromTo(start, end, spr_formto));
		return sb.toString();
	}

	/**
	 * 
	 * @Title: search
	 * @Description: byte array search
	 * @param b
	 * @param key
	 * @return int
	 * 
	 */
	public static final int search(byte b[], byte key) {
		for (int i = 0; i < b.length; i++) {
			if (b[i] == key) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * 
	 * @Title: search
	 * @Description: int array search
	 * @param b
	 * @param key
	 * @return int
	 * 
	 */
	public static final int search(int b[], int key) {
		for (int i = 0; i < b.length; i++) {
			if (b[i] == key) {
				return i;
			}
		}
		return -1;
	}
	
	//按字节-33字符串
	public static final String dec33(String str){
		
		String result = "";
		for(int i=0; i<str.length()/2; i++) {
			String tmp = Integer.toHexString((Integer.parseInt(str.substring(i*2, i*2+2) ,16) +256 -Integer.parseInt("33",16)) % 256);
			if (tmp.length() < 2) {
				tmp = "0" + tmp;
			}
			result += tmp;
		}
		return result;
		
	}
	/**
	 *
	 * @param str
	 * @return 转换为二进制字符串
	 */
	public static String bytes2BinaryStr(byte[] bArray){

		String outStr = "";
		int pos = 0;
		for(byte b:bArray){
			//高四位
			pos = (b&0xF0)>>4;
			outStr+=binaryArray[pos];
			//低四位
			pos=b&0x0F;
			outStr+=binaryArray[pos];
		}
		return outStr;

	}

}