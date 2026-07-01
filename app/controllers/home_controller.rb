require "mercadopago"

class HomeController < ApplicationController
  def index
    all_actor_ids = Movie.collection.aggregate([
      { "$unwind" => "$people" },
      { "$match" => { "people.tipo" => "ator" } },
      { "$group" => { _id: "$people.person_id" } }
    ]).map { |doc| doc["_id"] }

    @atores = Person.where(:id.in => all_actor_ids.sample(3))

    @filmes = Movie.order("reviews_count DESC").order("nota DESC").limit(3)

    @new_movies = Movie.order("data_lancamento DESC").limit(3)

    @reviews = Review.order(created_at: :desc).limit(6)
  end

  def buscar
    termo = Regexp.new(Regexp.escape(params[:q].squish), Regexp::IGNORECASE)

    people = Person.where(nome: termo).or(biografia: termo)
    movies = Movie.where(nome: termo).or(sinopse: termo)

    @pessoas = people.map do |p|
      linked_movies = Movie.where("people.person_id" => p.id)

      roles = linked_movies.flat_map do |m|
        m.people.select { |mp| mp.person_id == p.id }.map { |mp| mp.tipo.capitalize }
      end.uniq

      {
        title: p.nome,
        subtitle: roles.empty? ? "Nenhuma participação" : roles.join(" • "),
        obj: p,
        img: p.photos[0].image_url
      }
    end

    @filmes = movies.map do |m|
      {
        title: m.nome,
        subtitle: "<i class='bi bi-star-fill'></i> #{m.display_nota} • #{m.generos(2)} • #{m.data_lancamento.strftime("%Y")}".html_safe,
        obj: m,
        img: m.poster.image_url
      }
    end
  end

  def premium
    authenticate_user!

    redirect_to root_path, notice: "Você já é premium!" if current_user.premium
  end

  def process_payment
    sdk = Mercadopago::SDK.new(ENV["MERCADO_PAGO_ACCESS_TOKEN"])

    payment_data = {
      transaction_amount: params[:transaction_amount].to_f,
      token:              params[:token],
      description:        "Compra",
      installments:       params[:installments].to_i,
      payment_method_id:  params[:payment_method_id],
      payer: {
        email:          params.dig(:payer, :email),
        identification: {
          type:   params.dig(:payer, :identification, :type),
          number: params.dig(:payer, :identification, :number)
        }
      }
    }

    result  = sdk.payment.create(payment_data)
    payment = result[:response]

    if payment["status"] == "approved"
      current_user.update(premium: true)
    end

    render json: { status: payment["status"], id: payment["id"], detail: payment["status_detail"] }
  end
end
