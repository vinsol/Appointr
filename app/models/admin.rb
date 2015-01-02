class Admin < User
  APPOINTMENT_STATE_OPTIONS = [['Approved', 'approved'], ['Cancelled', 'cancelled'], ['Attended', 'attended'], ['Missed', 'missed']]
end