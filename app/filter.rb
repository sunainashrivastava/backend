# frozen_string_literal: true

require 'time'
require './app/city'
require 'byebug'

class Filter
  attr_reader :dollar_format_params,
              :percent_format_params,
              :dollar_format_headers,
              :percent_format_headers,
              :dollar_format_rows,
              :percent_format_rows,
              :order

  def initialize(params)
    @dollar_format_params = params[:dollar_format]
    @percent_format_params = params[:percent_format]
    @order = params[:order].to_s
    rows
    extract_headers
  end

  def rows
    @dollar_format_rows = split_by_next_line(dollar_format_params)
    @percent_format_rows = split_by_next_line(percent_format_params)
  end

  def split_by_next_line(row)
    row.split("\n") if row
  end

  def split_by_dollar(row)
    row.split(' $ ') if row
  end

  def split_by_percent(row)
    row.split(' % ') if row
  end

  def sort_by_name(records)
    arranging_output(records.sort do |a, b|
      a[order] <=> b[order]
    end)
  end

  def arranging_output(records)
    records.map do |row|
      "#{row['first_name']}, #{city(row['city'])}, #{date_format(row['birthdate'])}"
    end
  end

  def extract_headers
    @dollar_format_headers = @dollar_format_rows.to_a.delete_at(0)
    @percent_format_headers = @percent_format_rows.to_a.delete_at(0)
  end

  def arranging_by_headers(rows, headers)
    rows.map { |e| headers.zip(e).to_h }
  end

  def result
    records = []
    records.push(
      arranging_by_headers(
        dollar_format_rows.map { |row| split_by_dollar(row) },
        split_by_dollar(dollar_format_headers)
      )
    ) if dollar_format_rows

    records.push(
      arranging_by_headers(
        percent_format_rows.map { |row| split_by_percent(row) },
        split_by_percent(percent_format_headers)
      )
    ) if percent_format_rows

    sort_by_name(records.flatten)
  end

  def city(city)
    City::CITY_ABBR_TO_NAME[city.to_sym] || city
  end

  def date_format(date)
    Time.parse(date).strftime('%-m/%-d/%Y')
  end
end
