class Api::SudokuController < ApplicationController

    def create
        grid = params[:data]
        ans = false
        if (solve(grid))
            ans = true
        end 

        if !ans
            render json: {status: "No solution found for this"}
        end
    end

    private
    def solve(grid)
        rc = findUnassigned(grid)
        if(rc == 0)
            render json: {solution: grid}
            return true
        end
        col = (rc%10) - 1
        row = (rc/10) - 1
        
        for k in 1..9 do
            if(isSafe(grid, row, col, k))
                grid[row][col] = k
                if (solve(grid))
                    return true
                end
                grid[row][col] = 0 
            end
        end
        
        return false
    end

    def findUnassigned(grid)
        for i in 0..8 do
            for j in 0..8 do
                if grid[i][j] == 0
                    return (((i+1)*10) + (j+1))
                end
            end
        end
        return 0
    end

    def usedInCol(grid, col, num)
        for row in 0..8 do
            if grid[row][col] == num
                return true
            end
        end
        return false
    end

    def usedInRow(grid, row, num)
        for i in 0..8 do
            if grid[row][i] == num
                return true
            end
        end
        return false
    end

    def usedInBox(grid, boxStartRow, boxStartCol, num)
        for i in 0..2 do
            for j in 0..2 do
                if (grid[i + boxStartRow][j + boxStartCol] == num)
                    return true
                end
            end
        end
        return false
    end

    def isSafe(grid, row, col, num)
        return (!usedInRow(grid, row, num) && !usedInCol(grid, col, num) &&!usedInBox(grid, (row - (row%3)), (col - (col%3)), num) && grid[row][col] == 0)
    end

end
