{
  platform: 'ec2',
  environment: 'production',
  roles: [ :base, :web ],
  sprinkle: {
    hostname: 'www'
  }
}
