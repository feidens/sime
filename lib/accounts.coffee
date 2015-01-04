AccountsTemplates.configure

  # Behaviour
  confirmPassword: true
  enablePasswordChange: false
  forbidClientAccountCreation: false
  overrideLoginErrors: true
  sendVerificationEmail: false

  # Appearance
  showAddRemoveServices: true
  showForgotPasswordLink: false
  showLabels: true
  showPlaceholders: true

  # Client-side Validation
  continuousValidation: true
  negativeFeedback: true
  negativeValidation: true
  positiveValidation: true
  positiveFeedback: true

  # Privacy Policy and Terms of Use
  privacyUrl: "privacy"
  termsUrl: "terms-of-use"

  # Redirects
  homeRoutePath: "/"
  redirectTimeout: 4000

  # Texts

  texts:
    button:
      changePwd: "Password Text"
      enrollAccount: "Enroll Text"
      forgotPwd: "Forgot Pwd Text"
      resetPwd: "Reset Pwd Text"
      signIn: "Sign In Text"
      signUp: "Sign Up Text"

  texts:
    title:
      changePwd: "Password Title"
      enrollAccount: "Enroll Title"
      forgotPwd: "Forgot Pwd Title"
      resetPwd: "Reset Pwd Title"
      signIn: "Sign In Title"
      signUp: "Sign Up Title"

AccountsTemplates.configureRoute "signIn",
  layoutTemplate: "SignInOutLayout"
  redirect: "/"

AccountsTemplates.configureRoute "signUp",
  layoutTemplate: "SignInOutLayout"
  redirect: "/"


AccountsTemplates.removeField "email"
AccountsTemplates.addFields [
  {
    _id: "username"
    type: "text"
    displayName: "username"
    required: true
    minLength: 3
  }
]

# Meteor.startup ->

  # process.env.MAIL_URL = 'smtp://your_username:your_password@smtp.sendgrid.net:587';
