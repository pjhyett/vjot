# context 'An Exhibit' do
#   
#   setup do
#     @amazonia = Exhibit[:name => 'Amazonia']
#   end
#   
#   specify 'has an animals association' do
#     [@amazonia, Exhibit.new].each do |exhibit|
#       exhibit.animals.class.should == DataMapper::Associations::HasAndBelongsToManyAssociation
#     end
#   end
#   
#   specify 'has many animals' do
#     @amazonia.animals.size.should == 2
#   end
#   
#   specify 'should load associations magically' do
#     Exhibit.all.each do |exhibit|
#       exhibit.animals.each do |animal|
#         animal.exhibits.should.include?(exhibit)
#       end
#     end
#   end
#   
# end