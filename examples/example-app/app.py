import os

import boto3
import flask
from flask import jsonify

app = flask.Flask(__name__)


@app.route(
    '/identity',
    methods=["GET"],
    strict_slashes=False,
)
def queues():
    client = boto3.client('sts')
    response = client.get_caller_identity()
    return jsonify(response)


@app.route(
    '/admin/health',
    methods=["GET"],
    strict_slashes=False,
)
def liveness():
    return "Success\n"


@app.route(
    '/admin/ready',
    methods=["GET"],
    strict_slashes=False,
)
def readiness():
    return "Success\n"


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "5000"))
    # The host=0.0.0.0 is required for this to work correctly
    # within a docker container with ports forwarded.
    app.run(host="0.0.0.0", port=port)
