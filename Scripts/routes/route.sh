# Crawl the websites and save logs
wget --spider --recursive --no-verbose --output-file=editorial.log http://editorial.com
wget --spider --recursive --no-verbose --output-file=dopetrope.log http://dopetrope.com
wget --spider --recursive --no-verbose --output-file=future-imperfect.log http://future-imperfect.com

# Extract URLs from logs (clean output to include only URLs)
grep -Eo "http://[a-zA-Z0-9./_-]+" editorial.log > editorial_routes.txt
grep -Eo "http://[a-zA-Z0-9./_-]+" dopetrope.log > dopetrope_routes.txt
grep -Eo "http://[a-zA-Z0-9./_-]+" future-imperfect.log > future_imperfect_routes.txt

# Combine all routes into one file
cat editorial_routes.txt dopetrope_routes.txt future_imperfect_routes.txt > all_routes.txt

# Deduplicate the combined routes
sort -u all_routes.txt -o final_routes.txt

# Verify the final file
cat final_routes.txt
