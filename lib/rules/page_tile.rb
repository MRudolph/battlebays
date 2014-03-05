module Rules
  module PageTile

    
    def tile_can_be_created?(tile,user)
      return false  if Rules.read(rules,:horz) && !tile_in_horizontal_limits(tile)
      return false  if Rules.read(rules,:vert) && !tile_in_vertical_limits(tile)
      return false  if !tiles.empty? && !tiles_next_to_just_active_tiles(tile)
      return false  if Rules.read(rules,:private) && self.user!=user
      true
    end
    
    def tile_can_be_activated?(tile,user)
      return false  if Rules.read(rules,:moderated) && moderators.include?(user)
      true
    end
    
    def tile_calculate_points(tile)
      return 0  if Rules.read(rules,:private)
      ( (tile.classify == :activated) ? 1 : 0 ) *tile.neighbours.activated.count(:conditions=>["activated_at <= ?",tile.activated_at])
    end
    
    def tile_in_horizontal_limits(tile)
      min = Rules.read(rules,[:horz,:min])
      max = Rules.read(rules,[:horz,:max])
      (!min || tile.x>=min ) && (!max || tile.x<=max )
    end
    def tile_in_vertical_limits(tile)
      min = Rules.read(rules,[:vert,:min])
      max = Rules.read(rules,[:vert,:max])
      (!min || tile.y>=min ) && (!max || tile.y<=max )
    end
    def tiles_next_to_just_active_tiles(tile)
      n=tile.neighbours
      (n.activated.count > 0) && (n.inactive.count == 0)
    end
    
  end
end
