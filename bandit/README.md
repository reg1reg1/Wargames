# Bandit
These are the easiest problems of the wargame prepping us for the reverse engineering and tougher challenges that lie ahead. We have a series of 34 machines to ssh into, and each machine holds the password to the next machine. It is highly recommended to solve the challenges on your own before proceeding to look for the solution. The solutions provided are for educational purposes only. The flags are in the file , bandit_flags.txt.

Useful  Resources are(not exhaustive in any sense).
<ul>
	<li>
		<a href="https://www.gnu.org/software/sed/manual/sed.html">SED Manual</a>
	</li>
	<li>
		<a href="https://linuxize.com/post/how-to-use-linux-screen/#detach-from-linux-screen-session">Using screen, a terminal multiplexer</a>
	</li>
	<li>
		<a href="https://linux.die.net/man/">Linux Man pages</a>
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
		<pre>
sed -e "y/${alpha}/${alpha:$rot}${alpha::$rot}/" -e "y/${beta}/${beta:$rot}${beta::$rot}/" data.txt
		</pre>
		What sed is basically a stream editor
		First of all there are 2 stream editor  expressions in place.
	</li>
	<li>
		<h3>Bandit12</h3>
		The challenge basically involves uncompressing a file which has been compressed multiple times, using different forms of compression. One could write a program to uncompress the file automatically based on the compression types. 
		The whole idea is to identify the file compression type , and then uncompress accordingly.
		Since it is in the hexdump representation of a file, the first step would be to get the file back from the hex representation.</br>
		<b>Steps</b>
		<ul>
		<li>
		Create a copy of the file and move it to a created directory in /tmp. This is because the directory in which the file is located in does not have write access for the user. 
		</li>
		<li>
			<p> xxd is an utility that helps reverse and generate hexdumps of files.</p>
			<pre>
			xxd -revert data &gt datahex
			</pre>
		</li>
		<li>
		These are the sequence of commands that were performed to uncompress a file. Each one is preceded by checking the file type of the output using the <i>file</i> command.
		<pre>
        zcat revhex &gt data_zcatted
        bzip2 -d data_zcatted
        zcat data_zcatted.out &gt data_zcatted_again
        tar -xvf data_zcatted_again
        tar -xvf data5.bin
        bzip2 -d data6.bin
        tar -xvf data6.bin.out
        zcat data8.bin &gt data8_zcatted
	</pre>
	</li>
	</ul>
	</li>
	<li>
	<h3>Bandit13</h3>
	Simple ssh using an already present and generated private RSA key for the next user.
	<pre>
		ssh -i sshkey.private bandit14@localhost
	</pre>
	</li>
	<li>
		<h3>Bandit14</h3>
		This was done by viewing the password of the users contained in the folder /etc/bandit_pass
		for the current user and submitting it via telnet
	</li>
	<li>
		<h3>Bandit15</h3>
		The ssh version of the above challenge. The only challenge is to incorporate a new line character after the banner is sent by the server. 
		<pre>
		openssl s_client -ign_eof -connect localhost:30001
		</pre>
		The flag <i>"ign_eof"</i> is used to allow for end of line to be entered to terminate the condition. 
	</li>
	<li>
		<h3>Bandit16</h3>
		Using nmap we can find out a range of open ports that support ssh
		<pre>
		nmap  -A -T4 -p 31000-32000 localhost
		</pre>
		After we get to know the port on which ssl is running, the tmp directory gets the sshkey.private being returned by the server, which is the private key of user <i>bandit17</i>
		The server will be running on some port which is not an echo server. Use openssl to connect to this ssh server in the eof mode as described in Bandit15. On entering the correct password, the server will reply back with an RSA private key for bandit user 17.
		<p>
		Copy the contents, create a file in the <i>tmp</i> directory.
		<b>Note: Change the permissions of the newly created file to be restrictive of read and write privilleges to only the current user or the ssh will reject the file as being too "unprotected". I set the permission to file to <i>700</i>. 
		</p>
	</li>
	<li>
		<h3>Bandit17</h3>
		Simple diff command of the 2 files will pop out the answer.
	</li>
	<li>
		<h3>Bandit18</h3>
		The machine logs you out as mentioned in the description due to changes in .bashrc which happens when user profile is loaded after a successful login. This can be overcome by chaining a command to ssh to be executed after successful login.
		<pre>
			ssh bandit18@localhost "cat readme"
		</pre>
	</li>
	<li>
		<h3>Bandit19</h3>
		The knowledge of <i>setuid</i> and <i>getuid</i> is useful. The commands basically allows users to execute certain executables as other users or groups and the command is used to set the appropriate bit on  the executable. For next level, the executable will allow us to read the bandit20's pass. Anyone executing the executable will run it as if it were bandit20 user running the executable. 
		<pre>
		./&gtexecutable name&lt cat /etc/bandit_pass/bandit20
		</pre>
	</li>
	<li>
		<h3>Bandit20</h3>
		<li>
		 	Using the same principles as above, except setup a netcat background process or use 2 parallel terminals. However since parallel terminals will lead to 2 different sessions and we want the output back from a process, I used a terminal multiplexer, like <i>screen</i>.
		 	Firstly we create a session using one ssh login. Then we setup a separate instance of screen, by using the tool <i>screen</i>. Once done, we setup a netcat listen as under.
		 	<pre>
nc -l -p 44444
		 	</pre>
		 	Detach from this screen by pressing <kbd>CTRL</kbd>+<kbd>a</kbd>,<kbd>d</kbd>
		</li>
	</li>
	</li>
	</ul>
