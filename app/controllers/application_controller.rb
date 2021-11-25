class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def load_csv(model, success_redirect_url, failure_redirect_url)
    if params[:file].blank?
      flash[:danger] = "ファイルを選択してください。"
      redirect_to failure_redirect_url
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = "拡張子が不正です。csvファイルを選択してください。"
      redirect_to failure_redirect_url
    else
      result = model.import(params[:file])
      if result == "all_saved"
        flash[:success] = "登録しました。"
        redirect_to success_redirect_url
      elsif result == "some_are_invalid"
        flash[:danger] = "一部、不正もしくは登録済みデータがありました。正しい未登録データのみ登録しました。"
        redirect_to success_redirect_url
      else
        flash[:danger] = "登録に失敗しました。データが不正です。"
        redirect_to failure_redirect_url
      end
    end
  end

end
