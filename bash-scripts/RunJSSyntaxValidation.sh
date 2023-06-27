eslint_output_log_file="eslint_output.log"

for file in ${REPO_NAME}/changed-sources/force-app/main/default/staticresources/*.js
do
    echo "Checking ${file}"
    npx eslint $file > ${eslint_output_log_file}
done

for line in "${eslint_output_log_file[@]}"; do
    if [[ "$line" == *"error"* ]] || [[ "$line" == *"Error"* ]]
    then
        return 1
    fi
done