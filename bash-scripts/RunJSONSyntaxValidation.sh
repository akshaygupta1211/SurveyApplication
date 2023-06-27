jsonlint_output_log_file="jsonlint_output.log"

for file in ${REPO_NAME}/changed-sources/force-app/main/default/staticresources/*.json
do
    npx jsonlint file > ${jsonlint_output_log_file}
done

for line in "${jsonlint_output_log_file[@]}"; do
    if [[ "$line" == *"error"* ]] || [[ "$line" == *"Error"* ]]
    then
        return 1
    fi
done