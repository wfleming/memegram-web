namespace :wtf do
  desc "remove harmful yaml"
  task :snafu => :environment do
    puts "* SNAFU CHECKER:"
    puts "** Files in config: #{Dir.entries(Rails.root + 'config').inspect}"
    
    if File.exist?(Rails.root + 'config' + 'instagram.yml')
      puts "* Found instagram config - deleting"
      begin
        FileUtils.rm(Rails.root + 'config' + 'instagram.yml')
      rescue Exception => e
        puts "DELETE FAILED: #{e}"
      end
    end
    
    if File.exist?(Rails.root + 'config' + 'aws.yml')
      puts"* found aws config - deleting"
      begin
        FileUtils.rm(Rails.root + 'config' + 'aws.yml')
      rescue Exception => e
        puts "DELETE FAILED: #{e}"
      end
    end
  end
end