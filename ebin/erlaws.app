{application, erlaws, [
	{description, "Erlang AWS Clients"},
	{vsn, "0.0.1"},
	{registered, []},
	{applications, [kernel, stdlib, xmerl, crypto, inets]},
	{modules, [erlaws_ec2, erlaws_s3, erlaws_sdb, erlaws_sqs, erlaws_util]},
	{env, []}
]}.
