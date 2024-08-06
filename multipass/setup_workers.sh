workers=("kubeworker01" "kubeworker02")

for worker in "${workers[@]}"; do
    echo "Configuring $worker..."
    multipass transfer setup_worker.sh "$worker:/home/ubuntu/setup_worker.sh"
    multipass exec "$worker" -- sudo bash -c './setup_worker.sh'
done