---
layout: default
title: Use Tile Studio to construct tiled maps
tags: tile studio game 2d map
comments: true
---

[Tile Studio](http://tilestudio.sourceforge.net/) is a free and open source utility for making tile based games. 

The key features of Tile Studio are

1. Manage several tile sets in a single project. Multiple maps can be created with each tile set.

2. Bitmap editor for editing tiles.

3. Specify bounds for collision detection. The left, right, top, bottom and diagonals of a cell can be marked. The bounds can be exported, along with other map data, to be used in games or applications.

4. Specify a one byte map code for any cell in the map. This can be used to tag each cell with a special value which can indicate, among other things, enemy positions in games.

5. Create and use animated tiles.

6. Export tile sets to image files in bitmap or PNG format.

7. Export map data to binary files.

8. Generate game code using templates.

![tilestudio](/assets/img/tilestudio.jpg)

### Exporting the tile map

Tile Studio provides means to export map data to files by means of templates that can produce complete source code or just simple text or binary files.

In the example template `export.tsd` below we do two things

1. Export the tile set images to PNG files.

2. Produce a binary file containing a sequence of 32-bit integer values, by reading the map data row by row. Each 32-bit integer is a result of the concatenation of the tile index, the bound values and the map code. We assume that we will have no more than 2^15 – 1 i.e. 32,767 tiles in each tile set.

The image files created by Tile Studio can and should be optimized further using image manipulation tools that optimize the color palette and other aspects. Programs such as [pngout](http://advsys.net/ken/util/pngout.htm), that optimize the image size further by using better compression, can also be used.

```text
;
; Create the tile set bitmap. The width by default has been limited to 160
; pixels. Adjust this as required.
;
#tileset
#tilebitmap <TileSetIdentifier>.png 160
#end tilebitmap
#end tileset

;
; Generate binary files containing map data. The file format is an
; ordinary sequence of 32 bit values.
;
#tileset
#map
; concatenate tile number, bounds data and map value into a 32 bit value
#binfile <MapIdentifier>.bin 32
#mapdata
<TileNumber:"16"><BoundMapValue:"16">
#end mapdata
#end binfile
#end map
#end tileset
```

### Compressing map data

The binary file exported from Tile Studio can be optimized further to reduce size of resources of games and applications. Unfortunately, the template language provided by the tool itself is quite limited. We built a Java utility `TileStudioUtil.java` that is reproduced below. Have a look at the javadoc of the `writeSparseMatrix` method, to get a notion of the format used in the output file created by the utility.

The utility can be executed in the following manner

```cmd
java TileStudioUtil diags.bin diags.map 20 20 1
```

```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

public class TileStudioUtil {

    private static final int INFILE_INDEX = 0;

    private static final int OUTFILE_INDEX = 1;

    private static final int HEIGHT_INDEX = 2;

    private static final int WIDTH_INDEX = 3;

    private static final int INDEXSIZE_INDEX = 4;

    private static final int NUM_ARGUMENTS = 5;

    /**
     * Main method.
     *
     * @param args
     *            Arguments to the main method
     */
    public static void main(String[] args) {
        try {
            System.out.println(args.length + " arguments received.");
            if (args.length < NUM_ARGUMENTS) {
                System.out
                        .print("Command line options: ");
                System.out
                        .println("infile outfile height width indexSize");
                System.out
                        .print("infile\t\t");
                System.out
                        .println("The binary file exported from Tile Studio");
                System.out
                        .print("outfile\t\t");
                System.out
                        .println("The binary file exported by this program");
                System.out.println("height\t\tThe height of the matrix");
                System.out.println("width\t\tThe width of the matrix");
                System.out
                        .print("indexSize\tThe storage size of the matrix");
                System.out
                        .println("index in bytes");
                System.exit(0);
            }

            int indexSize = Integer.parseInt(args[INDEXSIZE_INDEX]);
            int width = Integer.parseInt(args[WIDTH_INDEX]);
            int height = Integer.parseInt(args[HEIGHT_INDEX]);
            int a[][] = new int[height][width];
            InputStream in;
            OutputStream out;

            System.out.println("Reading file " + args[INFILE_INDEX]);
            in = new FileInputStream(args[INFILE_INDEX]);
            readMatrix(in, a, height, width);
            in.close();

            System.out.println("Writing file " + args[OUTFILE_INDEX]);
            out = new FileOutputStream(args[OUTFILE_INDEX]);
            writeSparseMatrix(out, a, height, width, indexSize);
            out.close();

            System.out.println("Testing file written");
            int b[][] = new int[height][width];
            in = new FileInputStream(args[OUTFILE_INDEX]);
            readSparseMatrix(in, b, height, width, indexSize);
            in.close();

            // Compare
            for (int i = 0; i < height; i++) {
                for (int j = 0; j < width; j++) {
                    if (a[i][j] != b[i][j]) {
                        System.out.println("Different data at row " + i
                                + ", column " + j);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    /**
     * Read an int value from an array of bytes.
     *
     * @param data
     *            an array of bytes, only the first four elements are read
     * @param littleEndian
     *            Pass true if the least signficant byte is stored in the first
     *            element of the byte array
     *
     * @return int value
     * @throws IllegalArgumentException
     */
    public static int toInt(byte[] data, boolean littleEndian)
            throws IllegalArgumentException {
        int val = 0;

        if (littleEndian) {
            for (int i = 0; i < data.length; i++) {
                val += (data[i] & 0xFF) << (i * 8);
            }
        } else { // big endian
            for (int i = 0; i < data.length; i++) {
                val += (data[i] & 0xFF) << ((data.length - i - 1) * 8);
            }
        }

        return val;
    }

    /**
     * Write an int to an array of bytes.
     *
     * @param i
     *            The int value to write
     * @param data
     *            The byte array to write to
     * @param littleEndian
     *            If set to true the least significant byte is stored first
     * @throws IllegalArgumentException
     */
    public static void toByteArray(int i, byte[] data, boolean littleEndian)
            throws IllegalArgumentException {
        if (data.length < 4) {
            throw new IllegalArgumentException("Need at least 4 bytes");
        }

        if (littleEndian) {
            data[3] = (byte) ((i >>> 24) & 0xFF);
            data[2] = (byte) ((i >>> 16) & 0xFF);
            data[1] = (byte) ((i >>> 8) & 0xFF);
            data[0] = (byte) (i & 0xFF);
        } else {
            data[0] = (byte) ((i >>> 24) & 0xFF);
            data[1] = (byte) ((i >>> 16) & 0xFF);
            data[2] = (byte) ((i >>> 8) & 0xFF);
            data[3] = (byte) (i & 0xFF);
        }
    }

    /**
     * Reads an int matrix in binary format into an array. The file structure is
     * a simple sequence of int values. Each int is little endian. All int
     * values in the first row are stored sequentially followed by all int
     * values in the second row and so on.
     *
     *
     * @param file
     *            Binary file
     * @param array
     *            Data array
     * @param width
     *            The array width
     * @param height
     *            The array height
     * @throws IOException
     */
    public static void readMatrix(InputStream in, int array[][], int rows,
            int columns) throws IOException {
        byte[] data = new byte[4];
        int n, r, c;

        r = 0;
        while (r < rows) {
            c = 0;
            while (c < columns) {
                n = in.read(data);
                if (n == -1)
                    throw new IOException("Error reading map data at row " + r
                            + " and column " + c);
                array[r][c] = toInt(data, true);
                c++;
            }
            r++;
        }

    }

    /**
     * Writes a sparse matrix to a binary format. The binary format is a simple
     * structure as represented in the BNF notation below:
     *
     * <pre>
     *       number_of_types (type number_of_positions (positions)+)+
     *       number_of_types ::= int value
     *       type ::= int value
     *       number_of_positions ::= int value
     *       positions ::= row column
     *       row ::= int value stored in indexSize bytes
     *       column ::= int value stored in indexSize bytes
     * </pre>
     *
     * A type is any unique value, other than zero, that occurs at least once
     * in the array.
     *
     * @param out
     *            Binary output stream
     * @param array
     *            Data array
     * @param rows
     *            The number of rows in the matrix
     * @param columns
     *            The number of columns in the matrix
     * @param indexSize
     *            Size in bytes of row or column index
     *
     * @throws IOException
     */
    public static void writeSparseMatrix(OutputStream out, int array[][],
            int rows, int columns, int indexSize) throws IOException {
        byte[] data; // a byte array to store int
        Hashtable table = new Hashtable(); // a hashtable to store type
                                            // locations
        int r, c;
        Integer type; // A type (unique value) in the array
        Vector positions; // a vector to store positions of a type
        Enumeration keys;
        Iterator p;

        // Analyze data and store it in an optimized format in memory
        for (r = 0; r < rows; r++) {
            for (c = 0; c < columns; c++) {
                if (array[r][c] == 0)
                    continue;

                type = new Integer(array[r][c]);
                if (table.containsKey(type)) {
                    positions = ((Vector) table.get(type));
                } else {
                    positions = new Vector();
                    table.put(type, positions);
                }
                data = new byte[4];
                toByteArray(r, data, true);
                positions.add(data);
                data = new byte[4];
                toByteArray(c, data, true);
                positions.add(data);
            }
        }

        // Dump sparse matrix to binary file

        data = new byte[4];

        // write number of types
        toByteArray(table.size(), data, true);
        out.write(data);

        keys = table.keys();
        while (keys.hasMoreElements()) {
            type = (Integer) keys.nextElement();

            // write type
            toByteArray(type.intValue(), data, true);
            out.write(data);

            positions = (Vector) table.get(type);

            // write number of positions the type occurs
            toByteArray(positions.size() / 2, data, true);
            out.write(data);

            // write positions of type
            p = positions.iterator();
            while (p.hasNext()) {
                out.write((byte[]) p.next(), 0, indexSize);
            }
        }

    }

    /**
     * Read a sparse matrix from a binary format.
     *
     * @param file
     *            File with binary data
     * @param array
     *            Array to write to
     * @param rows
     *            Rows in the matrix
     * @param columns
     *            Columns in the matrix
     * @param indexSize
     *            The storage size of the matrix index in bytes
     * @throws IOException
     *
     * @see #writeSparseMatrix(OutputStream, int[][], int, int, int)
     */
    public static void readSparseMatrix(InputStream in, int array[][],
            int rows, int columns, int indexSize) throws IOException {
        byte[] data = new byte[4]; // a byte array to store int
        byte[] pos = new byte[indexSize]; // a byte array to store position
        int bytesRead, numTypes, t, type, numPositions, n, r, c;

        // Read sparse matrix from binary file

        // read number of types
        bytesRead = in.read(data);
        if (bytesRead == -1)
            throw new IOException("Error reading number of types");
        numTypes = toInt(data, true);

        for (t = 0; t < numTypes; t++) {
            // read type
            bytesRead = in.read(data);
            if (bytesRead == -1)
                throw new IOException("Error reading type");
            type = toInt(data, true);

            // read number of positions
            bytesRead = in.read(data);
            if (bytesRead == -1)
                throw new IOException("Error reading number of positions");
            numPositions = toInt(data, true);

            for (n = 0; n < numPositions; n++) {
                // read row
                bytesRead = in.read(pos);
                if (bytesRead == -1)
                    throw new IOException("Error reading row");
                r = toInt(pos, true);
                // read column
                bytesRead = in.read(pos);
                if (bytesRead == -1)
                    throw new IOException("Error reading column");
                c = toInt(pos, true);

                array[r][c] = type;
            }

        }

    }
}
```

[Tiled](http://www.mapeditor.org/) is another neat editor for creating tiled maps.
