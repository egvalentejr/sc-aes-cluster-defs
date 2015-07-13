#!/usr/bin/ruby

require 'json'

out=`aws ec2 describe-instances --instance-ids #{ARGV[0]}`

res=JSON.parse(out)
if not res
  exit 1
end

res['Reservations'].each do |instances|
  instances['Instances'].each do |i|
    tags=""
    i['Tags'].each do |t|
      tags="Key=#{t['Key']},Value=#{t['Value']} #{tags}"
    end
    i['BlockDeviceMappings'].each do |b|
      v=b['Ebs']['VolumeId']
      if v and tags
        puts "    volume: #{v}, tags: #{tags}"
        `aws ec2 create-tags --resources #{v} --tags #{tags}`
      end
    end
  end
end


