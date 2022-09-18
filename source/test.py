import os
import boto3
import wget
import json
import sys
import numpy as np
from cv2 import imread, resize, IMREAD_GRAYSCALE


stack_name = sys.argv[1]
commit_id = sys.argv[2]
endpoint_name = f"{stack_name}-{commit_id[:7]}"

runtime = boto3.client("runtime.sagemaker")

IMAGE_URL = "https://mlpipeline-pipeline-data-488176068240.s3.eu-west-1.amazonaws.com/MNIST_6_0.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXDKMPU2ILC7YWXNN%2F20220918%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20220918T122421Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=2474534a4a2fdc2f1b4264ca0ef83aedf349704f80027bb6fb4162ee42ce08df"
test_file = "test.jpg"
wget.download(
    IMAGE_URL,
    test_file,
)

image = imread(test_file, IMREAD_GRAYSCALE)
image = resize(image, (28, 28))
image = image.astype("float32")
image = image.reshape(1, 1, 28, 28)

payload = json.dumps(image.tolist())
response = runtime.invoke_endpoint(
    EndpointName=endpoint_name, Body=payload, ContentType="application/json"
)

result = response["Body"].read()
result = json.loads(result.decode("utf-8"))
print(f"Probabilities: {result}")

np_result = np.asarray(result)
prediction = np_result.argmax(axis=1)[0]
print(f"This is your number: {prediction}")

if prediction != 5:
    print("Model prediction failed.")
    sys.exit(1)

if os.path.exists(test_file):
    os.remove(test_file)
else:
    print("The file does not exist")
