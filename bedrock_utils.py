import boto3
from botocore.exceptions import ClientError
import json

# Initialize AWS Bedrock client
bedrock = boto3.client(
    service_name='bedrock-runtime',
    region_name='us-west-2'  # Replace with your AWS region
)

# Initialize Bedrock Knowledge Base client
bedrock_kb = boto3.client(
    service_name='bedrock-agent-runtime',
    region_name='us-west-2'  # Replace with your AWS region
)


def valid_prompt(query, model_id):
    try:
        if not query or len(query.strip()) == 0:
            return False

        guardrail_id = "xykbz3h2w1wt"
        version_id = "DRAFT"

        response = bedrock.apply_guardrail(
            guardrailIdentifier=guardrail_id,
            guardrailVersion=version_id,
            source="INPUT",
            content=[
                {
                    "text": {
                        "text": query
                    }
                }
            ],
            outputScope="FULL"
        )

        # Blocked prompt?
        if response.get("action") == "GUARDRAIL_INTERVENED":
            print("Prompt blocked:", response.get("actionReason", ""))
            return False
        else:
            return True
    except Exception as e:
        print("Error validating prompt:", e)
        return False


def query_knowledge_base(query, kb_id):
    try:
        response = bedrock_kb.retrieve(
            knowledgeBaseId=kb_id,
            retrievalQuery={"text": query}
        )
        return response.get('retrievalResults', [])
    except ClientError as e:
        print(f"Error querying Knowledge Base: {e}")
        return []
    
def generate_response(prompt, model_id, temperature, top_p):
    try:
        request_body = {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1024,
            "temperature": temperature,
            "top_p": top_p,
            "messages": [
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        }
        response = bedrock.invoke_model(
            modelId=model_id,
            body=json.dumps(request_body)
        )
        return json.loads(response['body'].read())['content'][0]["text"]
    except ClientError as e:
        print(f"Error generating response: {e}")
        return ""
