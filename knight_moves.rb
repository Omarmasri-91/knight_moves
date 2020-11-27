class Position
    attr_accessor :position, :right, :left
    def initialize(position, left=nil, right=nil)
        @position = position
        @left = left
        @right = right
    end
end
class Tree
    attr_accessor :root, :possible_moves, :position
    def initialize(position)
        @position = position
        @possible_moves = (moves(position)).sort
        @root = Position.new(position)
        split_moves(@possible_moves)
    end
    def moves(position)
        x = position[0]
        y = position[1]
        arr=[]
        if x + 1 < 8
            if x + 2 < 8
                arr.push([x+2, y+1]) if y+1 < 8
                arr.push([x+2, y-1]) if y-1 > -1
            end
            arr.push([x+1, y+2]) if y+2 < 8
            arr.push([x+1, y-2]) if y-2 > -1 
        end
        if x - 1 > -1
            if x - 2 > -1
                arr.push([x-2, y+1]) if y+1 < 8
                arr.push([x-2, y-1]) if y-1 > -1
            end
            arr.push([x-1, y+2]) if y+2 < 8
            arr.push([x-1, y-2]) if y-2 > -1
        end
        return arr.sort
    end
    def insert (node, root=@root)
        if node.position[0] < root.position[0]
            root.left = node if root.left == nil
            insert(node, root.left) if root.left != nil
        elsif node.position[0] > root.position[0]
            root.right = node if root.right == nil
            insert(node, root.right) if root.right != nil
        elsif node.position[0] == root.position[0]
            if node.position[1] < root.position[1]
                root.left = node if root.left == nil
                insert(node, root.left) if root.left != nil
            elsif node.position[1] > root.position[1]
                root.right = node if root.right == nil
                insert(node, root.right) if root.right != nil
            end
        end
    end
    def split_moves(array)
        left=[]
        right=[]
        array.each do |element|
            left.push(element) if element[0] < root.position[0]
            right.push(element) if element[0] > root.position[0]
            if element[0] == root.position[0]
                left.push(element) if element[1] < root.position[1]
                right.push(element) if element[1] > root.position[1]
            end
        end
        build_tree(left.sort)
        build_tree(right.sort)
    end
    def build_tree(array, root=@root)
        return if array == nil || array.length == 0
        if array.length == 1
            node = Position.new(array[0])
            insert(node, root)
        end
        if array.length > 1
            left = array[0..(array.length/2)-1]
            left_node = Position.new(left[left.length/2])
            insert(left_node, root)
            build_tree(left, left_node)
            right = array[array.length/2..array.length-1]
            right_node = Position.new(right[right.length/2])
            insert(right_node, root)
            right.delete(root.position) if right.length > 1
            build_tree(right, right_node)
        end
    end
end
def knight_moves(start, finish)
    step = [nil, start]
    place = nil
    queue = [step]
    searched = []
    q = 0
    path=[]
    while place != finish
        place = (queue[q])[1]
        step = [place, Tree.new(place)]
        ((step[1]).possible_moves).each do |element|
            switch = "off"
            queue.each do |q_element|
                switch = "on" if element == q_element[1]
            end
            queue.push([place, element]) if switch == "off"
            queue = queue.uniq
        end
        place = search((step[1]).root, finish, step[1])
        q+=1 if place == nil
        queue = queue [0..q] if place != nil
        queue.push([place, finish]) if place != nil
        place = finish if place != nil
    end
    step = finish
    while step != start
        result = nil
        queue.each do |element|
            if element[1] == step
                path.unshift(element[1])
                result = element[0] if element[0] != nil
            end
        end
        step = result
    end
    path.unshift(start)
    print path
end
def search(start, finish, root)
    step = nil
    if (start.position)[0] < finish[0]
        step = search(start.right, finish, root) if start.right != nil
    elsif (start.position[0]) > finish[0]
        step = search(start.left, finish, root) if start.left != nil
    else
        if (start.position)[1] < finish[1]
            step = search(start.right, finish, root) if start.right != nil
        elsif (start.position[1]) > finish[1]
            step = search(start.left, finish, root) if start.left != nil
        else
            step = root.position
        end
    end
    return step
end
knight_moves([0,0], [3,3])
knight_moves([3,3], [0,0])