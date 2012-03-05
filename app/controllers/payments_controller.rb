class PaymentsController < ApplicationController
  skip_before_filter CAS::Filter, :except => [:edit]
  skip_before_filter AuthenticationFilter, :except => [:edit]
  
  before_filter :setup
  layout 'public'

  def create
    @payment = Payment.new(params[:payment])
    if @application.payments.length > 0
      @payment.errors.add_to_base("You have already submitted a payment for this application.")
      render :action => "error.rjs"
    else
      @payment.amount = @application.sleeve.fee_amount
      @payment.apply_id = @application.id
      @payment.status = 'Pending'
      if @payment.valid?
        case @payment.payment_type
          when "Credit Card"
            card_type = params[:payment][:card_type]
            
            creditcard = ActiveMerchant::Billing::CreditCard.new(
              :type       => card_type,
              :number     => @payment.card_number,
              :month      => @payment.expiration_month,
              :year       => @payment.expiration_year,
              :verification_value => @payment.security_code,
              :first_name => @payment.first_name,
              :last_name  => @payment.last_name
            )   
            
            if creditcard.valid?
              response = GATEWAY.purchase(@payment.amount * 100, creditcard)
          
              if response.success?
                @payment.approve!
                # TODO: Send notification email
              else
                @payment.errors.add_to_base("Credit card transaction failed: #{response.message}")
                #Send email this way instead of raising error in order to still give an error message to user.
                Notifier.deliver_notification(ExceptionNotifier.exception_recipients, # RECIPIENTS
                                    "si_error@uscm.org", # FROM
                                    "Credit Card Error", # LIQUID TEMPLATE NAME
                                    {'error' => "Credit card transaction failed: #{response.message}"})
              end
            else
              @payment.errors.add(:card_number, "is invalid.  Check the number and/or the expiration date.")
            end
          when "Mail"
            @payment.approve!
          when "Staff"
            @payment.save
            send_staff_payment_request(@payment)
        end
      end
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    # if this isn't a staff payment they shouldn't be here
    unless 'Staff' == @payment.payment_type
      redirect_to(:action => :no_access, :id => 'sorry') 
      return
    end
    @payment.status = "Approved" # set the status so a default radio button will be selected
  end

  def update
    @payment = Payment.find(params[:id])
    @payment.status = params[:payment][:status]
    staff_approval
    @payment.save!
    if (@payment.status == "Approved")
      # Send receipt to applicant
      Notifier.deliver_notification(@application.applicant.email, # RECIPIENTS
                                    "help@campuscrusadeforchrist.com", # FROM
                                    "Applicant Staff Payment Receipt", # LIQUID TEMPLATE NAME
                                    {'applicant_full_name' => @person.informal_full_name})
      # Send notice to Tool Owner
      Notifier.deliver_notification("stintandinternships@uscm.org", # RECIPIENTS - HARD CODED!
                                    "help@campuscrusadeforchrist.com", # FROM
                                    "Tool Owner Payment Confirmation", # LIQUID TEMPLATE NAME
                                    {'payment_amount' => "$" + @payment.amount.to_s,
                                     'payment_account_no' => @payment.payment_account_no,
                                     'payment_auth_code' => @payment.auth_code,
                                     'payment_id' => @payment.id})
    else
      # Sent notice to applicant that payment was declined
      Notifier.deliver_notification(@application.applicant.email, # RECIPIENTS
                                    "help@campuscrusadeforchrist.com", # FROM
                                    "Payment Refusal", # LIQUID TEMPLATE NAME
                                    {'applicant_full_name' => @person.informal_full_name})
    end
end

  def no_access
    render :layout => false
  end
  
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy
  end

private
  def setup
    @application = Apply.find(params[:application_id])
    @person = @application.applicant
  end  

  def send_staff_payment_request(payment)
    staff = Staff.find_by_accountNo(payment.payment_account_no)
    raise "Invalid staff payment request: " + payment.inspect if staff.nil?
    Notifier.deliver_notification(staff.email, # RECIPIENTS
                                  "help@campuscrusadeforchrist.com", # FROM
                                  "Staff Payment Request", # LIQUID TEMPLATE NAME
                                  {'staff_full_name' => staff.informal_full_name, # HASH OF VALUES FOR REPLACEMENT IN LIQUID TEMPLATE
                                   'applicant_full_name' => @person.informal_full_name, 
                                   'applicant_email' => @person.email, 
                                   'applicant_home_phone' => @person.current_address.homePhone, 
                                   'payment_request_url' => url_for(:action => :edit, :application_id => @application.id, :id => @payment.id)})
  end

protected
  def staff_approval
    @payment.auth_code = @payment.payment_account_no
    if @payment.status == "Other Account"
      @payment.payment_account_no = params[:other_account]
      @payment.approve!
    end
  end
    
end
