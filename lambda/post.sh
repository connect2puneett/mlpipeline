export IMG='number_5.png'
export URL=`chalice url`

# Download test image
echo -e "\n********************** Downloading test image **********************\n"
curl -o $IMG "https://mlpipeline-pipeline-data-488176068240.s3.eu-west-1.amazonaws.com/MNIST_6_0.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXDKMPU2ILC7YWXNN%2F20220618%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20220618T194117Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=85f050e14971c45803da0c805ecfc45a6044c90c7343c0fe96e8a71cd44402a4"

echo -e "\n********************** POST request to Lambda **********************\n"
(echo -n '{"data": "'; base64 $IMG; echo '"}') |
curl -H "Content-Type: application/json" -d @- $URL | json_pp

# Remove test image
[ -e $IMG ] && rm $IMG
