# Bandit
These are the easiest problems of the wargame prepping us for the reverse engineering and tougher challenges that lie ahead. We have a series of 34 machines to ssh into, and each machine holds the password to the next machine. It is highly recommended to solve the challenges on your own before proceeding to look for the solution. The solutions provided are for educational purposes only. The flags are in the file , bandit_flags.txt
<ol>
	<li>
		<h3>Bandit0</h3>
		Simply cat of the file, which reveals the flag. 
	</li>
	<li>
		<h3>Bandit1</h3>
		The filename has hyphen. So "cat" has to be told the filename is not a aprameter, so it was fed from the stdin using the following command.
		<pre>
			cat < -
		</pre>
		The flag is then revealed.
	</li>
	<li>
		<h3>Bandit2</h3>
		There are spaces in the filename. Easier than the last one, use cat "spaces in the filename".
		
	</li>
</ol>