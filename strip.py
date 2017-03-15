import re
from sys import argv,stdout

if __name__ == '__main__':
    if len(argv)<2:
        exit(0)
    else:
        text = open(argv[1]).read().strip().lower()
        m = re.compile('offset (\d+)');
        res = m.search(text)
        if res is not None:
            stdout.write(res.groups()[0])
            


