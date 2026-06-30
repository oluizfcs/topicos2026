class StudiosController < ApplicationController
  def show
    @studio = Studio.find(params[:id])

    @movies = Movie.where(studio_ids: @studio.id).map do |m|
      {
        title: m.nome,
        subtitle: "<i class='bi bi-star-fill'></i> #{m.display_nota} • #{m.generos(2)} • #{m.data_lancamento.strftime("%Y")}".html_safe,
        obj: m,
        img: m.poster.image_url
      }
    end
  end
end
