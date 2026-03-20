git log --pretty=format:"%H" -n 5 | while read line; do
    echo -n "${line}$"
done

