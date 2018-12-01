# Bandit
These are the easiest problems of the wargame prepping us for the reverse engineering and tougher challenges that lie ahead. We have a series of 34 machines to ssh into, and each machine holds the password to the next machine. It is highly recommended to solve the challenges on your own before proceeding to look for the solution. The solutions provided are for educational purposes only. The flags are in the file , bandit_flags.txt.

Useful  Resources are(not exhaustive in any sense).
<ul>
	<li>
		<a href="https://www.gnu.org/software/sed/manual/sed.html">SED Manual</a>
	</li>
</ul>
<ul>
	<li>
		<h3>Bandit0</h3>
		Simply cat of the file, which reveals the flag. 
	</li>
	<li>
		<h3>Bandit1</h3>
		The filename has hyphen. So "cat" has to be told the filename is not a aprameter, so it was fed from the stdin using the following command.
		<pre>
			cat &lt -
		</pre>
		The flag is then revealed.
	</li>
	<li>
		<h3>Bandit2</h3>
		There are spaces in the filename. Easier than the last one, use cat "spaces in the filename".
	</li>
	<li><h3>Bandit3</h3>
		The file is hidden, and seeing the hidden files via 
		<pre>
			ls -al 
		</pre>
		will reveal the name of the file which can be then read
	</li>
	<li>
		<h3>Bandit4</h3>
		Familiarity with the usage of the <b>find</b> command in UNIX.
		More information can be found on the man page of the find command.
		which can be used to even chain executing commands on the results of the find like below
		The file command gives details about the files in the directory. So? We can pipe the results of the find command to the file command and voila.
		<pre>
			man file
		</pre>
		For finding executable one can use this, (is certainly one of the cleaner ways to do this)
		<pre>
			find -type f | xargs file | grep text
		</pre>
		We use the find command to restrict the file size, and specify that we are looking for a file
		and then pipe it to xargs file (Argument of file command), then using gre[]
	</li>
	<li>
		<h3>
			Bandit5
		</h3>
		Simple modification of the challenge 4. Only catch is implemented in the size command which cna be used by -size option. The command to be used here is as follows.
		<pre>
			find -type f | xargs file | grep text
		</pre>
	<li>
		<h3>
			Bandit6
		</h3>
		We can use the find command to locate the necessary group and username owner of the file.
		<pre>
			find / -user bandit7 -group bandit6 -size 33c 2&gt/dev/null
		</pre>
	</li>
	<li>
		<h3>
			Bandit7
		</h3>
		No find command required, since it is already given to us. We can use awk, or sed to search for strings within the fiel, but in this case simple grep can do the job. 
		<pre>
			sed -n '10,$ { /millionth/ { =; p; } }' data.txt
		</pre>
	</li>
	<li>
		<h3>
			Bandit8
		</h3>
		We have to find a non unique line. We can use <i>uniq</i> command, but it only works on adjacent lines so we need to sort. Hence the following chain.
		<pre>
			sort data.txt | uniq -u
		</pre>
	</li>
	<li>
		<h3>Bandit9</h3>
		Find a human readable line within a file (ASCII Text), which begins with "==". Here we can use the <i>strings</i> command, followed by a grep.
		<pre>
			strings data.txt | grep ^==
		</pre>
	</li>
	<li>
		<h3>Bandit10</h3>
		Simple base64 decode of the data present in data.txt
		<pre>
			base64 -d data.txt 
		</pre>
	</li>
	<li>
		<h3>Bandit11</h3>
		Using sed, which is a beast of a tool. One may use <i>tr</i> tool as well

		```
sed -e "y/${alpha}/${alpha:$rot}${alpha::$rot}/" -e "y/${beta}/${beta:$rot}${beta::$rot}/" data.txt
		```
		
	</li>
</ul>