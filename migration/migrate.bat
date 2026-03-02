set repo="https://github.com/UST-SEIS-745-Spring2026-Labs/lab-01-aws-emr-connecting-to-cloud-storage"

# Execute from within lab directory
for /f "delims=" %i in ('dir /B /A:-D *.docx') do set "doc=%i"
"%APPDATA%"\pandoc-3.9\pandoc --extract-media . -o README.md  "%doc%"

git init -b main
git add .
git commit -m "Initial commit"
git remote add origin "%repo%"
git push -u origin main
