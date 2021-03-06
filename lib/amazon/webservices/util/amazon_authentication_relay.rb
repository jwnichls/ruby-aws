# Copyright:: Copyright (c) 2007 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

require 'amazon/webservices/util/command_line'
require 'amazon/webservices/util/request_signer'

module Amazon
module WebServices
module Util

class AmazonAuthenticationRelay

  REQUIRED_PARAMETERS = [:Name,:Transport]

  def initialize( args )
    missing_parameters = REQUIRED_PARAMETERS - args.keys
    raise "Missing paramters: #{missing_parameters.join(',')}" unless missing_parameters.empty?
    @name = args[:Name]
    @transport = args[:Transport]
    @keyId, @key = findAuthInfo( args )
  end

  def withCredential(credential,method,*request)
    time = Time.now.gmtime.strftime('%Y-%m-%dT%H:%M:%S.123Z')
    request[0] ||= {}
    args = { :AWSAccessKeyId => @keyId,
             :Timestamp => time,
             :Signature => RequestSigner.sign(@name,method,time,@key),
             :Credential => credential,
             :Request => request }
    @transport.send( method, args )
  end

  def method_missing(method, *request)
    time = Time.now.gmtime.strftime('%Y-%m-%dT%H:%M:%S.321Z')
    request[0] ||= {}
    args = { :AWSAccessKeyId => @keyId,
             :Timestamp => time,
             :Signature => RequestSigner.sign(@name,method,time,@key),
             :Request => request }
    @transport.send( method, args )
  end

  def to_s
    "AmazonAuthenticationRelay[name:#{@name} transport:#{@transport}]>"
  end

  def inspect
    "#<Amazon::WebServices::Util::AmazonAuthenticationRelay:#{object_id} name:#{@name} transport:#{@transport.inspect}>"
  end

  private

  def findAuthInfo( args )
    if args.has_key? :AWSAccessKey or args.has_key? :AWSAccessKeyId
      # user tried to pass authentication information in, so just use that
      raise "Missing AWSAccessKeyId" if args[:AWSAccessKeyId].nil?
      raise "Missing AWSAccessKey" if args[:AWSAccessKey].nil?
      return args[:AWSAccessKeyId], args[:AWSAccessKey]
    elsif ENV['AMAZON_ACCESS_KEY'] and ENV['AMAZON_SECRET_KEY']
      return ENV['AMAZON_ACCESS_KEY'], ENV['AMAZON_SECRET_KEY']
    else
      cmd = CommandLine.new
      cmd.checkuthConfig
    end
  end

end # AmazonAuthenticationRelay

end # Amazon::WebServices::Util
end # Amazon::WebServices
end # Amazon
