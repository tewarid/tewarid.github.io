---
layout: default
title: Binary serialization in .NET using reflection
tags:
---

C programmers frequently use [Winsock](http://msdn.microsoft.com/en-us/library/ms741394.aspx) helper functions such as htonl to change the [byte ordering](http://msdn.microsoft.com/en-us/library/3thek09d.aspx) of elements of a struct, and memcpy to transfer the struct to an output buffer. Migrating this kind of code can be a pain, because succinct code in C translates to a lot of code in languages that don't support pointers.

.NET has structs and reflection. These make for a really potent combination for reading and writing data to the network. [`System.Runtime.InteropServices.Marshal`](http://msdn.microsoft.com/en-us/library/System.Runtime.InteropServices.Marshal.aspx) provides methods such as Copy and PtrToStructure that can be very useful, and perform much better than the approach described here. This facility is used by .NET to access unmanaged code. If all your custom types are based on struct, you probably should use Marshal, but it will not work if you have class based types. If you are creating new types, you should be aware that structs don't support inheritance. They are extended by means of composition. The approach described in this post works with structs and classes.

The code below contains two major methods. One writes an arbitrary object to byte array and the other reads an object from byte array. The object's properties need to be decorated with DataMemberAttribute from System.Runtime.Serialization namespace. The Order property of the attribute can be specified, and determines the order in which the properties of the object will be read, or written.

An example follows

```c#
using System;
using System.Runtime.Serialization;

class FixedHeader
{
    [DataMember(Order = 1)]
    public ushort Id { get; set; }
}

class VariableHeader : FixedHeader
{
    [DataMember(Order = 2)]
    public ushort Size
    {
        get { return Payload == null? (ushort)0 : (ushort)Payload.Length; }
        set { Payload = new byte[value]; }
    }
    [DataMember(Order = 3)]
    public byte[] Payload { get; set; }
}

class Program
{
    public static void Main()
    {
        byte[] data = { 0x0, 0x1, 0x0, 0x5, 0x01, 0x02, 0x03, 0x04, 0x05 };
        MemoryCopy.MemoryCopy copy = new MemoryCopy.MemoryCopy();
        copy.ByteOrder = ByteOrder.BigEndian; // default
        FixedHeader h;
        int startIndex = 0;
        h = copy.Read(typeof(FixedHeader), data, ref startIndex, true);
        VariableHeader varh;
        varh = copy.Read(typeof(VariableHeader), data, ref startIndex, false);
        Console.WriteLine("{0:x} {1:x}", h.Id, varh.Size);
        Console.ReadLine();
    }
}
```

### Code

The Read method, sets the properties of an object, that are annotated using the DataMember attribute, using data extracted from an array of bytes. The Write method, writes out annotated properties into an array of bytes.

According to official documentation, [GetProperties](http://msdn.microsoft.com/en-us/library/kyaxdd3x.aspx) method of Type may return properties in any particular order. You need to use the Order property of DataMember to enforce the order in which values will be read. If the object inherits from another type that also has annotated properties, the inherited properties are read or ignored based on the inherit parameter. They can also be masked in subclasses, by specifying the same value for Order.

```c#
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.Serialization;

namespace MemoryCopy
{
    public enum ByteOrder
    {
        /// <summary>
        /// Determine byte order from input
        /// </summary>
        Determine = 0,
        /// <summary>
        /// Byte order is little endian
        /// </summary>
        LittleEndian,
        /// <summary>
        /// Byte order is big endian
        /// </summary>
        BigEndian
    }

    public sealed class MemoryCopy
    {
        private ByteOrder byteOrder = ByteOrder.BigEndian;

        /// <summary>
        /// Set/retrieve byte order for primitive types.
        /// </summary>
        public ByteOrder ByteOrder
        {
            get
            {
                return byteOrder;
            }
            set
            {
                byteOrder = value;
            }
        }

        /// <summary>
        /// Build an object of the specified type by reading data from the
        /// provided byte array. The types should provide a default constructor.
        /// Type can be a primitive type. If type is not a primitive type,
        /// its class should decorate its properties using the
        /// DataMemberAttribute. The Order property of that attribute can
        /// be used to determine the order in which values will be read.
        ///
        /// Supports most primitive types listed at
        /// http://msdn.microsoft.com/en-us/library/eahchzkf.aspx (and enums)
        /// except floating point types.
        ///
        /// If type is an array of primitive types, it should be initialized when
        /// its size is read from serialized data.
        ///
        /// Text data cannot be read directly. Read it as an array of bytes and
        /// handle it appropriately.
        ///
        /// </summary>
        /// <param name="t">Type of object to build</param>
        /// <param name="data">Serialized data to read</param>
        /// <param name="startIndex">Index to start reading from. Its value
        /// points to the byte after the last byte read upon return.</param>
        /// <param name="inherit">Causes inherited properties to be read when true.</param>
        /// <returns></returns>
        public object Read(Type t, byte[] data, ref int startIndex, bool inherit)
        {
            object o;
            byte[] bytes;

            if (t.IsPrimitive)
            {
                if (t == typeof(short))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(short));
                    o = BitConverter.ToInt16(bytes, 0);
                    startIndex += sizeof(short);
                }
                else if (t == typeof(ushort))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(ushort));
                    o = BitConverter.ToUInt16(bytes, 0);
                    startIndex += sizeof(ushort);
                }
                else if (t == typeof(int))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(int));
                    o = BitConverter.ToInt32(bytes, 0);
                    startIndex += sizeof(int);
                }
                else if (t == typeof(uint))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(uint));
                    o = BitConverter.ToUInt32(bytes, 0);
                    startIndex += sizeof(uint);
                }
                else if (t == typeof(byte))
                {
                    o = data[startIndex];
                    startIndex++;
                }
                else if (t == typeof(long))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(long));
                    o = BitConverter.ToInt64(bytes, 0);
                    startIndex += sizeof(long);
                }
                else if (t == typeof(ulong))
                {
                    bytes = ExtractBytes(data, startIndex, byteOrder, sizeof(ulong));
                    o = BitConverter.ToUInt64(bytes, 0);
                    startIndex += sizeof(ulong);
                }
                else
                {
                    throw new NotSupportedException("Type not supported: " + t);
                }
                return o;
            }

            // Not a primitive type

            o = Activator.CreateInstance(t);

            IList<PropertyInfo> properties = GetProperties(o, inherit);
            foreach (PropertyInfo property in properties)
            {
                object pVal;
                Type pType;

                if (property.PropertyType.IsEnum)
                {
                    pVal = property.GetValue(o, null);
                    pType = Enum.GetUnderlyingType(property.PropertyType);
                }
                else
                {
                    pVal = property.GetValue(o, null);
                    pType = pVal.GetType();
                }

                if (pType.IsPrimitive)
                {
                    property.SetValue(o, Read(pType, data, ref startIndex, inherit), null);
                }
                else if (pVal is byte[])
                {
                    int len = ((byte[])pVal).Length;
                    Array.Copy(data, startIndex, (byte[])pVal, 0, len);
                    startIndex += len;
                }
                else if (pVal is Array)
                {
                    Array a = (Array)pVal;
                    for (int i = 0; i < ((Array)pVal).Length; i++)
                    {
                        a.SetValue(Read(a.GetType().GetElementType(), data,
                            ref startIndex, inherit), i);
                    }
                }
                else
                {
                    throw new NotSupportedException("Type not supported: " + pVal.GetType());
                }
            }

            return o;
        }

        /// <summary>
        /// Serializes an object into the specified byte array. See Read method for
        /// further details.
        ///
        /// </summary>
        /// <param name="o">Object to serialize.</param>
        /// <param name="data">Byte array where serialized data will be written.</param>
        /// <param name="startIndex">Index from which to start writing data.</param>
        /// <param name="inherit">Determines whether inherited properties should be serialized.</param>
        public void Write(object o, byte[] data, ref int startIndex, bool inherit)
        {
            byte[] bytes;

            if (o.GetType().IsPrimitive)
            {
                if (o is short)
                {
                    bytes = BitConverter.GetBytes((short)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(short));
                    startIndex += sizeof(short);
                }
                else if (o is ushort)
                {
                    bytes = BitConverter.GetBytes((ushort)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(ushort));
                    startIndex += sizeof(ushort);
                }
                else if (o is int)
                {
                    bytes = BitConverter.GetBytes((int)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(int));
                    startIndex += sizeof(int);
                }
                else if (o is uint)
                {
                    bytes = BitConverter.GetBytes((uint)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(uint));
                    startIndex += sizeof(uint);
                }
                else if (o is long)
                {
                    bytes = BitConverter.GetBytes((long)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(long));
                    startIndex += sizeof(long);
                }
                else if (o is ulong)
                {
                    bytes = BitConverter.GetBytes((ulong)o);
                    ReverseBytes(bytes, byteOrder);
                    Array.Copy(bytes, 0, data, startIndex, sizeof(ulong));
                    startIndex += sizeof(ulong);
                }
                else if (o is byte)
                {
                    data[startIndex] = (byte)o;
                    startIndex++;
                }
                return;
            }

            IList<PropertyInfo> properties = GetProperties(o, inherit);

            foreach (PropertyInfo property in properties)
            {
                object pVal;
                Type pType;

                if (property.PropertyType.IsEnum)
                {
                    pType = Enum.GetUnderlyingType(property.PropertyType);
                    pVal = Convert.ChangeType(property.GetValue(o, null), pType);
                }
                else
                {
                    pVal = property.GetValue(o, null);
                    pType = pVal.GetType();
                }

                if (pType.IsPrimitive)
                {
                    Write(pVal, data, ref startIndex, inherit);
                }
                else if (pVal is byte[])
                {
                    bytes = (byte[])pVal;
                    Array.Copy(bytes, 0, data, startIndex, bytes.Length);
                    startIndex += bytes.Length;
                }
                else if (pVal is Array)
                {
                    foreach (object item in (Array)pVal)
                    {
                        Write(item, data, ref startIndex, inherit);
                    }
                }
            }
        }

        private static IList<PropertyInfo> GetProperties(object o, bool inherit)
        {
            Type type = o.GetType();
            List<PropertyInfo> properties = new List<PropertyInfo>();

            if (inherit)
            {
                Type baseType = type.BaseType;
                while (baseType != null)
                {
                    properties.InsertRange(0, baseType.GetProperties(BindingFlags.NonPublic
                        | BindingFlags.Public | BindingFlags.DeclaredOnly
                        | BindingFlags.Instance));
                    baseType = baseType.BaseType;
                }
            }

            properties.InsertRange(0, type.GetProperties(BindingFlags.NonPublic
                | BindingFlags.Public | BindingFlags.DeclaredOnly
                | BindingFlags.Instance));

            SortedList<int, PropertyInfo> sFields = new SortedList<int, PropertyInfo>();

            foreach (PropertyInfo property in properties)
            {
                object[] attributes = property.GetCustomAttributes(false);
                object attribute = Array.Find(attributes, IsDataMemberAttribute);

                if (attribute == null) continue;
                else sFields.Add(((DataMemberAttribute)attribute).Order, property);
            }
            return sFields.Values;
        }

        private static bool IsDataMemberAttribute(object o)
        {
            return o is DataMemberAttribute;
        }

        private byte[] ExtractBytes(byte[] data, int startIndex,
            ByteOrder byteOrder, int length)
        {
            byte[] bytes = new byte[length];
            Array.Copy(data, startIndex, bytes, 0, length);
            if ((byteOrder == ByteOrder.BigEndian && BitConverter.IsLittleEndian) ||
                (byteOrder == ByteOrder.LittleEndian && !BitConverter.IsLittleEndian))
            {
                return ReverseBytes(bytes);
            }
            return bytes;
        }

        private byte[] ReverseBytes(byte[] inArray, ByteOrder byteOrder)
        {
            if ((byteOrder == ByteOrder.BigEndian && BitConverter.IsLittleEndian) ||
                (byteOrder == ByteOrder.LittleEndian && !BitConverter.IsLittleEndian))
            {
                ReverseBytes(inArray);
            }

            return inArray;
        }

        private byte[] ReverseBytes(byte[] inArray)
        {
            byte temp;
            int highCtr = inArray.Length - 1;

            for (int ctr = 0; ctr < inArray.Length / 2; ctr++)
            {
                temp = inArray[ctr];
                inArray[ctr] = inArray[highCtr];
                inArray[highCtr] = temp;
                highCtr -= 1;
            }
            return inArray;
        }
    }
}
```

The [class library](https://www.nuget.org/packages/NetMemoryCopy/) is available from NuGet. You can get the source code, and contribute to its development, at [GitHub](https://github.com/tewarid/net-memory-copy).
