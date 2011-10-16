
include FactoryGirl
school = School.where(name:'Sierra Community College') || fail

def make_user fname, lname
  create(:user,
    :firstname => fname,
    :lastname => lname
    :school_id => school.id
  )
end


