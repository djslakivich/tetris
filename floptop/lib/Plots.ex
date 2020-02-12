defmodule Plots do
  def new_location do
      {1,1}
  end
  def points(:i) do
   [
    {2,1},
    {2,2},
    {2,3},
    {2,4},
   ]
 # [ Transposed
 #   {1,2}, {2,2}, {3,2}, {4,2}
 # ]
  end
  def points(:l) do
   [
    {2,1},
    {2,2},
    {2,3}, {3,3}
   ]
  #[ Transposed
  # {1,2}, {2,2}, {3,2}
  #               {3,3}
  #]
  end
  def points(:o) do
   [
    {2,1}, {3,1},
    {2,2}, {3,2},
   ]
  #[ Transposed
  #  {1,2}, {1,3}
  #  {2,2}, {2,3}
  #]
  end
  def points(:z) do
   [
    {1,2}, {2,2},
           {2,3}, {3,3},
   ]
 # [ Transposed
 #   {2,1},
 #   {2,2}, {3,2},
 #          {3,3}
 # ]
  end
  def points(:t) do
   [
    {2,2}, {3,2}, {4,2},
           {3,3},
   ]
 # [  Transposed
 #  {2,2},
 #  {2,3}, {3,3}
 #  {2,4}
 # ]
  end
end
