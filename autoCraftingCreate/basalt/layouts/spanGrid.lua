local spanGrid = {}

--- Calculates positions for all children in a span grid layout
--- @param instance table The layout instance
---   - container: the container to layout
---   - options: layout options
---     - rows: number of rows (optional, auto-calculated if not provided)
---     - columns: number of columns (optional, auto-calculated if not provided)
---     - spacing: gap between cells (default: 0)
---     - padding: padding around the grid (default: 0)
---     - spans: table where spans[row] = {startCol, endCol}
function spanGrid.calculate(instance)
  local container = instance.container
  local options = instance.options or {}

  local children = container.get("children")
  local containerWidth = container.get("width")
  local containerHeight = container.get("height")

  local spacing = options.spacing or 0
  local padding = options.padding or 0
  local rows = options.rows
  local columns = options.columns
  local spans = options.spans or {}

  local childCount = #children
  if childCount == 0 then
    instance._positions = {}
    return
  end

  -- Auto-calculate rows/columns if not provided
  if not rows and not columns then
    columns = math.ceil(math.sqrt(childCount))
    rows = math.ceil(childCount / columns)
  elseif rows and not columns then
    columns = math.ceil(childCount / rows)
  elseif columns and not rows then
    rows = math.ceil(childCount / columns)
  end

  if columns <= 0 then columns = 1 end
  if rows <= 0 then rows = 1 end

  -- Calculate available space (same as grid) [1](#4-0)
  local availableWidth = containerWidth - (2 * padding) - ((columns - 1) * spacing)
  local availableHeight = containerHeight - (2 * padding) - ((rows - 1) * spacing)

  if availableWidth < 1 then availableWidth = 1 end
  if availableHeight < 1 then availableHeight = 1 end

  -- Calculate base cell size [2](#4-1)
  local cellWidth = math.floor(availableWidth / columns)
  local cellHeight = math.floor(availableHeight / rows)

  if cellWidth < 1 then cellWidth = 1 end
  if cellHeight < 1 then cellHeight = 1 end

  -- Create grid occupancy map to handle spans
  local gridMap = {}
  for row = 1, rows do
    gridMap[row] = {}
    for col = 1, columns do
      gridMap[row][col] = false
    end
  end

  local positions = {}
  local childIndex = 1

  -- Process each row
  for row = 1, rows do
    local rowSpan = spans[row]

    if rowSpan then
      -- This row has a span: {startCol, endCol}
      local startCol = rowSpan[1]
      local endCol = rowSpan[2]
      local colSpan = endCol - startCol + 1

      -- Place spanned element
      if childIndex <= childCount then
        local child = children[childIndex]

        -- Mark cells as occupied
        for col = startCol, endCol do
          gridMap[row][col] = true
        end

        -- Calculate position and size
        local x = padding + 1 + ((startCol - 1) * (cellWidth + spacing))
        local y = padding + 1 + ((row - 1) * (cellHeight + spacing))

        local spanWidth = colSpan * cellWidth + ((colSpan - 1) * spacing)

        positions[child] = {
          x = x,
          y = y,
          width = spanWidth,
          height = cellHeight
        }

        childIndex = childIndex + 1
      end

      -- Place remaining elements in this row
      for col = 1, columns do
        if not gridMap[row][col] and childIndex <= childCount then
          local child = children[childIndex]
          gridMap[row][col] = true

          local x = padding + 1 + ((col - 1) * (cellWidth + spacing))
          local y = padding + 1 + ((row - 1) * (cellHeight + spacing))

          positions[child] = {
            x = x,
            y = y,
            width = cellWidth,
            height = cellHeight
          }

          childIndex = childIndex + 1
        end
      end
    else
      -- Normal row: place elements one by one
      for col = 1, columns do
        if childIndex <= childCount then
          local child = children[childIndex]
          gridMap[row][col] = true

          local x = padding + 1 + ((col - 1) * (cellWidth + spacing))
          local y = padding + 1 + ((row - 1) * (cellHeight + spacing))

          positions[child] = {
            x = x,
            y = y,
            width = cellWidth,
            height = cellHeight
          }

          childIndex = childIndex + 1
        end
      end
    end
  end

  instance._positions = positions
end

return spanGrid
