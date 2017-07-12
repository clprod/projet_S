
local Tools={}

-- Cursor related
function Tools.CursorRendering(isGrabbed, isVisible)
  love.mouse.setGrabbed(isGrabbed)
  love.mouse.setVisible(isVisible)
end

function Tools.DrawCursor(cursorImage)
  love.graphics.draw(cursorImage, love.mouse.getX() - cursorImage:getWidth() / 2, love.mouse.getY() - cursorImage:getHeight() /2)
end

return Tools
