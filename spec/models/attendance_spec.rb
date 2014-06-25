# -*- coding: utf-8 -*-
require 'spec_helper'

describe Attendance do

  let(:user) { FactoryGirl.create(:user) }
  before { @attendance = user.attendances.build(attendance_date:"2014/06/28",
      year:"2014",
      month:"6",
      wday:"2",
      holiday:"0",
      pattern: "1",
      start_time: "9:00",
      end_time: "18:00",
      work_time: "8.00"
      ) }

  subject { @attendance }

  it { should respond_to(:attendance_date) }
  it { should respond_to(:year) }
  it { should respond_to(:month) }
  it { should respond_to(:wday) }
  it { should respond_to(:holiday) }
  it { should respond_to(:pattern) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:byouketu) }
  it { should respond_to(:kekkin) }
  it { should respond_to(:hankekkin) }
  it { should respond_to(:tikoku) }
  it { should respond_to(:soutai) }
  it { should respond_to(:gaisyutu) }
  it { should respond_to(:tokkyuu) }
  it { should respond_to(:furikyuu) }
  it { should respond_to(:yuukyuu) }
  it { should respond_to(:syuttyou) }
  it { should respond_to(:over_time) }
  it { should respond_to(:holiday_time) }
  it { should respond_to(:midnight_time) }
  it { should respond_to(:break_time) }
  it { should respond_to(:kouzyo_time) }
  it { should respond_to(:work_time) }
  it { should respond_to(:remarks) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @attendance.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank year" do
    before { @attendance.year = " " }
    it { should_not be_valid }
  end

  describe "with blank month" do
    before { @attendance.month = " " }
    it { should_not be_valid }
  end

  describe "with remarks that is too long" do
    before { @attendance.remarks = "a" * 21 }
    it { should_not be_valid }
  end

  describe '開始時刻9:00、終了時刻18:00の場合' do
    before {
      @pattern = user.kinmu_patterns.build(start_time:"9:00", end_time:"18:00", break_time: 1.00)

      @attendance_start_time = Time.local(@pattern.start_time.year, @pattern.start_time.month, @pattern.start_time.day, 9, 0, 0)
      @attendance_end_time = Time.local(@pattern.end_time.year, @pattern.end_time.month, @pattern.end_time.day, 18, 0, 0)
    }

    describe "実働時間が8時間であること" do
      subject { @attendance.send(:get_work_time, @pattern, @attendance_start_time, @attendance_end_time) }
      it { should == 8.00 }
    end

    describe "超過時間が0時間であること" do
      subject { @attendance.send(:get_over_time) }
      it { should == 0 }
    end

    describe "深夜時間が0時間であること" do
      subject { @attendance.send(:get_midnight_time, @attendance_start_time, @attendance_end_time) }
      it { should == 0 }
    end

    describe "控除時間が0時間であること" do
      subject { @attendance.send(:get_kouzyo_time) }
      it { should == 0 }
    end

    describe "遅刻でないこと" do
      subject { @attendance.send(:tikoku?, @pattern, @attendance_start_time) }
      it { should == false }
    end

    describe "半欠勤でないこと" do
      subject { @attendance.send(:hankekkin?, @pattern, @attendance_start_time) }
      it { should == false }
    end
  end
end
