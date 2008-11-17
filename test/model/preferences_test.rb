require File.expand_path('../../test_helper', __FILE__)
require 'preferences'

describe "Preferences namespaces" do
  it "should have instances of all section classes" do
    %w{ keyword dcc general sound theme }.each do |section|
      preferences.send(section).class.name.should == "Preferences::#{section.capitalize}"
    end
  end
  
  %w{ General Keyword Dcc Sound }.each do |section|
    it "should have set the correct default values for the `#{section}' namespace" do
      klass = Preferences.const_get(section)
      section_default_values = Preferences.default_values.select { |key, _| key.include? klass.section_defaults_key }
      section_default_values.should.not.be.empty
      section_default_values.each do |attr, value|
        preferences.send(section.downcase).send(attr.split('.').last).should == value
      end
    end
  end
end

def login_event_wrapper
  preferences.sound.events_wrapped.find { |s| s.display_name == 'Login' }
end

describe "Preferences::Sound" do
  it "should return sounds with their event names wrapped in a KVC compatible class" do
    display_names = Preferences::Sound::EVENTS.map { |e| e.last }
    preferences.sound.events_wrapped.each_with_index do |wrapper, index|
      wrapper.should.be.instance_of Preferences::Sound::SoundWrapper
      wrapper.display_name.should == display_names[index]
    end
  end
  
  it "should return SoundWrapper's initialized with their current `sound' value" do
    preferences.sound.login = 'Beep'
    login_event_wrapper.sound.should == 'Beep'
  end
end

describe "Preferences::Sound::SoundWrapper" do
  it "should update the `sound' value in the preferences which it represents" do
    preferences.sound.login = 'Furr'
    login_event_wrapper.setValue_forKey('Beep', 'sound')
    preferences.sound.login.should == 'Beep'
  end
  
  it "should write an empty string if the value chosen is Preferences::Sound::EMPTY_SOUND" do
    preferences.sound.login = 'Furr'
    login_event_wrapper.setValue_forKey(Preferences::Sound::EMPTY_SOUND, 'sound')
    preferences.sound.login.should.be.empty
  end
  
  it "should return Preferences::Sound::EMPTY_SOUND if the value in the preferences is empty" do
    preferences.sound.login = ''
    login_event_wrapper.sound = Preferences::Sound::EMPTY_SOUND
    login_event_wrapper.sound.should == Preferences::Sound::EMPTY_SOUND
  end
end