--[[pod_format="raw",created="2024-03-29 07:46:31",modified="2024-05-01 19:27:15",revision=644]]
function word_wrap(str, maxWidthPx, keepIndent)
  keepIndent = (keepIndent == nil or keepIndent == true) and true or false
  result = ""
  indentCache = {}
  return "\014"..str:gsub(
    "([\n]*)"
    .."([^%S\n]*)"
    .."([^\n]+)",
    function(lineBreak, indent, line)
      if (string.dim(indent..line) <= maxWidthPx) then
        return lineBreak..indent..line
      end
      local indentWidthPx = indentCache[indent]
      if (indentWidthPx == nil) then
        indentCache[indent] = string.dim(indent)
        indentWidthPx = indentCache[indent]
      end
      local lineWidthPx = indentWidthPx
      local indentAfterWrap = indent
      if (not keepIndent) then
        indentAfterWrap = ""
        indentWidthPx = 0
      end
      return lineBreak .. indent .. line:gsub(
        "("
        .."(%s*)"
        .."(%S+)"
        ..")",
        function(chunk, space, word)
          chunkWidthPx = string.dim(chunk)
          if (lineWidthPx + chunkWidthPx > maxWidthPx) then
            lineWidthPx = indentWidthPx + string.dim(word)
            return "\n" .. indentAfterWrap .. word
          end
          lineWidthPx += chunkWidthPx
          return chunk
        end
      )
    end
  )
end