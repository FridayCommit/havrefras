# Remove workaround string ("?array?")
cat test.json | sed 's/?array?//g' > tmp.json

# Convert csv strings to array
# Add owner to teams
# Add permissions to teams and extra_members 
cat tmp.json | jq '
    .extra_members |= split(",")'  | jq '
    .teams |= split(",")' | jq '
    .teams += [.owner]' | jq ' 
    .teams |= (map(sub("^.+/";"")) | map({name: .,permission: "write"}))' | jq '
    .extra_members |= (map(sub("^.+/";"")) | map({name: .,permission: "write"}))' > res.json

# Convert json to yaml
cat res.json | yq eval --prettyPrint | yq '
    . |=pick(["name","owner","visibility","teams","extra_members","labels"])' > repo.yaml

rm tmp.json res.json
