Erlaws provides Erlang interfaces to various Amazon WebService offerings.

= Description = 
Erlaws is a collection of client implementations of Amazon's WebServices offerings. Currently there are clients for EC2, S3, SQS and SDB.

= Build =

Issue `erl -make` to build the sources.
If you get 'error write file' errors, do `mkdir ebin`.

= Usage =

All erlaws modules (erlaws_s3, _sdb, _sqs, _ec2) are now parameterized modules. You can create a new instance of a modules using (example for erlaws_sdb):

SDB = erlaws_sdb:new(AWS_KEY, AWS_SEC_KEY, (true|false)).

The last parameter determines whether the connection should made using plain HTTP (false) or HTTPS (true).

In order to be able to use erlaws the "inets" and "crypto" application must be started.

= Documentation =

All available functions are documented in the .erl files for the service clients. 

Here a short overview:

== erlaws_s3 ==

  * list_buckets/0
  * create_bucket/1
  * create_bucket/2 (for EU and other region buckets)
  * delete_bucket/1
  * list_contents/1
  * list_contents/2
  * put_object/5
  * put_file/5
  * get_object/2
  * info_object/2
  * delete_object/2

== erlaws_sqs == 

  * list_queues/0
  * list_queues/1 
  * get_queue/1
  * create_queue/1
  * create_queue/2
  * get_queue_attr/1
  * set_queue_attr/3
  * delete_queue/1
  * send_message/2 
  * receive_message/1
  * receive_message/2
  * receive_message/3
  * delete_message/2

== erlaws_sdb ==

  * create_domain/1
  * delete_domain/1
  * list_domains/0
  * list_domains/1
  * put_attributes/3
  * batch_put_attributes/2
  * delete_item/2
  * delete_attributes/3
  * get_attributes/2
  * get_attributes/3
  * list_items/1
  * list_items/2 
  * query_items/2
  * query_items/3
  * select/1
  * select/2

== erlaws_ec2 ==

  * start_instances/1 
  * run_instances/13 
  * stop_instances/2
  * terminate_instances/1
  * describe_instances/0
  * describe_instances/1

== SimpleDB Intro ==
> inets:start().
ok
> ssl:start().
ok
> SDB = erlaws_sdb:new("<your aws access key>", "<your aws secret key">).
{erlaws_sdb,"<your aws access key>",
            "<your aws secret key>",true}

% To create a new domain
> SDB:create_domain("my_domain").
{ok,{requestId,"<request id here>"}}

% Create a new item in our new domain,
% which has name "item1", with one attribute named "surname",
% with one value "Suzuki".
> SDB:put_attributes("my_domain", "item1", [{"surname", ["Suzuki"]}]).
{ok,{requestId,"<request id here>"}}

% Create another attribute "givenname" within "Ichiro"
> SDB:put_attributes("my_domain", "item1", [{"givenname", ["Ichiro"]}]).

% Now item1 looks like this
> SDB:get_attributes("my_domain", "item1").
{ok,[{"item1",
      [{"givenname",["Ichiro"]},{"surname",["Suzuki"]}]}]}

% Add another item named "item2"
> SDB:put_attributes("my_domain", "item2", [{"surname", ["Asada"]}, {"givenname", ["Mao"}]).
{ok,{requestId,"<request id here>"}}

% Use select/1 for select queries.
> SDB:select("select * from my_domain").
{ok,[{"item1",
      [{"surname",["Suzuki"]},{"givenname",["Ichiro"]}]},
     {"item2",[{"surname",["Asada"]},{"givenname",["Mao"]}]}],
    []}


== SQS Intro ==
> inets:start().
ok
> ssl:start().
ok
> SQS = erlaws_sqs:new("<your aws access key>", "<your aws secret key">).
{erlaws_sqs,"<your aws access key>",
            "<your aws secret key>",true}
> rr(erlaws_sqs).
[s3_list_result,s3_object_info,sqs_message,sqs_queue,
 xmerl_event,xmerl_fun_states,xmerl_scanner,xmlAttribute,
 xmlComment,xmlContext,xmlDecl,xmlDocument,xmlElement,
 xmlNamespace,xmlNode,xmlNsNode,xmlObj,xmlPI,xmlText]

% Create a new queue.
> SQS:create_queue("my_queue")
{ok,"https://queue.amazonaws.com/my_queue",
    {requestId,"<request id here>"}}

% Send a message
> SQS:send_message("https://queue.amazonaws.com/my_queue", "hello").
{ok,#sqs_message{messageId = "<message id here>",
                 receiptHandle = [],
                 contentMD5 = "<md5 sum here>",
                 body = "hello"},
    {requestId,"<request id here>"}}

% Receive messages
> SQS:receive_message("https://queue.amazonaws.com/my_queue").
{ok,[#sqs_message{messageId = "<message id here>",
                  receiptHandle = "<some long receipt handle>",
                  contentMD5 = "<md5 sum here>",
                  body = "hello"}],
    {requestId,"<request id here>"}}

% Following immediate receive will return nothing.
> SQS:receive_message("https://queue.amazonaws.com/my_queue").
{ok,[],{requestId,"<request id here>"}}

% After some 30 seconds you can receive "hello" again.
> SQS:receive_message("https://queue.amazonaws.com/my_queue").
{ok,[#sqs_message{messageId = "<message id here>",
                  receiptHandle = "<some long receipt handle>",
                  contentMD5 = "<md5 sum here>",
                  body = "hello"}],
    {requestId,"<request id here>"}}

% Visibility timeout is defined in queue attributes.
> SQS:get_queue_attr("https://queue.amazonaws.com/my_queue").
{ok,[{"VisibilityTimeout",30},
     {"ApproximateNumberOfMessages",0}],
    {requestId,"<request id here>"}}

% To delete message from queue, use the "receiptHandle",
% which is a unique identifier for each item in the queue.
> SQS:delete_message("https://queue.amazonaws.com/my_queue", "<some long receipt handle>").
{ok,{requestId,"<request id here>"}}
