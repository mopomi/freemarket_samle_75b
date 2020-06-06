class ItemsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  
  def index
    @items = Item.all.order('id ASC').limit(3)
  end

  def new 

    @item =Item.new
    @item.item_imgs.build
    @category = Category.where(ancestry: "").limit(13)

  end

  def get_category_children  
    @category_children = Category.find(params[:parent_id]).children 
    end
 
  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
    end
  
  def show
    @items = Item.find(params[:id])
    @grandchild = Category.find(@items.category_id)
    @child = @grandchild.parent
    @parent = @child.parent
  end


  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to root_path
    else
      render "new"
    end
  end

  def destroy
    @items = Item.find(params[:id])
    @items.destroy
    redirect_to root_path
    
  end
  


  private
  def item_params
    params.require(:item).permit(
    :name, :introduction, :price,
    :brand, :item_condition, 
    :postage_payer, :prefecture_code,
    :preparation_day, :postage_type, :category_id,
    item_imgs_attributes: [:url, :_destroy, :id]).merge(seller_id: current_user.id)
  end

  def move_to_index
    redirect_to items_path unless user_signed_in?
  end
end


