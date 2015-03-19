class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  require 'openssl'
  require 'base64'
  ALG = 'DES-EDE3-CBC'
  KEY = 'uryeiyel'
  DES_KEY = 'uygbfs3w'

  def encode(str)
    des = OpenSSL::Cipher::Cipher.new ALG
    des.pkcs5_keyivgen KEY, DES_KEY
    des.encrypt
    cipher = des.update str
    cipher << des.final
    Base64.urlsafe_encode64 cipher
  end

  def decode(str)
    str = Base64.urlsafe_decode64 str
    des = OpenSSL::Cipher::Cipher.new ALG
    des.pkcs5_keyivgen KEY, DES_KEY
    des.decrypt
    des.update(str) + des.final
  end

end
