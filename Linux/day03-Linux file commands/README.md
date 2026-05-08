## Linux Fundamentals: Read and Write Text Files
Practice basic file read/write using fundamental commands:
 - Creating a file
 - Writing text to a file
 - Appending new lines
 - Reading the file back

---

Steps:

1. Create a file named notes.txt
2. Write 3 lines into the file using redirection (> and >>)
3. Use cat to read the full file
4. Use head and tail to read parts of the file
5. Use tee once to write and display at the same time

Command flow:

Creating, writing into a file:

1. touch notes.txt
2. echo "Line 1" > notes.txt
3. echo "Line 2" >> notes.txt
4. echo "Line 3" | tee -a notes.txt
5. cat notes.txt
6. head -n 2 notes.txt
7. tail -n 2 notes.txt

Deleting content in a file:

1. Delete all lines containing content 'Line 3' -
     `sed -i '/Line 3/d' notes.txt`

2. Delete only the last line -
     `sed -i '$d' notes.txt`

3. Deleting a specific line number -
     `sed -i '3d' notes.txt`



