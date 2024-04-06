# Common issues

# bad interpreter: /bin/bash^M

zsh: ./generate-content.sh: bad interpreter: /bin/bash^M: no such file or directory

```bash
sed -i -e 's/\r$//' ./generate-content.sh
```
