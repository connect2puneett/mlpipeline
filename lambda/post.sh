export IMG='number_5.png'
export URL='https://by6if7vzs3.execute-api.eu-west-1.amazonaws.com/api/'

# Download test image
echo -e "\n********************** Downloading test image **********************\n"
curl -o $IMG "https://mlpipeline-pipeline-data-488176068240.s3.eu-west-1.amazonaws.com/MNIST_6_0.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXDKMPU2ILC7YWXNN%2F20220918%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20220918T122421Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=2474534a4a2fdc2f1b4264ca0ef83aedf349704f80027bb6fb4162ee42ce08df"

echo -e "\n********************** POST request to Lambda **********************\n"
(echo -n '{"data": "'; base64 $IMG; echo '"}') |
curl -H "Content-Type: application/json" -d @- $URL | json_pp

# Remove test image
[ -e $IMG ] && rm $IMG
